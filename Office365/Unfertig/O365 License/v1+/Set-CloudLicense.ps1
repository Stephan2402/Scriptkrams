<# 
    .SYNOPSIS 
    This script assigns Office 365 licenses to users depening on group membership.


    Version 1.0  

    .DESCRIPTION 
    
    
    .NOTES 
    Requirements 
    - 
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 

    This PowerShell script has been developed using ISESteroids - www.powertheshell.com 


    .PARAMETER 

    .EXAMPLE

#>

[CmdletBinding()]
Param(
  [string]$ConfigurationFile = 'settings.xml',
  [string]$LicenseName = 'Test',
  [switch]$UsePasswordFile = $false
)

# Import required modules
Import-Module -Name ActiveDirectory
Import-Module -Name MSOnline
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

$LocalAdUsers = @()

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')

function Get-SettingsFromFile {

  if(Test-Path -Path $(Join-Path -Path $ScriptDir -ChildPath $ConfigurationFile)) {
  
    try {
      # Load Script settings file
      [xml]$Config = [xml](Get-Content -Path "$(Join-Path -Path $ScriptDir -ChildPath $ConfigurationFile)")
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
    $script:UserSources = $Config.Settings.AdUserSources.UserSource
    $script:PasswordFile = $Config.Credentials.PasswordFile
    $script:KeyFile = $Config.Credentials.KeyFile
    Write-Host $script:PasswordFile
    Write-Host $script:KeyFile
    
    if($UsePasswordFile) {
      # Fetch script user credentials from config file
      $CloudLogin = $Config.Credentials.CloudLogin
      $LocalLogin = $Config.Credentials.LocalLogin
      
      if((Test-Path -Path $script:PasswordFile) -and (Test-Path -Path $script:KeyFile)) {
        # Fetch encrypted password and create credential objects 
        $logger.Write('Read account credentials from password file')
                
        $DecryptionKey = Get-Content -Path $script:KeyFile
        $SecurePassword = Get-Content -Path $script:PasswordFile | ConvertTo-SecureString -Key $DecryptionKey

        $script:AzureCredential = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $CloudLogin,$SecurePassword
        $script:LocalCredential = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $LocalLogin,$SecurePassword
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
    $logger.Write("Script exited: Settings file '$(ConfigurationFile)' missing",1)
    exit 99
  }
}

function Get-ActiveDirectoryUsers {
  foreach ($UserSource in $script:UserSources)
  {
    $logger.Write(('Get-ActiveDirectoryUsers {0} | Server {1} | {2}' -f $UserSource.Description, $UserSource.Server, $UserSource.LDapFilter))    

    $FetchedUsers = Get-ADUser -LDAPFilter $UserSource.LdapFilter -properties objectguid,mail,c -SearchScope Subtree -Server $UserSource.Server -Credential $script:LocalCredential -ResultSetSize $null 
    # $FetchedUsers=@()
    
    $Logger.Write(('Objects fetched from {0}: {1}' -f $UserSource.Server, ($FetchedUsers | Measure-Object).Count))

    # iterate each fetched user to calculate ImmutableId
    $LocalAdUsers = @()
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
  $SkippedUsers = 0
  $LocationErrors = 0
  $ActivatedUsers = 0
  
  # Let us check all local AD users
  foreach ($UnlicensedUser in $UnlicensedMsolUsers) {
    $logger.Write("Validating $($UnlicensedUser.UserPrincipalName)")
    
    if($UnlicensedUser.UserPrincipalName -like $script:MsolServiceDomainFilter) {
      # User has no proper synchronized UPN
      $logger.Write(('Skipping due to UPN {0}' -f ($script:MsolServiceDomainFilter)))
      $SkippedUsers++
    }
    else {
      # Find a local AD user object based on Azure ID ImmutableId property
      
      $MatchedLocalAdUser = $script:LocalAdUsers | Where-Object {$_.ImmutableId -eq $UnlicensedUser.ImmutableId}

      If($MatchedLocalAdUser -ne $null) {
        
        $logger.Write(('Matched User: {0}' -f $MatchedLocalAdUser.UserPrincipalName))
        
        # Verify, if usage location is set
        If($UnlicensedUser.UsageLocation) {
          # Usage location is setz, just write to log
          $logger.Write("Usage location set in AAD: [$($UnlicensedUser.UsageLocation)]")
        }
        elseif($MatchedLocalAdUser.Country) {
          # Usage location not set, so set location prior to license assignment
          $logger.Write("Setting usage location in AAD: [$($MatchedLocalAdUser.UsageLocation)]")
          Set-MsolUser -ObjectId $UnlicensedUser.ObjectId -UsageLocation $($MatchedLocalAdUser.Country)
          Start-Sleep -Seconds 10
        }
        else {
          # Usage location CANNOT be set, AD attribute is empty
          $logger.Write('Setting usage location in AAD failed, AD attribute is EMPTY')
          $LocationErrors++
          break
        }
        
        # Assign the license, if Exchange attributes are ready
          if($script:LicenseConfiguration.MsolAccountSku -ne $null) { 
            
            if($script:LicenseConfiguration.DisabledPlans -ne $null) {
            
              # Configure a license option
              $logger.Write(('Add license {0} with disabled plans {1}' -f $script:LicenseConfiguration.MsolAccountSku, $script:LicenseConfiguration.DisabledPlans))
              $LicenseOptions = New-MsolLicenseOptions -AccountSkuId $script:LicenseConfiguration.MsolAccountSku -DisabledPlans $script:LicenseConfiguration.DisabledPlans
              Set-MsolUserLicense -ObjectId $UnlicensedUser.objectId -AddLicenses $script:LicenseConfiguration.MsolAccountSku  -LicenseOptions $LicenseOptions
              $ActivatedUsers++
            }
            else { 
              # No Disabled plans
              $logger.Write(('Add license {0}' -f $script:LicenseConfiguration.MsolAccountSku))
              Set-MsolUserLicense -ObjectId $UnlicensedUser.objectId -AddLicenses $script:LicenseConfiguration.MsolAccountSku 
              $ActivatedUsers++
            }
          }
          else{
          #AccountSku not set in settings.xml
          $logger.Write('No or wrong AccountSku in settings.xml')
          }
      }
      else{
      $logger.Write("No matched User was found")
      }
    }
  }
  


}


## MAIN ####################################################################################################

# Get settings from 
Get-SettingsFromFile

# Connect to Office 365
Connect-MsolService -Credential $script:AzureCredential

  if($LicenseName -eq 'Test'){
  
    # DEFAULT license assignment
    
    $logger.Write('Fetching all UNLICENSED users from Azure AD')
    $UnlicensedMsolUsers = Get-MsolUser -UnlicensedUsersOnly -Synchronized -MaxResults $script:MsolUserMaxResults
    
    Get-ActiveDirectoryUsers
    
    Set-DefaultLicense    

  }

# We are finsihed
$stopWatch.Stop()
$elapsedTime = [String]::Format("{0:00}:{1:00}:{2:00}",$stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $elapsedTime)
$logger.Write('Script finished')