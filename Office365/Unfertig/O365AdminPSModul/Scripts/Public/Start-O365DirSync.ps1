function Start-O365DirSync
{
    <#
            .SYNOPSIS
            Initiates a directory import using Office 365 Azure Active Directory Sync.
            .DESCRIPTION
            Initiates a directory import using Office 365 Azure Active Directory Sync on the local or remote computer.
            Can run an incremental sync or a full import sync. If run against a remote computer, requires that PSRemoting
            is enabled.
            .PARAMETER ComputerName
            The computer on which Azure Active Directory Sync is running.
            .PARAMETER Path
            The path to the directory sync console file. You can ignore this parameter if you installed Azure Active 
            Directory Sync to the default installation folder.
            .PARAMETER Credential
            You can provide an alternate credential for the remote computer.
            .PARAMETER FullImport
            Lets Azure Active Directory Sync know to run a full import sync instead of an incremental sync.
            .EXAMPLE
            Start-O365DirSync -ComputerName DirSyncServer -Credential 'whitehouse\alincoln'
            .NOTES

            .LINK

    #>
    [CmdletBinding()]
    param
    (
        [string]
        $ComputerName,
        
        $Path = "$env:ProgramFiles\Microsoft Online Directory Sync\DirSyncConfigShell.psc1",

        [switch]
        $FullImport,

        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    $SB = {
        if ($Using:FullImport)
        {
            $RegSplat = @{
                Path   = 'HKLM:\Software\Microsoft\MSOLCoExistence'
                Name = 'FullSyncNeeded'
                Value  = 1
            }
            Set-ItemProperty @RegSplat
        }
        
        & Powershell.exe -PsConsoleFile $Using:Path -Command 'Start-OnlineCoexistenceSync'
    }

    $CmdSplat = @{
        ComputerName = $ComputerName
        ScriptBlock = $SB
    }

    If ($Credential) {$CmdSplat.Credential = $Credential}

    Invoke-Command @CmdSplat
}