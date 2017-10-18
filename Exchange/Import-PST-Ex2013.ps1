<# 
    .SYNOPSIS 
    Import PST files into existing Exchange 2013 mailboxes.
       
    Stephan Verstegen 
       
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
       
    Version 1.0, 2017-10-16
       
    Please send ideas, comments and suggestions to support@verstegen-online.de
       
    .LINK 
    
    .LINK
    
    .DESCRIPTION 
       This script imports PST files into existing Exchange 2013 mailboxes.
    Best to export PST with Export-PST.ps1 script.
    
    .NOTES 
    Requirements 
    - Global Functions Module / Install-Module GlobalFunctions on PowerShell 5 or https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    - Exchange Management Shell on 32bit Client with Outlook installed
    - Folder with all pst files to import.

    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 
    1.1      First test

    .PARAMETER PSTFolder
    Folder for PST files
       
    .EXAMPLE
    .\Import-PST.ps1
#>


[CmdletBinding()]
Param(
  [string]$PSTFolder = "PSTFiles",
  [string]$CSVFile = "CSV-PSTFiles.csv",
  [string]$Delimiter = ",",
  [string]$UNCRootPath = "\\UKMSRVEX03\C$\Scripts\Exchange_Migration\Import\"
)

# Import required modules
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

# Define some global variable
$script:PSTInfo

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')


## FUNCTIONS ####################################################################################################

function Import-Files {
    # Check if file exist
    if (Test-Path -Path $(Join-Path -Path $PSTFolder -ChildPath $CSVFile)) {


         $logger.Write(("Start import CSV {0}" -f $CSVFile))     
         try {  
            # Import CSV

            $script:PSTInfo = Import-Csv -Path "$PSTFolder\$CSVFile" -Delimiter $Delimiter
            }
        catch {
            # Error when failed
            $logger.Write(('Fail to import CSV {0}' -f $CSVFile))
            Throw $_.Exception.Message
        }

        $logger.Write(('Successfully import CSV {0}' -f $CSVFile))
    }
    else {
        $logger.Write(('Cannot find {0}' -f $CSVFile))
    }

}
function Test-Mailbox([string]$testmailbox) {
    # Check if mailbox exist
    $bool = [bool](Get-Mailbox -Identity $testmailbox -ErrorAction SilentlyContinue)
    return $bool
}
function Test-Quota([int]$filesize, [string]$testmailbox) {
    # Check if quota is greater than PST file
    $Quotas = Get-Mailbox -Identity $testmailbox | Select IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota
    $Quota = $Quotas.IssueWarningQuota.ToString()
    # Convert quota string to GB
    $QuotaInMB = Convert-QuotaStringToMB -CurrentQuota $quota
    # Match Quota and PST file size
    if ($QuotaInMB -lt $filesize){
        # Quota less then filesize
        $bool = $false

    } # end if
    else {
        #Quota greater then filesize
        $bool = $true
    } # end else
    return $bool
}
function Test-PSTFile([string]$testfile) {
    # Check if pst file exist
    $bool = [bool](Test-Path -Path $testfile -ErrorAction SilentlyContinue)
    return $bool
}

function Convert-QuotaStringToMB() {

        Param([string]$CurrentQuota)

        [string]$CurrentQuota = ($CurrentQuota.Split("("))[1]
        [string]$CurrentQuota = ($CurrentQuota.Split(" bytes)"))[0]
        $CurrentQuota = $CurrentQuota.Replace(",","")
        [int]$CurrentQuotaInKB = "{0:F0}" -f ($CurrentQuota/1024/1024)

        return $CurrentQuotaInKB
}


function Import-PST-to-Mailbox{
    
        #Delete error.csv
        Remove-Item .\Error.csv

    ForEach($entry in $script:PSTInfo){
        #Clear error log
        $Error.clear()
        
        # Get information from csv
        $pstmailbox = $entry.identity
        $pstfile = $entry.PSTFile

        # Get file path and size
        $PSTPath = $PSTFolder + "\" + $pstfile
        $PSTUNCPath = $UNCRootPath + $PSTPath
        $PSTFileSize = Get-Childitem -Path $PSTPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue 
        $PSTfileSize = $PSTFileSize.Sum/1MB

        #Check if file exist
        [bool]$return = Test-PSTFile -testfile $PSTPath
        if($return -eq $false) {
            #Log file not found and continue
            $logger.Write(('PST file doesn`t exist: {0}' -f $pstfile))
            Continue

        } #end if
        else {
            $logger.Write(('PST File exist: {0}' -f $pstfile))
            # Check if mailbox exist
            $return = Test-Mailbox -testmailbox $pstmailbox
                if($return -eq $false) {
                    #Log Mailbox failed and continue with next entry
                    $logger.Write(('Mailbox doesn`t exist: {0}' -f $pstmailbox))
                    #Write error to separate log
                    Add-Content -Path .\Error.csv -Value "$pstmailbox, Mailbox not exist"
                    Continue
                } # end if
                else {
                    $logger.Write(('Mailbox exist: {0}' -f $pstmailbox))
                    # Check if quota is correct
                    $return = Test-Quota -filesize $PSTFileSize -testmailbox $pstmailbox
                        if($return -eq $false) {
                            #Log Mailbox failed and continue with next entry
                            $logger.Write(('Quota is not correct: Mailbox: {0}, Quota needed: {1}' -f $pstmailbox, $PSTFileSize))
                            #Write error to separate log
                            Add-Content -Path .\Error.csv -Value "$pstmailbox, Quota to small"
                            Continue
                        } #end if
                        else {
                            #Log Quota
                            $logger.Write(('Quota for {0} is okay' -f $pstmailbox))
                            try {
                                #Start PST import
                                $logger.Write(('Start PST Import for {0}' -f $pstmailbox))
                                $ImportPST = New-MailboxImportRequest -Mailbox $pstmailbox -FilePath $PSTUNCPath -BadItemLimit 5000 -Name $pstmailbox -Confirm:$false -WarningAction SilentlyContinue -ErrorAction Stop
                                } # end try
                            catch {
                                # Log Error
                                $logger.Write(('Import request failed for {0}' -f $pstmailbox))
                                $logger.Write('Please see log file error.csv')

                                # Write error to separate log
                                Add-Content -Path .\Error.csv -Value "$pstmailbox, $Error"

                            } # end catch
                        } #end else               
                }

         } #end else

    } # End foreach

}

## MAIN ##################################################################################s##################

# Import CSV
    Import-Files

# Export Mailboxes
    Import-PST-to-Mailbox

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')


