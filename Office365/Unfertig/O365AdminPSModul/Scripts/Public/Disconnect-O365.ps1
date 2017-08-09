function Disconnect-O365
{
    <#
            .SYNOPSIS
            Disconnects from Office 365 services and removes proxy commands and sessions
    #>

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [O365Admin.Service]
        $Services
    )

    switch ($Services)
    {
        { $_.HasFlag([O365Admin.Service]::Exchange) }
        {
            Get-PSSession | Where-Object ComputerName -eq $ExchComputerName | Remove-PSSession
            Remove-Module -Name ExchangeOnline -ErrorAction SilentlyContinue
        }

        { $_.HasFlag([O365Admin.Service]::Skype) }
        {
            Get-PSSession | Where-Object ComputerName -Like '*online.lync.com' | Remove-PSSession
            Remove-Module -Name SkypeForBusiness -ErrorAction SilentlyContinue
        }

        { $_.HasFlag([O365Admin.Service]::Sharepoint) }
        { try { Disconnect-SPOService -ErrorAction SilentlyContinue } catch [System.InvalidOperationException]{} }

		{ $_.HasFlag([O365Admin.Service]::ComplianceCenter) }
        {
            Get-PSSession | Where-Object ComputerName -eq 'ps.compliance.protection.outlook.com' | Remove-PSSession
            Remove-Module -Name ComplianceCenter -ErrorAction SilentlyContinue
        }
    }
}