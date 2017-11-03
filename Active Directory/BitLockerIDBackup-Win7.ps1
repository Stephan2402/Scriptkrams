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
    - Windows 7 or higher
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

# Some global variables

## FUNCTIONS ###############################################################################################

function Set-BitlockerID {
    
    #Backup to AD 
    .\batch.cmd

}# end function


## MAIN ####################################################################################################

# Call Get Bitlocker ID
Set-BitlockerID


# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')