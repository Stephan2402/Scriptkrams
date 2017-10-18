<# 
    .SYNOPSIS 
    Export Exchange 2007 Mailboxes into PST
       
    Stephan Verstegen 
       
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
       
    Version 1.0, 2017-10-16
       
    Please send ideas, comments and suggestions to support@verstegen-online.de
       
    .LINK 
    
    .LINK
    
    .DESCRIPTION 
       This script exports mailbox content from Exhange 2007 Mailboxes into PST files.
    The PST file is renamed with file tag if completed.
    
    .NOTES 
    Requirements 
    - Global Functions Module / Install-Module GlobalFunctions on PowerShell 5 or https://gallery.technet.microsoft.com/Centralized-logging-64e20f97
    - Exchange Management Shell on 32bit Client with Outlook installed
    - CSV file with mailbox identities (Header -> identity)

    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release 
    1.1      First test
    
       
       
    .PARAMETER ConfigurationFile
    Set the path of the configuration file (csv file)
    Best to place this to the script root.
    Default = CSV-Quotas.csv
       
    .PARAMETER Delimiter
    Set the Delimiter variable for csv file
    Default = ;

    .PARAMETER PSTFolderPath
    Root folder for PST export files

    .PARAMETER FileTag
    Used file tag for renaming after export is complete.
       
    .EXAMPLE
    .\Export-PST.ps1
#>


[CmdletBinding()]
Param(
  [string]$ConfigurationFile = 'CSV-Mailboxes.csv',
  [string]$Delimeter = ';',
  #[array]$IncludeFolders = @("\Inbox","\Contacts","\Send Items","\Posteingang","\Kontakte","\Gesendete Elemente"),
  [string]$PSTFolderPath = "E:\PSTExportFolder\",
  [string]$FileTag = "UKM_"
)

# Import required modules
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

# Define some global variables
$script:mailboxes
$script:impcsvfile = @()

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
function Test-Folder{
        #Create Folder if not already exist
        if(Test-Path -Path $PSTFolderPath){
            $logger.Write(('Folder already exist. Nothing to do'))
        }
        else {
            $folder = New-Item -Path $PSTFolderPath -ItemType Directory -Force
            $logger.write(('Create folder: {0}' -f $PSTFolderPath))
        }
}

function Create-CSVFile {
        # Create CSV File
           Add-Content -Path "$PSTFolderPath\CSV-PSTFiles.csv" -Value "Identity,PSTFile"

        # Add content to file
           ForEach ($entry in $script:impcsvfile){

                    # Add Entry
                    Add-Content -Path "$PSTFolderPath\CSV-PSTFiles.csv" -Value $entry

           } # end foreach
        

}
function ExporttoCSV{
    
    ForEach($mailbox in $script:mailboxes){

        # Get Folders to include
        #$IncludeFolder1 = "\Inbox"
        #$IncludeFolder2 = "\Send Items"
        #$IncludeFolder3 = "\Contacts"
        #$IncludeFolder4 = "\Posteingang"
        #$IncludeFolder5 = "\Gesendete Elemente"
        #$IncludeFolder6 = "\Kontakte"

        #$FoldertoInclude = "'$IncludeFolder1'" + "," + "'$IncludeFolder2'" + "," + "'$IncludeFolder3'" + "," + "'$IncludeFolder4'" + "," + "'$IncludeFolder5'" + "," + "'$IncludeFolder6'"
        
        
        # Get user information from CSV Import
        $identity = $mailbox.identity
        $identityFile = $identity -replace "\.","_"
        $identityFile = $identityFile -replace "@ukm-mhs.de",""

        # Create correct FolderPath
        $PSTFilePath = $PSTFolderPath + $identityFile + ".pst"

        # Some logging ...
        $logger.Write(('Export User: {0}' -f $Identity))
        $logger.Write(('Catched following export information: Identity:{0} , ExportFile:{1}' -f $identity, $PSTFilePath))
        $logger.Write(('Export will started for: {0}' -f $Identity))
        $logger.Write(('Please see C:\Program Files\Microsoft\Exchange Server\Logging\MigrationLogs for more logs!'))
        #Start Export Mailbox
        $export = Export-Mailbox -identity $identity -pstfolderpath $PSTFilePath -includeFolders '\Inbox','\Send Items','\Contacts','\Posteingang','\Gesendete Elemente','\Kontakte'  -BadItemLimit 5000 -MaxThreads 20 -confirm:$false
        $logger.Write(('Export finished for: {0}' -f $identity))
        #Rename File
        $newFileName = $FileTag + $identityFile + ".pst"
        $newPSTName = $PSTFolderPath + $newFileName
        $rename = Rename-Item -Path $PSTFilePath -NewName $newPSTName
        $logger.Write(('File renamed to: {0}' -f $newPSTName))

        # Write information to array
        $script:impcsvfile += "$identity,$newFileName"

    } # End foreach

}

## MAIN ####################################################################################################

# Import CSV
    Import-Files

# Test Folder
    Test-Folder

# Export Mailboxes
    ExporttoCSV
# Create CSV file for Import
    Create-CSVFile

# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')


