<# 
    .SYNOPSIS 
    Get BitLocker Drive Encryption key and send it to AD as Backup.
	
    Stephan Verstegen 
	
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
	
    Version 1.0, 2017-08-09
	
    Please send ideas, comments and suggestions to support@verstegen-online.de
	
    .LINK
    https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    
    .LINK
    
    .DESCRIPTION 
	This scripts find the RecoveryPassword KeyProtectorId for one Drive and give it to Domain as backup.
    Usefull to execute after Migration of Computer from one domain to another. 
    
    .NOTES 
    Requirements 
    - Evaluated PowerShell.exe
    - Windows 8.1 or higher
    - GlobalFunction Script see Links
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 
    
	
	
    .PARAMETER BitLockerDrive
    Set the Drive what is BitLocker Encrypted
	
    .PARAMETER 
	
    .PARAMETER 
	
    .EXAMPLE
    
    
#>

## Parameters ###############################################################################################

[CmdletBinding()]
Param(
  [string]$BitLockerDrive = 'C:'
)

## Prerequisets ###############################################################################################

# Import required modules
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Some global variables
$script:BitlockerID

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')

## FUNCTIONS ###############################################################################################


function Get-BitLockerKeyProtectorID {
    
    # Get BitLocker Volume
    $bitlockerVolume = Get-BitLockerVolume -MountPoint $BitLockerDrive

    # Get Recovery
    $bitlockerRecovery = $bitlockerVolume.KeyProtector |  where KeyProtectorType -eq RecoveryPassword

    # Get KeyProtectorID
    $bitlockerID = $bitlockerRecovery.KeyProtectorID

    Return $bitlockerID
}# end function

function Set-BitlockerID {
    
    #Backup to AD
    Backup-BitLockerKeyProtector -MountPoint $BitLockerDrive -KeyProtectorId $script:BitlockerID

}# end function


## MAIN ####################################################################################################

# Call Get Bitlocker ID
$script:BitlockerID = Get-BitLockerKeyProtectorID

# Call AD Backup


# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')