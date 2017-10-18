<# 
    .SYNOPSIS 
    Get mailboxsize from all users from csv file
       
    Stephan Verstegen 
       
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
       
    Version 1.0, 2017-10-16
       
    Please send ideas, comments and suggestions to support@verstegen-online.de
       
    .LINK 
    
    .LINK
    
    .DESCRIPTION 
       This script get the TotalItemCount from each mailbox from CSV file.
    
    .NOTES 
    Requirements 
    - Global Functions Module
    - Exchange Management Shell
    - CSV file with identity (Identity)

    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 
    1.1      Test
    
       
       
    .PARAMETER ConfigurationFile
    Set the path of the configuration file (csv file)
    Best to place this to the script root.
    Default = CSV-Quotas.csv
       
    .PARAMETER Delimiter
    Set the Delimiter variable for csv file
    Default = ;

       
    .EXAMPLE


    
#>


[CmdletBinding()]
Param(
  [string]$ConfigurationFile = 'CSV-Mailboxes.csv',
  [string]$Delimeter = ';'
)

# Import required modules
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name
$script:LocalAdUsers = @()

# Define some variables
$script:mailboxes

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')


## FUNCTIONS ####################################################################################################

function Import-Files {
    # Check if file exist
    if (Test-Path -Path $(Join-Path -Path $ScriptDir -ChildPath $ConfigurationFile)) {


         $logger.Write(("Start import CSV {0}" -f $ConfigurationFile))     
         try {  
            # Import CSV

            $script:mailboxes = Import-Csv $ConfigurationFile -Delimiter $Delimeter
            }
        catch {
            # Error when failed
            $logger.Write(('Fail to import CSV {0}' -f $ConfigurationFile, 1))
            Throw $_.Exception.Message
        }

        $logger.Write(('Successfully import CSV {0}' -f $ConfigurationFile))
    }
    else {
        $logger.Write(('Cannot find {0}' -f $ConfigurationFile, 1))
    }

}


function Get-UserMailboxSize {

    Remove-Item -Path .\sizes.csv
    Add-Content -Path .\sizes.csv -Value "Identity, Size(GB)"

    # Add aliases to Mailbox
    ForEach ($entry in $script:mailboxes){

        # Set Quota variables
        $Identity = $entry.Identity

        # Some logging ...
        $logger.Write(('Execute User: {0}' -f $Identity))
        #$logger.Write(('Catched following user quotas: Warning:{0} , Send:{1}, SendReceive:{2}' -f $IssueWarningQuota, $ProhibitSendQuota, $ProhibitSendReceiveQuota))

        # Get TotalItemSize
        $size = Get-Mailbox $Identity | Get-MailboxStatistics | select -Property TotalItemSize
        $size = $size.TotalItemSize.Value.ToBytes()/1GB

        $logger.Write(('Finished User: {0}' -f $Identity))

        Add-Content -Path .\sizes.csv -Value "$Identity, $size"

        } # End foreach

}

## MAIN ####################################################################################################

# Import CSV
    Import-Files

# get User Mailbox Size
    
    Get-UserMailboxSize

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')


