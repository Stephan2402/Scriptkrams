function Set-O365UserLicense
{
    <#
        .SYNOPSIS
        Sets licenses for Office 365 users.
        .PARAMETER UserPrincipalName
        The UPN value of the Office 365 user
        .PARAMETER AccountSkuId
        The Account SKU ID of the Office 365 plan.
        .PARAMETER ServicePlans
        The service plans to enable (if available).
        .EXAMPLE
        user@domain.com | Set-O365License -Sku Faculty -ServicePlans Exchange,Sharepoint
        .INPUTS
        [string]
        [Microsoft.Online.Administration.User]
        [Microsoft.ActiveDirectory.Management.ADUser]
        .NOTES
        Author: Matt McNabb
        Date: 6/12/2014

        To-do:
        - create -Remove switch parameter to identify licenses to remove
        - method for handling disabled plans is removing plans from the $O365AccountSkus variable - gotta fix this
        - AvailablePlans was an arraylist for easy removal of enabled plans, but this hosed in v5.0; I used an
          array instead - does this break v3.0 and v4.0?
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $UserPrincipalName,
        
        [Parameter(Mandatory = $true)]
        [O365Admin.AccountSkuId]
        $AccountSkuId
    )

    dynamicparam
    {
        $Dictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
        $AvailablePlans = $O365AccountSkus |
            Where-Object AccountSkuID -eq $AccountSkuId |
            Select-Object -ExpandProperty AvailablePlans
        $ParamAttr = New-Object -TypeName System.Management.Automation.ParameterAttribute
        $ParamOptions = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList $AvailablePlans
        $AttributeCollection = New-Object -TypeName 'Collections.ObjectModel.Collection[System.Attribute]'
        $AttributeCollection.Add($ParamAttr)
        $AttributeCollection.Add($ParamOptions)
        $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @('ServicePlans', [string[]], $AttributeCollection)
        $Dictionary.Add('ServicePlans', $Parameter)
        $Dictionary
    }

    begin
    {
        $DisabledPlans = $AvailablePlans
        [string]$AccountSkuId = "$AccountSkuId"
        $DomainName = $O365AccountSkus |
            Where-Object {$_.AccountSkuId -eq $AccountSkuId} |
            Select-Object -ExpandProperty DomainName
        $FullSku = "$DomainName`:$AccountSkuId"
        $Splat = @{AddLicenses = $FullSku}

        if ($PSBoundParameters.ServicePlans)
        {
            foreach ($ServicePlan in $PSBoundParameters.ServicePlans)
            {
                $DisabledPlans = $DisabledPlans | Where-Object { $_ -ne $ServicePlan }
            }
            
            $Splat.Add('LicenseOptions', (New-MsolLicenseOptions -AccountSkuId $FullSku -DisabledPlans $DisabledPlans))
        }

        Write-Verbose -Message "License SKU: $AccountSkuId"
        Write-Verbose -Message "Service plans: $($ServicePlan -join ',')"
    }

    process
    {
        if ($PSCmdlet.ShouldProcess($UserPrincipalName))
        {
            Write-Verbose -Message "Processing: $UserPrincipalName"
            $Splat.UserPrincipalName = $UserPrincipalName
            
            try
            {
                Write-Verbose -Message "Attempting to add license $AccountSkuId..."
                Set-MsolUserLicense @Splat -ErrorAction Stop
            }
            catch [Microsoft.Online.Administration.Automation.MicrosoftOnlineException]
            {
				switch ($_)
				{
					{ $_.Exception -match '.+UsageLocation$' } { throw $_; break }

					default
					{
						 Write-Verbose -Message "User could not be licensed for $AccountSkuId. Attempting to set service plans..."
						$Splat.Remove('AddLicenses')
						Set-MsolUserLicense @Splat -ErrorAction Stop
					}
				}       
            }
        }
    }
}
