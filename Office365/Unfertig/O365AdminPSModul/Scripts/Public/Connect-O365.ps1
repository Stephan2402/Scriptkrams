function Connect-O365
{
    <#
            .SYNOPSIS
            Connects to the Office 365 environment

            .DESCRIPTION
            Connects to Office 365 with options for Exchange, Skype and Sharepoint. You can also select
            AzureActiveDirectory only.

            .PARAMETER Services
            The Office 365 services you wish to connect to. Valid values are AzureActiveDirectory,
	        Exchange, ComplianceCenter,Sharepoint and Skype. To specify multiple values use a comma-separated list.
            
			.PARAMETER Credential
            The username or PSCredential to use to connect to Office 365 services.
			
            .PARAMETER SharepointUrl
            If Sharepoint is specified as an argument to -Services, you can use SharepointUrl to
            specify the URL to connect to.
			
            .EXAMPLE
            $Credential = Get-Credential
            Connect-O365 -Services Exchange,Skype -Credential $Credential
			
            .EXAMPLE
            Connect-O365 -Services Sharepoint -SharepointUrl https://contoso-admin.sharepoint.com -Credential $Credential
    #>
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [O365Admin.Service]$Services,

        [parameter(Mandatory = $true)]
        [System.Management.Automation.Credential()]
        $Credential
    )

    dynamicparam {
        if ($PSBoundParameters.Services.HasFlag([O365Admin.Service]::Sharepoint))
        {
            $ParamAttr = New-Object -TypeName System.Management.Automation.ParameterAttribute
            $ParamOptions = New-Object -TypeName System.Management.Automation.ValidatePatternAttribute `
                                       ('^https://[a-zA-Z0-9\-]+\.sharepoint\.com')
            $AttributeCollection = New-Object -TypeName 'Collections.ObjectModel.Collection[System.Attribute]'
            $AttributeCollection.Add($ParamAttr)
            $AttributeCollection.Add($ParamOptions)
            $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter `
                                    -ArgumentList @('SharepointUrl', [string], $AttributeCollection)
            $Dictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
            $Dictionary.Add('SharepointUrl', $Parameter)
            $Dictionary
        }
    }

    begin
    {
        function Connect-O365Skype
        {
            param($Credential)
            Import-Module -Name SkypeOnlineConnector -DisableNameChecking -Force
            $Option = New-PSSessionOption -IdleTimeout -1
            $SkypeSession = New-CsOnlineSession -Credential $Credential -SessionOption $Option
            $ModuleName = 'SkypeForBusiness'
            $ModulePath = "$ResourcePath\$ModuleName"
            $null = Export-PSSession -Session $SkypeSession -OutputModule $ModulePath -AllowClobber -Force
            Import-Module $ModulePath -Global -DisableNameChecking
        }

        function Connect-O365Sharepoint
        {
            param($Credential, $Url)
            $Params = @{
                Url = $Url
                Credential = $Credential
                WarningAction = 'SilentlyContinue'
            }
            
            Import-Module -Name Microsoft.Online.Sharepoint.Powershell -DisableNameChecking -Force
            Connect-SPOService @Params
        }

        function Connect-O365Exchange
        {
            param($Credential)
            
            $ExchParams = @{
                ConfigurationName = 'microsoft.exchange'
                ConnectionUri     = "https://$ExchComputerName/powershell-liveid/"
                Credential        = $Credential
                Authentication    = 'Basic'
                AllowRedirection  = $true
            }
            $ExchSession = New-PSSession @ExchParams
            $ModuleName = 'ExchangeOnline'
            $ModulePath = "$ResourcePath\$ModuleName"
            $null = Export-PSSession -Session $ExchSession -OutputModule $ModulePath -AllowClobber -Force
            Import-Module $ModulePath -Global -DisableNameChecking
        }

		function Connect-O365Compliance
		{
			param
			(
				$Credential
			)

			$ComplianceParams = @{
				ConfigurationName = 'Microsoft.Exchange'
				ConnectionUri = 'https://ps.compliance.protection.outlook.com/powershell-liveid/'
				Credential = $Credential
				Authentication = 'Basic'
				AllowRedirection = $true
			}
			$CCSession = New-PSSession @ComplianceParams
			$ModuleName = 'ComplianceCenter'
            $ModulePath = "$ResourcePath\$ModuleName"
			$null = Export-PSSession -Session $CCSession -OutputModule $ModulePath -AllowClobber -Force
			Import-Module $ModulePath -Global -DisableNameChecking -Prefix CC
		}
    }

    process
    {
        switch ($Services)
        {
            { $_.HasFlag([O365Admin.Service]::AzureActiveDirectory) }
            {
                Import-Module -Name MSOnline -DisableNameChecking -Force
                Connect-MsolService -Credential $Credential
            }

            { $_.HasFlag([O365Admin.Service]::Exchange) }
            { Connect-O365Exchange -Credential $Credential }

            { $_.HasFlag([O365Admin.Service]::Skype) }     
            { Connect-O365Skype -Credential $Credential }

            { $_.HasFlag([O365Admin.Service]::Sharepoint) }
            { Connect-O365Sharepoint -Credential $Credential -Url $PSBoundParameters.SharepointUrl }

			{ $_.HasFlag([O365Admin.Service]::ComplianceCenter) }
            { Connect-O365Compliance -Credential $Credential }
        }
    }
}