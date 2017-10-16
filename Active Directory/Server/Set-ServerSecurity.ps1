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
  [string]$ouBaseDN = 'OU=VerstegenTest,DC=BechtleMS,DC=local',
  [string]$servername = 'Testserver'

# Description
  [string]$ouDescription = 'OU Description',
  [string]$groupDescription = 'Group Description',

# Path
  [string]$gpoExportPath = 'C:\scripts\GPOBackup'

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
    
    if ($oucheck = "False") {
        $logger.Write("Server OU not found. Please create server OU!")
        Exit
    }
    else {
        # Create new group names
        $servernameUPPER = $servername.ToUpper()
        $newADMgroup = $groupPrefixADM + $servernameUPPER
        $newRDPgroup = $groupPrefixRDP + $servernameUPPER

        $groupcheck = 
        # Check if groups already exist
        if ($groupcheck = "False") {
            $logger.Write("New group name {1} already exist!" -f $newADMgroup)
        }
        else {
            
        }
    }
}

function Create-ADOrganizationalUnit {

    # Check if Base OU Exist
    $oucheck = [adsi]::Exists("LDAP://$ouBaseDN")

    if ($oucheck = "False" ) {
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

        if ($oucheck = "False") {
            $logger.Write("OU for server already exist! Skip OU creation")
        }
        else {
            # Create new OU
            New-ADOrganizationalUnit -Name $newOU -Description $ouDescription -Path $ouBaseDN -ProtectedFromAccidentalDeletion $true
            $logger.Write(("New OU {1} was created at {2}" -f $newOU, $ouBaseDN))
        } # End If
    } # End If
    
}

function Create-ServerGPO {
    
}



## MAIN ####################################################################################################

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')