<# 
    .SYNOPSIS 
    This script detects old active directory computer objects and will deactivate them if they are older then x days.
    Also it will move all deactivated objects after x days in a specific organizational unit.

    Version 1.0, 2017-03-14

    Author: Stephan Verstegen 
    
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 

    Please send ideas, comments and suggestions to xxx

    .LINK 
    http://

    .DESCRIPTION 
    This script detects old active directory computer objects and will deactivate them if they are older then x days.
    Also it will move all deactivated objects after x days in a specific organizational unit.
    It will write a log and send this log by mail.

    .NOTES 
    Requirements 
    - Active Directory PowerShell Module ---> https://www.microsoft.com/en-US/download/details.aspx?id=45520

    .PARAMETER DisableTime
    Days the computer is not logged in. Default = 365

    .PARAMETER MoveTime
    Days the computer object is not modified. Default = 60

    .PARAMETER OU
    Organizational Unit where computer object are moved to.

    .EXAMPLE
    Disable computer objects that are not logged in for 180 days and move disabled computers when they not modified for 30 days.
    .\Auto-Computer-disable.ps1 -DisableTime 180 -MoveTime 30

    .EXAMPLE
    Specify OU and use all other as default
    .\Auto-Computer-disable.ps1 -OU "DC=contoso,DC=com"


#> 
Param(
    [parameter()][string]$DisableTime = '4000',
    [parameter()][string]$MoveTime = '365',
    [parameter()][string]$OU
    )

function Write-Log 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
        [string]$Message, 
 
        [Parameter(Mandatory=$false)] 
        [Alias('LogPath')] 
        [string]$Path='Disable-Move-Computer', 
         
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
         
        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 
 
    Begin 
    { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    Process 
    { 
            $Date = Get-Date -Format yyyyMMdd
            $Path = ".\" + $Date + "-" + $Path + ".log" 
        # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $Path) -AND $NoClobber) { 
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $Path)) { 
            Write-Verbose "Creating $Path." 
            $NewLogFile = New-Item $Path -Force -ItemType File 
            } 
 
        else { 
            # Nothing to see here yet. 
            } 
 
        # Format Date for our Log File 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
 
        # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                $LevelText = 'ERROR:' 
                } 
            'Warn' { 
                Write-Warning $Message 
                $LevelText = 'WARNING:' 
                } 
            'Info' { 
                Write-Verbose $Message 
                $LevelText = 'INFO:' 
                } 
            } 
         
        # Write log entry to $Path 
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append 
    } 
    End 
    { 
    } 
}
function Send-Mail
{
    [CmdletBinding()] 
    Param(
        [parameter()][string]$SMTPServer = 'smtp.contoso.com',
        [parameter()][string]$Recipient = 'john.doe@contoso.com',
        [parameter()][string]$Sender = 'Delete-Move-AD-Computer <DeleteMove@contoso.com>',
        [parameter()][string]$Subject = 'Delete-Move-AD-Computer',
        [parameter()][string]$Body = 'Log file attached'
        )

    #Get date for Subject
    $Date = Get-Date -Format yyyyMMdd
    $Day = Get-Date -Format dddd
    $Month = Get-Date -Format MMMM
    $Year = Get-Date -Format yyyy

    # Mailsubject add Month
    $Subject = $Subject + " " + $Month
    
    #Set Mailserver
    $PSEmailServer = $SMTPServer

    #Send-MailMessage
    try {
        Get-ChildItem $Date*.log | Send-MailMessage -To $Recipient -From $Sender -Subject $Subject -Body $Body -ErrorAction SilentlyContinue
        Write-Log -Message "Mail was send to $Recipient" -Level Info
        }
    catch {
        Write-Log -Message "Mail was not send to $Recipient"
        Write-Log -Message $error
    }

}

Write-Log -Message "##################################" -Level Info
Write-Log -Message "Script started!" -Level Info
Write-Log -Message "##################################" -Level Info

# Some needed Variables

$ScriptDir = Split-Path -Path $Script:MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

# Import needed modules

try {

    Import-Module ActiveDirectory -ErrorAction Stop
    Write-Log -Message "Active Directory module imported" -Level Info

    }

catch {

    Write-Log -Message 'Unable to load Active Directory PowerShell Module.' -Level Error
    Write-Log -Message $error -Level Error
    Write-Log -Message "##################################" -Level Error
    Write-Log -Message 'Please check if RSAT is installed' -Level Error
    Write-Log -Message 'https://www.microsoft.com/en-US/download/details.aspx?id=45520' -Level Error
    Write-Log -Message "##################################" -Level Error
    }

# Calculate disable date and move date

$DisableStamp = (Get-Date).Adddays(-($DisableTime))
$MoveStamp = (Get-Date).Adddays(-($MoveTime))

# Get all AD Computers with lastlogonTimestamp less then "DisableTime"

$DisabledComputers = Get-ADComputer -Filter {LastLogonTimeStamp -lt $DisableStamp} -Properties LastLogonTimeStamp | Where-Object {$_.Name -notlike "UKMSRV*" -and $_.Enabled -eq $true -and $_.DistinguishedName -notlike "*OU=Steadyprint*"}

#Disable Computers
Write-Log -Message "##################################" -Level Info
Write-Log -Message "Start to disable computers!" -Level Info
Write-Log -Message "##################################" -Level Info
foreach ($Comp in $DisabledComputers){
    $Hostname = $Comp.Name
    try{
        #Get-ADComputer $Hostname | Disable-ADAccount -ErrorAction SilentlyContinue -WhatIf
        Write-Log -Message "$Hostname was disabled" -Level Info
        $CountDisabled = $CountDisabled + 1
        }
    catch{
        Write-Log -Message "$Hostname could not be disabled"
        Write-Log -Message $error -Level Error
        }
}

# Get all AD Computers that are Disabled more than "MoveTime"

$MoveComputers = Get-ADComputer -Filter {whenChanged -lt $MoveStamp} -Properties whenChanged | Where-Object {$_.Name -notlike "UKMSRV*" -and $_.Enabled -eq $false -and $_.DistinguishedName -notlike "*OU=Steadyprint*"}

# Move Computers to Organizational Unit
Write-Log -Message "##################################" -Level Info
Write-Log -Message "Start to move computers!" -Level Info
Write-Log -Message "##################################" -Level Info
foreach ($Comp in $MoveComputers){
    $Hostname = $Comp.Name
    try{
        #Get-ADComputer $Hostname | Move-ADObject -TargetPath $OU -ErrorAction SilentlyContinue -WhatIf
        Write-Log -Message "$Hostname was moved to $OU" -Level Info
        $CountMoved = $CountMoved + 1
        }
    catch{
        Write-Log -Message "$Hostname could not be moved" -Level Error
        Write-Log -Message $error -Level Error
        }
}
Write-Log -Message "##################################" -Level Info
Write-Log -Message "Disables Computers: $CountDisabled" -Level Info
Write-Log -Message "Moved Computers: $CountMoved" -Level Info
Write-Log -Message "##################################" -Level Info
Write-Log -Message "Script finished!" -Level Info
Write-Log -Message "##################################" -Level Info

#Send Mail
Send-Mail

#Delete old files
Get-ChildItem $ScriptDir -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-30)} | Remove-Item -Force -Recurse

#################
# End of script #
################# 