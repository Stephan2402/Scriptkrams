<# 
    .SYNOPSIS 
    Disable all mailbox access options.
       
    Stephan Verstegen 
       
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
       
    Version 1.0, 2017-10-18
       
    Please send ideas, comments and suggestions to support@verstegen-online.de
       
    .LINK GlobalFuntions
    https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    
    .DESCRIPTION 
       This script disables all mailbox access options. POP3 - IMAP - MAPI - ActiveSync - OWA
    
    .NOTES 
    Requirements 
    - Global Functions Module * Install-Module GlobalFunctions on PowerShell 5 OR https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    - Exchange Mangement Shell
    - CSV List with Identities
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 
    1.1      Test
    
       
       
    .PARAMETER

       
    .EXAMPLE
    

    
#>


[CmdletBinding()]
Param(
  [String]$ConfigurationFile = "CSV-Mailboxes.csv",
  [string]$Delimiter = ";",
  [string]$Mode = "No Value"
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
$script:identities = ""

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')


## FUNCTIONS ####################################################################################################

function Set-MailboxAccess {
    
    ForEach($entry in $script:identities){
        #Clear error log
        $Error.clear()
        
        # Get information from csv
        $ident = $entry.identity

            # Check if mailbox exist
            $return = Test-Mailbox -testmailbox $ident
                if($return -eq $false) {
                    #Log Mailbox failed and continue with next entry
                    $logger.Write(('Mailbox doesn`t exist: {0}' -f $ident))
                    #Write error to separate log
                    Add-Content -Path .\Error.csv -Value "$ident, Mailbox not exist"
                    Continue
                } # end if
                else {
                    $logger.Write(('Mailbox exist: {0}' -f $ident))
                            try {
                                #Check if mode is disable or enable
                                    if($Mode -eq "Disable") {
                                        #Start set CAS Mailbox
                                        $logger.Write(('Start set CAS Mailbox for {0}' -f $ident))
                                        $CASMailbox = Get-CASMailbox -Identity $ident | Set-CASMailbox -PopEnabled:$false -ImapEnabled:$false -MAPIEnabled:$false -ActiveSyncEnabled:$false -OWAEnabled:$false -WarningAction SilentlyContinue -ErrorAction Stop
                                        $logger.Write(('Access to CAS Mailbox was disabled for: {0}' -f $ident))
                                    } #end if
                                    if($Mode -eq "Enable") {
                                        #Start set CAS Mailbox
                                        $logger.Write(('Start set CAS Mailbox for {0}' -f $ident))
                                        $CASMailbox = Get-CASMailbox -Identity $ident | Set-CASMailbox -PopEnabled:$true -ImapEnabled:$true -MAPIEnabled:$true -ActiveSyncEnabled:$true -OWAEnabled:$true -WarningAction SilentlyContinue -ErrorAction Stop
                                        $logger.Write(('Access to CAS Mailbox was enabled for: {0}' -f $ident))
                                    } #end if
                                    if($Mode -ne "Enable" -AND $Mode -ne "Disable") {
                                        $logger.Write(('Wrong mode set. Please select mode "Disable" or "Enable"!'))

                                    } # endif
                                } # end try
                            catch {
                                # Log Error
                                $logger.Write(('Set CAS Mailbox failed {0}' -f $ident))
                                $logger.Write('Please see log file error.csv')

                                # Write error to separate log
                                Add-Content -Path .\Error.csv -Value "$ident, $Error"

                            } # end catch
                 } #end else               

    } # End foreach

} # end function

function Test-Mailbox($testmailbox) {
    # Check if mailbox exist
    $bool = [bool](Get-Mailbox -Identity $testmailbox -ErrorAction SilentlyContinue)
    return $bool
}

function Import-Files {
    # Check if file exist
    if (Test-Path -Path $ConfigurationFile) {


         $logger.Write(("Start import CSV {0}" -f $ConfigurationFile))     
         try {  
            # Import CSV

            $script:identities = Import-Csv -Path $ConfigurationFile -Delimiter $Delimiter
            }
        catch {
            # Error when failed
            $logger.Write(('Fail to import CSV {0}' -f $ConfigurationFile))
            Throw $_.Exception.Message
        }

        $logger.Write(('Successfully import CSV {0}' -f $ConfigurationFile))
    }
    else {
        $logger.Write(('Cannot find {0}' -f $ConfigurationFile))
    }

}



## MAIN ####################################################################################################

# Call Import-Files
Import-Files

# Call Set Access
Set-MailboxAccess

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')


