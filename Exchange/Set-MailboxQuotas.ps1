<# 
    .SYNOPSIS 
    Set quotas on mailboxes imported from csv
       
    Stephan Verstegen 
       
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
       
    Version 1.0, 2017-10-16
       
    Please send ideas, comments and suggestions to support@verstegen-online.de
       
    .LINK 
    
    .LINK
    
    .DESCRIPTION 
       This script add IssuerWarningQuota, ProhibitSendQuota and ProhibitSendReceiveQuota to mailbox from csv file imported.
    
    .NOTES 
    Requirements 
    - Global Functions Module
    - Exchange Management Shell
    - CSV file with quota information ( Identity, WarningQuota, SendQuota, SendReceiveQuota)

    
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
  [string]$ConfigurationFile = 'CSV-Quotas.csv',
  [string]$Delimeter = ';'
)

# Import required modules
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name
$script:LocalAdUsers = @()

# Define some variables
$script:quotas

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

            $script:quotas = Import-Csv $ConfigurationFile -Delimiter $Delimeter
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


function Add-UserMailboxQuota {

    # Add aliases to Mailbox
    ForEach ($alias in $script:quotas){

        

        # Set Quota variables
        $Identity = $alias.Identity
        $IssueWarningQuota = $alias.WarningQuota
        $ProhibitSendQuota = $alias.SendQuota
        $ProhibitSendReceiveQuota = $alias.SendReceiveQuota

        # Replace comma with dot and add "gb"
        $IssueWarningQuota = $IssueWarningQuota -replace ",","."
        $IssueWarningQuota = $IssueWarningQuota + "gb"
        $ProhibitSendQuota = $ProhibitSendQuota -replace ",","."
        $ProhibitSendQuota = $ProhibitSendQuota + "gb"
        $ProhibitSendReceiveQuota = $ProhibitSendReceiveQuota -replace ",","."
        $ProhibitSendReceiveQuota = $ProhibitSendReceiveQuota + "gb"

        # Some logging ...
        $logger.Write(('Execute User: {0}' -f $Identity))
        $logger.Write(('Catched following user quotas: Warning:{0} , Send:{1}, SendReceive:{2}' -f $IssueWarningQuota, $ProhibitSendQuota, $ProhibitSendReceiveQuota))

        # Set quotas to mailbox
        Get-Mailbox -Identity $Identity | Set-Mailbox -IssueWarningQuota $IssueWarningQuota -ProhibitSendQuota $ProhibitSendQuota -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota -UseDatabaseQuotaDefaults $false
        #Write-Host "Warning: $IssueWarningQuota"
        #Write-Host "send: $ProhibitSendQuota"
        #Write-Host "sendreceive: $ProhibitSendReceiveQuota"

        $logger.Write(('Finished User: {0}' -f $Identity))

        } # End foreach

}

## MAIN ####################################################################################################

# Import CSV
    Import-Files
    #$script:quotas

# Add Mail Aliases
    
    Add-UserMailboxQuota

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')


