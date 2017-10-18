<# 
    .SYNOPSIS 
    Delete Outlook Profiles for Outlook 2010 completly 
       
    Stephan Verstegen 
       
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
       
    Version 1.0, 2017-10-18
       
    Please send ideas, comments and suggestions to support@verstegen-online.de
       
    .LINK GlobalFuntions
    https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    
    .DESCRIPTION 
       This script delete Outlook Profiles for Outlook 2010 completly. Including regkeys and AppData.
    
    .NOTES 
    Requirements 
    - Global Functions Module * Install-Module GlobalFunctions on PowerShell 5 OR https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    - PowerShell
    - Script on Netlogon folder
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 
    1.1      Test
    
       
       
    .PARAMETER

       
    .EXAMPLE
    

    
#>


[CmdletBinding()]
Param(
  
)

# Import required modules
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name
$script:LocalAdUsers = @()

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Set some global variables
$user = $env:USERNAME
$CheckFolderPath = "C:\AppData\" + $user + "\AppData\ExchangeMig"
$DeleteReg = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\*"
$DeleteFolder = "C:\Users\" + $user + "\AppData\Local\Microsoft\Outlook"
$CreateFolder = "C:\Users\" + $user + "\AppData\ExchangeMigration"
$CreateReg = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook"

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')


## FUNCTIONS ####################################################################################################

function Delete-Reg {
    # Delete RegKeys
    $remove = Remove-Item $DeleteReg -Recurse -Confirm:$false -Force
    $logger.Write(('Regkey: {0} was deleted' -f $DeleteReg))
    # Create RegKeys
    $create = New-Item $CreateReg -Force -Confirm:$false
    $logger.Write(('Regkey: {0} was created' -f $CreateReg))
}

function Delete-AppData {
    # Delete appdata files
    $remove = Remove-Item $DeleteFolder -Recurse -Confirm:$false -Force
    $logger.Write(('Folder: {0} was deleted' -f $DeleteFolder))
}

function Check-Folder {
    # Check if Folder Exist
    If (Test-Path -Path $CreateFolder) {
        $logger.Write(('Folder already exist. Script already run! Exit'))
        Return
    
    } #end if
    # Create Folder if not
    else {
        $logger.write(('Folder doesn`t exist. Script runs first time.'))
        $logger.write(('Create folder for next run '))
        $folder = New-Item -Path $CreateFolder -ItemType Directory -Force

        # call function Delete-Reg
        Delete-Reg

        # call function Delete-AppData
        Delete-AppData

    } #end else
    

}


## MAIN ####################################################################################################

# Call Check-Folder / Create-Folder
Check-Folder

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')


