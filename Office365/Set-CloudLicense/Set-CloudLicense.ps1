<# 
    .SYNOPSIS 
    This script assigns Office 365 licenses to users depening on group membership.


    Version 1.0  

    .DESCRIPTION 
    The scripts assigns licenses to either unlicensed users or already licensed users.

    Unlicensed users will have a "default" license configuration assigned, as configured in the settings.xml file.

    Licensed users will be assigned any named license configuration assigned, as configured in the settings. xml file.

    The settings.xml file is mandatory for the script.
    
    .NOTES 
    Requirements 
    - GlobalFunctions library as described here: http://scripts.granikos.eu
    
    Revision History 
    -------------------------------------------------------------------------------- 
    0.1      Initial release
    0.2      Add UsePasswordFile Option
    0.3      Add ChangeMode Option
    0.4      Add Remove function if user not "memeberof"
    0.5      Add Multi-AccountSkuId support


    This PowerShell script has been developed using ISESteroids - www.powertheshell.com 


    .PARAMETER ConfigurationFile
    Name of Xml configuration file, which is supposed to be in the same directory as the script

    .PARAMETER LicenseName
    License name to be assigned. The license name is defined in the configuration file.

    .PARAMETER UsePasswordFile
    Switch to use saved credentials

    .PARAMETER ChangeMode
    Switch to use ChangeMode; Change license services

    .EXAMPLE
    Set-CloudLicense -UsePasswordFile

    .EXAMPLE
    Set-CloudLicense.ps1 -LicenseName Default -ConfigurationFile settings.xml -UsePasswordFile

    .EXAMPLE
    Set-CloudLicense.ps1 -LicenseName Planner -ConfigurationFile settings.xml -UsePasswordFile -AddMode

    Assigns license scheme to group members as defined in the settings.xml file.

#>

[CmdletBinding()]
Param(
  [string]$ConfigurationFile = 'settings.xml',
  [string]$LicenseName = 'default',
  [switch]$UsePasswordFile,
  [switch]$ChangeMode
)

# Import required modules
Import-Module -Name ActiveDirectory
Import-Module -Name MSOnline
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name
$script:LocalAdUsers = @()

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')

function Get-SettingsFromFile {

  if(Test-Path -Path $(Join-Path -Path $ScriptDir -ChildPath $ConfigurationFile)) {
  
    try {
      # Load Script settings file
      [xml]$Config = [xml](Get-Content -Path $(Join-Path -Path $ScriptDir -ChildPath $ConfigurationFile))
    }
    catch {
      Write-Output 'Could not read settings file. Please check for valid Xml!'
      Throw $_.Exception.Message
    }
    
    # Fetch general configuration settings    
    $script:DomainController = $Config.Settings.DomainController
    $script:MsolUserMaxResults = $Config.Settings.MsolUserMaxResults
    $script:MsolServiceDomain = $Config.Settings.MsolServiceDomain
    $script:MsolServiceDomainFilter = ('*@{0}' -f $script:MsolServiceDomain)
    $script:PasswordFile = $Config.Settings.Credentials.PasswordFile
    $script:KeyFile = $Config.Settings.Credentials.KeyFile
    
    if($UsePasswordFile) {
      # Fetch script user credentials from config file
      $CloudLogin = $Config.Settings.Credentials.CloudLogin
      $LocalLogin = $Config.Settings.Credentials.LocalLogin
      
      if((Test-Path -Path $script:PasswordFile) -and (Test-Path -Path $script:KeyFile)) {
        # Fetch encrypted password and create credential objects 
        $logger.Write('Read account credentials from password file')
                
        $DecryptionKey = Get-Content -Path $script:KeyFile
        $SecurePassword = Get-Content -Path $script:PasswordFile | ConvertTo-SecureString -Key $DecryptionKey

        $script:AzureCredential = New-Object -TypeName System.Management.Automation.PSCredential ($CloudLogin,$SecurePassword)
        $script:LocalCredential = New-Object -TypeName System.Management.Automation.PSCredential ($LocalLogin,$SecurePassword)
      }
      else {
        # We need to have a license name, please.      
        Write-Output 'Script password file or key file do not exist.'
        $logger.Write('Script exited: Script password file or key file do not exist',2)
        Exit 97
      }
    }
    else {
      # Query for manually entered credentials
      $logger.Write('Query for manual account credentials')
      
      [pscredential]$script:AzureCredential = Get-Credential -Message 'Enter Office 365 credentials'
      [pscredential]$script:LocalCredential = Get-Credential -Message 'Enter local Active Directory credentials'
    }
    
    # Fetch license settings    
    if($LicenseName -ne '') {
    
      $script:LicenseConfiguration = $Config.Settings.Licenses.License | Where-Object{$_.Name -eq $LicenseName}
      $script:LicenseDisabledPlans = @($Script:LicenseConfiguration.DisabledPlans.Split(',').Trim())
      $script:LicenseRemovedPlans = @($Script:LicenseConfiguration.RemovedPlans.Split(',').Trim())
      # Fetch user source
      $script:UserSources = $Script:LicenseConfiguration.UserSource
    }
    else {
      # We need to have a license name, please. 
      Write-Output 'No license name specified.'
      $logger.Write('Script exited: No license name specified',2)
      Exit 98
    }
    
  }
  else {
    # Ooops, the configuration file could not be found
    Write-Error -Message "Settings file '$(ConfigurationFile)' missing"
    $logger.Write("Script exited: Settings file '$(ConfigurationFile)' missing",1)
    exit 99
  }
}

function Get-LicenseIndex {
    # Table for existing AccountSkuId`s with normal names
    $hashtblAccountSKUID = @{"ENTERPRISEPACK" = "Office 365 Enterprise E3";  
    "EMSPREMIUM" = "Enterprise Mobility + Security E5"} 
 
    #Needed service name 
    $ServiceName = $LicenseName
 
    # Get license configuration
    $licInfo = Get-MsolAccountSku | where {$_.AccountSkuId -eq "bechtle042017:ENTERPRISEPACK"}

    # Split license name from tenantId
    $licName = $hashtblAccountSKUID.Get_Item($licInfo.accountskuid.split(":")[1]) 

    # Set license index to $null
    $script:licIndex = $null

    # Find service name and save index number
            for ($i=0; $i -le ($licInfo.Servicestatus.ServicePlan.ServiceName.Count-1); $i++){ 
                    if ($ServiceName -contains $licInfo.Servicestatus.ServicePlan.ServiceName[$i]){ 
                    $script:licIndex = $i 
                    break 
                    }

                }
  
}

function Get-ActiveDirectoryUsers {
  foreach ($UserSource in $script:UserSources)
  {
    $logger.Write(('Get-ActiveDirectoryUsers {0} | Server {1} | {2}' -f $UserSource.Description, $UserSource.Server, $UserSource.LDapFilter))    

    $FetchedUsers = Get-ADUser -LDAPFilter $UserSource.LdapFilter -properties objectguid,mail,c -SearchScope Subtree -Server $UserSource.Server -Credential $script:LocalCredential -ResultSetSize $null 
    
    $Logger.Write(('Objects fetched from {0}: {1}' -f $UserSource.Server, ($FetchedUsers | Measure-Object).Count))

    # iterate each fetched user to calculate ImmutableId   
    foreach ($FetchedUser in $FetchedUsers)
    {
      $ImmutableId = ''
      
      $Guid = [GUID]$FetchedUser.objectguid
      $ImmutableId = [System.Convert]::ToBase64String($Guid.ToByteArray())
            
      $UserObject = [PSCustomObject]@{
        'UserPrincipalName' = $FetchedUser.UserPrincipalName
        'ObjectGuid' = $FetchedUser.objectguid
        'Mail' = $FetchedUser.mail
        'Country' = $FetchedUser.c
        'ImmutableId' = $ImmutableId
      }
      
      $script:LocalAdUsers += $UserObject
    }
  }
}

function Set-DefaultLicense {

  # Summarize what we do
  $script:SkippedUsers = 0
  $script:LocationErrors = 0
  $script:ActivatedUsers = 0
  $script:ChangedUsers = 0
  
  # Let us check all local AD users
 
  foreach ($FetchedMsolUser in $FetchedMsolUsers) {

    $logger.Write(('Validating {0}' -f $FetchedMsolUser.UserPrincipalName))
    
    if($FetchedMsolUser.UserPrincipalName -like $script:MsolServiceDomainFilter) {
      # User has no proper synchronized UPN
      $logger.Write(('Skipping due to UPN {0}' -f ($script:MsolServiceDomainFilter)))
      $script:SkippedUsers++
    }
    else {

      # Find a local AD user object based on Azure ID ImmutableId property
      $MatchedLocalAdUser = $script:LocalAdUsers | Where-Object {$_.ImmutableId -eq $FetchedMsolUser.ImmutableId}
      
      If($MatchedLocalAdUser -ne $null) {
        
        $logger.Write(('Matched User: {0}' -f $MatchedLocalAdUser.UserPrincipalName))
        
        # Verify, if usage location is set
        If($FetchedMsolUser.UsageLocation) {
          # Usage location is setz, just write to log
          $logger.Write(('Usage location set in AAD: [{0}]' -f $FetchedMsolUser.UsageLocation))
        }
        elseif($MatchedLocalAdUser.Country) {
          # Usage location not set, so set location prior to license assignment
          $logger.Write(('Setting usage location in AAD: [{0}]' -f $MatchedLocalAdUser.Country))
          Set-MsolUser -ObjectId $FetchedMsolUser.ObjectId -UsageLocation $($MatchedLocalAdUser.Country)
          Start-Sleep -Seconds 10
        }
        else {
          # Usage location CANNOT be set, AD attribute is empty
          $logger.Write('Setting usage location in AAD failed, AD attribute is EMPTY')
          $script:LocationErrors++
          break
        }
        
        # Assign the license
        if($script:LicenseConfiguration.MsolAccountSku) { 
            
          if($script:LicenseConfiguration.DisabledPlans -ne '') {
            
            # Configure a license option
            

            # Define license configuration
            $LicenseOptions = New-MsolLicenseOptions -AccountSkuId $script:LicenseConfiguration.MsolAccountSku -DisabledPlans $script:LicenseDisabledPlans

            if($ChangeMode -eq $false){
              # Add new License
              $logger.Write(('Add license {0} with disabled plans {1}' -f $script:LicenseConfiguration.MsolAccountSku, $script:LicenseConfiguration.DisabledPlans))
              Set-MsolUserLicense -ObjectId $FetchedMsolUser.objectId -AddLicenses $script:LicenseConfiguration.MsolAccountSku -LicenseOptions $LicenseOptions
              $script:ActivatedUsers++
              Start-Sleep -Seconds 1
            }
            else{
              # Change license options
              $logger.Write(('Change license {0} with disabled plans {1}' -f $script:LicenseConfiguration.MsolAccountSku, $script:LicenseConfiguration.DisabledPlans))
              Set-MsolUserLicense -ObjectId $FetchedMsolUser.objectId -LicenseOptions $LicenseOptions
              $script:ChangedUsers++
              Start-Sleep -Seconds 1
            }
          }
          else { 
            # No Disabled plans
            $logger.Write(('Add license {0}' -f $script:LicenseConfiguration.MsolAccountSku))
            Set-MsolUserLicense -ObjectId $FetchedMsolUser.objectId -AddLicenses $script:LicenseConfiguration.MsolAccountSku 
            $script:ActivatedUsers++
          }
        }
        else {
          $logger.Write('Cannot find any configured MsolAccountSku in settings.xml')
        }
      }
      else {
          # Remove a license option
            $logger.Write(('User not matched: {0}' -f $FetchedMsolUser.UserPrincipalName))
            
            # Logging
            $logger.Write(('Remove license option: {0}' -f $LicenseName))

            # Define license configuration
            $LicenseOptions = New-MsolLicenseOptions -AccountSkuId $script:LicenseConfiguration.MsolAccountSku -DisabledPlans $script:LicenseRemovedPlans
            
            # Change license options
            Set-MsolUserLicense -ObjectId $FetchedMsolUser.objectId -LicenseOptions $LicenseOptions
            $script:ChangedUsers++
            Start-Sleep -Seconds 1
                  
      }
    }
  }
}


## MAIN ####################################################################################################

# Get settings from xml 
Get-SettingsFromFile

if($script:AzureCredential -ne $null) {


  # Connect to Office 365
  Connect-MsolService -Credential $script:AzureCredential
  
  # DEFAULT license assignment
  if($LicenseName -eq 'default'){
  
    
    
    $logger.Write('Fetching all UNLICENSED users from Azure AD')
    $FetchedMsolUsers = Get-MsolUser -UnlicensedUsersOnly -Synchronized -MaxResults $script:MsolUserMaxResults
    $logger.Write(('Found {0} unlicensed users' -f ($FetchedMsolUsers | Measure-Object).Count))
    
    Get-ActiveDirectoryUsers
    
    Set-DefaultLicense
    


  }

  # DEFAULT EMS license assignment
  if($LicenseName -eq 'EMS-Default'){
  
    $logger.Write('Fetching all LICENSED users from Azure AD')
    $FetchedMsolUsers = Get-MsolUser -Synchronized -MaxResults $script:MsolUserMaxResults | Where-Object { $_.isLicensed -eq 'TRUE' }
    $logger.Write(('Found {0} licensed users' -f ($FetchedMsolUsers | Measure-Object).Count))
    
    Get-ActiveDirectoryUsers
    
    Set-DefaultLicense
    


  }

  # MFA_PREMIUM license assignment / removal
  if($LicenseName -eq 'MFA_PREMIUM'){
  
    $logger.Write('Fetching all LICENSED users from Azure AD')
    $FetchedMsolUsers = Get-MsolUser -Synchronized -MaxResults $script:MsolUserMaxResults | Where-Object { $_.isLicensed -eq 'TRUE' }
    $logger.Write(('Found {0} licensed users' -f ($FetchedMsolUsers | Measure-Object).Count))
    
    Get-ActiveDirectoryUsers
    
    Set-DefaultLicense
    


  }

  # PROJECTWORKMANAGEMENT license assignment / removal
  if($LicenseName -eq 'PROJECTWORKMANAGEMENT'){
  

    # Get index numbers from specified license
    #Get-LicenseIndex

    
    $logger.Write('Fetching all LICENSED users from Azure AD')
    # Fetch all Users where license option is activated
    $FetchedMsolUsers = Get-MsolUser -Synchronized -MaxResults $script:MsolUserMaxResults | Where-Object { $_.isLicensed -eq 'TRUE' } 
    $logger.Write(('Found {0} licensed users' -f ($FetchedMsolUsers | Measure-Object).Count))
    
    Get-ActiveDirectoryUsers
    
    Set-DefaultLicense    

  }

}

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Skipped users: {0}' -f $script:SkippedUsers)
$logger.Write('Location errors: {0}' -f $script:LocationErrors)
$logger.Write('Activated users: {0}' -f $script:ActivatedUsers)
$logger.Write('Changed users: {0}' -f $script:ChangedUsers)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')