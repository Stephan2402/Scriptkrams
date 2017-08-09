function Update-O365AccountSku
{
    param
    (
        $Parameter1
    )
    
    try
    {
        $o365AccountSkus = Get-O365AccountSku
    }
    catch [Microsoft.Online.Administration.Automation.MicrosoftOnlineException]
    {
        Write-Warning "Credentials are needed to connect to Azure Active Directory."
        Write-Warning "Please enter Office 365 administrative credentials."
        $Credential = Get-Credential
        Connect-MsolService -Credential $Credential
        $O365AccountSkus = Get-O365AccountSku
    }
    
    Set-O365LicenseCodeGen -O365AccountSkus $O365AccountSkus
    Import-Module $ExecutionContext.SessionState.Module.Path
}