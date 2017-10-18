<# 
    .SYNOPSIS 
    Add csv based mail-aliase to existing Exchange 2013 Mailboxes
       
    Stephan Verstegen 
       
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
       
    Version 1.0, 2017-10-16
       
    Please send ideas, comments and suggestions to support@verstegen-online.de
       
    .LINK 
    
    .LINK
    
    .DESCRIPTION 
       This script add csv based mail aliase to existing Exchange 2013 mailboxes.
    
    .NOTES 
    Requirements 
    - Global Functions Module
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 
    
       
       
    .PARAMETER
       
    .PARAMETER 
       
    .PARAMETER 
       
    .EXAMPLE
    
    
#>


[CmdletBinding()]
Param(
  [string]$ConfigurationFile = 'CSV-Aliases.csv',
  [string]$Delimeter = ';'
)

# Import required modules
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name
$script:LocalAdUsers = @()

# Define some variables
$script:aliases

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

            $script:aliases = Import-Csv $ConfigurationFile -Delimiter $Delimeter
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


function Add-MailAlias {

    # Add aliases to Mailbox
    ForEach ($alias in $script:aliases){

        

        # Set SMTP Adresses variables
        $Identity = $alias.SMTP2
        $PrimarySMTP = $alias.SMTP1
        $SecondSMTP = $alias.SMTP2
        $ThirdSMTP = $alias.SMTP3

        # Some logging ...
        $logger.Write(('Execute User: {0}' -f $Identity))
        $logger.Write(('Catched following SMTP Adresses: SMTP:{0} , smtp:{1}, smtp:{2}' -f $PrimarySMTP, $SecondSMTP, $ThirdSMTP))

        # Disable EmailAddressPolicy for Mailbox
        Get-Mailbox -Identity $Identity | Set-Mailbox -EmailAddressPolicyEnabled $false
        $logger.Write(('Set EmailAddressPolicy to false for User: {0}' -f $Identity))

        # Add SMTP Adress to Mailbox
        Get-Mailbox -Identity $Identity | Set-Mailbox -EmailAddresses @{add=$PrimarySMTP,$ThirdSMTP}
        $logger.Write(('Add following aliases to User {0}: {1}, {2}' -f $Identity, $PrimarySMTP, $ThirdSMTP))

        # Set Primary SMTP Address
        Get-Mailbox -Identity $Identity | Set-Mailbox -PrimarySmtpAddress $PrimarySMTP
        $logger.Write(('Set Primary SMTP Adress for User {0} to: {1}' -f $Identity, $PrimarySMTP))

        $logger.Write(('Finished User: {0}' -f $Identity))

        } # End foreach

}

## MAIN ####################################################################################################

# Import CSV
    Import-Files
    $script:aliases

# Add Mail Aliases
    
    Add-MailAlias

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')


