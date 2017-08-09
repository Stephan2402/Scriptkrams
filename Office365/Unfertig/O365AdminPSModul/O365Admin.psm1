#region Initialize

$ScriptPath = "$PSScriptRoot\Scripts"
$ResourcePath = "$PSScriptRoot\Resources"

$Scripts = Get-ChildItem -Path $ScriptPath -Recurse -Filter '*.ps1'
foreach ($Script in $Scripts)
{
    . $Script.FullName
}

# template to define our namespace
$CSharp = @"
using System;
    namespace O365Admin
    {
	    public enum AccountSkuId
	    {
		    //PlaceholderSku
	    }

		[Flags]
		public enum Service
		{
			AzureActiveDirectory = 0x1,
			ComplianceCenter = 0x2,
			Exchange = 0x4,
			Sharepoint = 0x8,
			Skype = 0x10,
			All = AzureActiveDirectory | ComplianceCenter | Exchange | Sharepoint | Skype
		}
    }
"@

# Create AccountSkuId enum type definition file
$XmlPath = "$ResourcePath\O365AccountSkuIds.xml"
if (!(Test-Path $XmlPath))
{
    Write-Warning -Message 'Setting up module for first use.'
    Write-Warning -Message 'Please enter credentials for an Office 365 administrative account.'
    Connect-MsolService -Credential (Get-Credential -Message 'Enter O365 Administrative Credentials.') -ErrorAction Stop
    Get-O365AccountSku | Export-Clixml -Path $XmlPath
}

$O365AccountSkus = Import-Clixml $XmlPath
$CSharp = $CSharp -replace '//PlaceholderSku', "$($O365AccountSkus.AccountSkuId -join ', ')"

# add our custom namespace if it doesn't exist
try {[O365Admin.AccountSkuId]}
catch [System.Management.Automation.RuntimeException]
{
    Add-Type -TypeDefinition $CSharp
    $Global:Error.RemoveAt(0)
}

$ExchComputerName = 'outlook.office365.com'

#endregion

#region Export

Set-Alias -Name O365 -Value Connect-O365
Set-Alias -Name gogm -Value Get-O365PrincipalGroupMembership
Set-Alias -Name sogm -Value Set-O365PrincipalGroupMembership

Export-ModuleMember -Function `
    'Connect-O365',
    'Disconnect-O365',
    'Get-O365UserLicense',
    'Get-O365PrincipalGroupMembership',
    'Set-O365UserLicense',
    'Set-O365PrincipalGroupMembership',
    'Start-O365Dirsync' -Alias * -Variable O365AccountSkus
#endregion