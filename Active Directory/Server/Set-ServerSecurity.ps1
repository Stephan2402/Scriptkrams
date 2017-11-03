<# 
    .SYNOPSIS 
    <DESCRIPTION>
	
    Stephan Verstegen 
	
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
	
    Version 1.0, 2017-08-09
	
    Please send ideas, comments and suggestions to support@verstegen-online.de
	
    .LINK 
    
    .LINK
    
    .DESCRIPTION 
	<DESCRIPTION>
    
    .NOTES 
    Requirements 
    -
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 
    
	
	
    .PARAMETER
	
    .PARAMETER 
	
    .PARAMETER 
	
    .EXAMPLE
    
    
#>

## Parameters ###############################################################################################

[CmdletBinding()]
Param(

# Prefix
  [string]$ouPrefix = 'OU_',
  [string]$groupPrefixADM = 'ADM_',
  [string]$groupPrefixRDP = 'RDP_',
  [string]$gpoTargetNamePrefix = 'GPO_',
# Templates
  [string]$gpoTemplate = 'Verstegen_ADM_Server',
  [string]$ADMTemplate = 'ADM_LocalAdministratorsTemplate',
  [string]$RDPTemplate = 'ADM_RemoteDesktopUsersTemplate',
# Settings
  [string]$ouBaseDN = 'OU=Servers,OU=VerstegenTest,DC=BechtleMS,DC=local',
  [string]$servername = 'Testserver',
  [boolean]$protected = $false,
# Description
  [string]$ouDescription = 'OU Description',
  [string]$groupDescription = 'Group Description',
# Path
  [string]$gpoExportFolder = 'GPOBackup',
  [string]$groupPath = 'OU=Groups,OU=VerstegenTest,DC=BechtleMS,DC=local',
  [string]$gpoGroupsSettingsPath = "\DomainSysvol\GPO\Machine\Preferences\Groups\Groups.xml"

)

## Prerequisets ###############################################################################################

# Import required modules
Import-Module -Name ActiveDirectory 
Import-Module -Name GroupPolicy
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')

## FUNCTIONS ###############################################################################################

function Create-ADServerGroups {
    # Check if Computer OU exist
    $serverDN = "OU=" + $servername + "," + $ouBaseDN
    $oucheck = [adsi]::Exists("LDAP://$serverDN")
    
    if ($oucheck -eq $false) {
        $logger.Write("Server OU not found. Please let create server OU from function before")
        Exit
    }
    else {
        # Create new group names
        $servernameUPPER = $servername.ToUpper()
        $newADMgroup = $groupPrefixADM + $servernameUPPER
        $newRDPgroup = $groupPrefixRDP + $servernameUPPER

        # Check if ADM group already exist
        try {
            Get-ADGroup -Identity $newADMgroup -ErrorAction Stop
            $logger.Write("New group name {0} already exist!" -f $newADMgroup)
        } # end try
        catch {
            $logger.Write("Create new AD Group: {0}" -f $newADMgroup)
            New-ADGroup -Name $newADMgroup -DisplayName $newADMgroup -Description $groupDescription -Path $groupPath -GroupCategory Security -GroupScope DomainLocal -Confirm:$false 

        } # end catch

        # Check if RDP group already exist
        try {
            Get-ADGroup -Identity $newRDPgroup -ErrorAction Stop
            $logger.Write("New group name {0} already exist!" -f $newADMgroup)
        } # end try
        catch {
            $logger.Write("Create new AD Group: {0}" -f $newRDPgroup)
            New-ADGroup -Name $newRDPgroup -DisplayName $newRDPgroup -Description $groupDescription -Path $groupPath -GroupCategory Security -GroupScope DomainLocal -Confirm:$false 

        } # end catch
    } #end else
} # end function

function Create-ADOrganizationalUnit {

    # Check if Base OU Exist
    $oucheck = [adsi]::Exists("LDAP://$ouBaseDN")

    if ($oucheck -eq $false) {
        $logger.Write("Base OU not found. Please correct Base OU!")
        Exit
    } 
    else {
        # Create new OU Name
        $newOU = $servername
        # Create DN 
        $newDN = "OU=" + $servername + "," + $ouBaseDN
        # Check if new OU already exist
        $oucheck = [adsi]::Exists("LDAP://$newDN")

        if ($oucheck -eq $true) {
            $logger.Write("OU for server already exist! Skip OU creation")
        }
        else {
            # Create new OU
            New-ADOrganizationalUnit -Name $newOU -Description $ouDescription -Path $ouBaseDN -ProtectedFromAccidentalDeletion $protected
            $logger.Write(("New OU {0} was created at {1}" -f $newOU, $ouBaseDN))
        } # End If
    } # End If
    
}

function Create-ServerGPO {

    # Check if Backup path exist
    $gpoBackupPath = $ScriptDir + "\" + $gpoExportFolder
    If (Test-Path -Path $gpoBackupPath) {
        $logger.write(('GPO Backup Path "{0}" already exist' -f $gpoExportFolder))

    } #end if
    else {
        # Create new Folder
        $newitem = New-Item -ItemType Directory -Path $ScriptDir -Name $gpoExportFolder
        $logger.write(('GPO Backup Path "{0}" created' -f $gpoExportFolder))
    }#end else

    # Backup Template GPO for modification and get random ID
    $gpoBackup = Backup-GPO -Name $gpoTemplate -Path $gpoBackupPath 
    $gpoBackupID = $gpoBackup.Id
    $logger.write(('GPO Backup was made from "{0}" and ID is: {1}' -f $gpoTemplate, $gpoBackupID))

    # Get Content from GPO XML file
    $xmlFilePath = $gpoExportFolder + "\{" + $gpoBackupID + "}" + $gpoGroupsSettingsPath

    # Set new group names
    $servernameUPPER = $servername.ToUpper()
    $newADMgroup = $groupPrefixADM + $servernameUPPER
    $newRDPgroup = $groupPrefixRDP + $servernameUPPER

    # Prepare GPO Settings
    $ServerAdminGroup = Get-ADGroup $newADMgroup -ErrorAction SilentlyContinue
    $ServerAdminTemplate = Get-ADGroup $ADMTemplate -ErrorAction SilentlyContinue
    $RDPAdminGroup = Get-ADGroup $newRDPgroup -ErrorAction SilentlyContinue
    $RDPAdminTemplate = Get-ADGroup $RDPTemplate -ErrorAction SilentlyContinue
    $logger.write(('GPO Settings - ADM Group: {0} | RDP Group: {1}' -f $ServerAdminGroup, $RDPAdminGroup))

    if (($ServerAdminGroup -ne $null) -AND ($ServerAdminTemplate -ne $null) -AND ($RDPAdminGroup -ne $null) -AND ($RDPAdminTemplate -ne $null)) {
        
        # Replace Server Admin group
        $logger.write(('Replace {0} with {1} in {2}' -f $ServerAdminTemplate.Name, $ServerAdminGroup.Name, $xmlFilePath))
        $replace = (Get-Content $xmlFilePath) -replace $ServerAdminTemplate.Name, $ServerAdminGroup.Name
        $doit = Set-Content -Path $xmlFilePath -Value $replace

        # Replace Server Admin group SID
        $logger.write(('Replace {0} with {1} in {2}' -f $ServerAdminTemplate.SID, $ServerAdminGroup.SID, $xmlFilePath))
        $replace = (Get-Content $xmlFilePath) -replace $ServerAdminTemplate.SID, $ServerAdminGroup.SID
        $doit = Set-Content -Path $xmlFilePath -Value $replace

        # Replace RDP Admin group
        $logger.write(('Replace {0} with {1} in {2}' -f $RDPAdminTemplate.Name, $RDPAdminGroup.Name, $xmlFilePath))
        $replace = (Get-Content $xmlFilePath) -replace $RDPAdminTemplate.Name, $RDPAdminGroup.Name
        $doit = Set-Content -Path $xmlFilePath -Value $replace

        # Replace RDP Admin group SID
        $logger.write(('Replace {0} with {1} in {2}' -f $RDPAdminTemplate.SID, $RDPAdminGroup.SID, $xmlFilePath))
        $replace = (Get-Content $xmlFilePath) -replace $RDPAdminTemplate.SID, $RDPAdminGroup.SID
        $doit = Set-Content -Path $xmlFilePath -Value $replace

        # Fetch Names
        $SourcePath = $gpoBackupPath + "\{" + $gpoBackup.Id + "}"
        $TargetPath = $gpoBackupPath + "\" + $gpoTargetNamePrefix + $servernameUPPER
        $TargetName = $gpoTargetNamePrefix + $servernameUPPER

        # Import GPO 
        $import = Import-GPO -BackupId $gpoBackup.Id -Path $gpoBackupPath -TargetName $TargetName -CreateIfNeeded -ErrorAction SilentlyContinue
        $logger.write(('GPO {0} was created' -f $TargetName))
        
        # Rename GPO
        $move = Move-Item -Path $SourcePath -Destination $TargetPath -ErrorAction SilentlyContinue
        $logger.write(('GPO Foldername changed from "{0}" to "{1}"' -f $SourcePath, $TargetName))

        # Delete Authenticated Users from GPO Apply
        #$getgpo = Get-GPO -Name $TargetName | Set-GPPermission -Replace -TargetName "Authentifizierte Benutzer" -TargetType Group -PermissionLevel None -Confirm:$false

        # Add Server to GPO Apply
        #$getgpo = Get-GPO -Name $TargetName | Set-GPPermission -TargetName $servername -TargetType Computer -PermissionLevel GpoApply

        # Link to OU and activate
        $ou = Get-ADOrganizationalUnit -Filter * | Where-Object {$_.Name -eq $servername}
        $getgpo = Get-GPO $TargetName | New-GPLink -Target $ou.DistinguishedName -LinkEnabled Yes -ErrorAction SilentlyContinue
        $logger.write(('GPO was linked and activated to: {0}' -f $ou.DistinguishedName)) 


    } #end if
    else {
       # One of the groups was not found
       $logger.write('One of the groups were not found in AD: Server Admin Group, RDP Admin Group, Server Admin Template, RDP Admin Template')
    } #end else

}



## MAIN ####################################################################################################

# Call Create-ADOrganizationalUnit
Create-ADOrganizationalUnit

# Call Create-ADServerGroups
Create-ADServerGroups

# Call Create-ServerGPO
Create-ServerGPO

$logger.write(('Server: {0} is ready to use!' -f $servername)) 

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')