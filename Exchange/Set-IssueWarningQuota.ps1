<# 
    .SYNOPSIS 
    Set IssueWarningQuota to -10 pertentage from SendReceiveQuota
       
    Stephan Verstegen 
       
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
       
    Version 1.0, 2017-10-16
       
    Please send ideas, comments and suggestions to support@verstegen-online.de
       
    .LINK GlobalFuntions
    https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    
    .DESCRIPTION 
       This script sets the IssueWarningQuota for all Exchange Mailboxes to -10 percent (%) from SendReceiveQuota. 
    
    .NOTES 
    Requirements 
    - Global Functions Module * Install-Module GlobalFunctions on PowerShell 5 OR https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    - Exchange Management Shell

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
  [string]$Delimeter = ';',
  [int]$IncreaseByPercentage = "10",
  [String]$Database = "ExchangeDB01"
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

function Get-Mailboxes([String]$Database){
        #Import Mailboxinfos into variable
        $scirpt:Mailboxes = Get-Mailbox -Database ExchangeDB01 -ResultSize unlimited -Filter * | select PrimarySMTPAddress, ProhibitSendReceiveQuota
} # end function

function Convert-QuotaStringToGB() {

        Param([string]$CurrentQuota)

        [string]$CurrentQuota = ($CurrentQuota.Split("("))[1]
        [string]$CurrentQuota = ($CurrentQuota.Split(" bytes)"))[0]
        $CurrentQuota = $CurrentQuota.Replace(",","")
        [int]$CurrentQuotaInKB = "{0:F0}" -f ($CurrentQuota/1024/1024/1024)

        return $CurrentQuotaInKB
}

function Add-IssueWarningQuota {

    # Add aliases to Mailbox
    ForEach ($mailbox in $script:mailboxes){

        # Set Quota variables
        $Identity = $mailbox.UserPrincipalName
        $ProhibitSendReceiveQuota = $mailboxes.ProhibitSendReceiveQuota

        #Some logging ...
        $logger.Write(('Execute User: {0}' -f $Identity))
        $logger.Write(('Catched following user quota: {0}' -f $ProhibitSendReceiveQuota))

        #Get UseDatabaseQuotaDefaults
        $isDefault = Get-Mailbox -Identity $Identity | select UseDatabaseQuotaDefaults
        $isDefault = $isDefault.UseDatabaseQuotaDefaults
        Write-Host $isDefault
        
        #Check if Quota is Unlimites or UseDatabaseQuotaDefaults is true
        if($ProhibitSendReceiveQuota -eq "Unlimited" -or $isDefault -eq "True") {
            $logger.Write(('Quota is <Unlimited> or <UseDatabaseQuotaDefaults> is True. Quota will not be changed.'))            
            Continue
        } # endif
        else {
           
            #Convert Quota string
            $CurrentQuotaGB = Convert-QuotaStringToGB -CurrentQuota $ProhibitSendReceiveQuota

            #Get new IssueWarningQuota
            $NewIssueWarningQuota = $CurrentQuotaGB - ($CurrentQuotaGB * $IncreaseByPercentage)/100
            $logger.Write(('New IssueWarningQuota: {0} GB' -f $NewIssueWarningQuota))

            # Change to Bytes
            $NewIssueWarningQuota = $NewIssueWarningQuota * 1024 * 1024 * 1024

            #Set quota to mailbox
            Get-Mailbox -Identity $Identity | Set-Mailbox -IssueWarningQuota $NewIssueWarningQuota
            $logger.Write(('Finished User: {0}' -f $Identity))
        } #end else

    } # End foreach

} # end function

## MAIN ####################################################################################################

# Import CSV
    Get-Mailboxes -Database $Database

# Add-IssueWarningQuota
    Add-IssueWarningQuota 

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')


