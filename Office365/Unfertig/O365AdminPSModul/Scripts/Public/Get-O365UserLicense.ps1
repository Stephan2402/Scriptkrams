function Get-O365UserLicense
{
    <#
        .SYNOPSIS
        Returns Office 365 licenses and enabled service plans for a
        given user
        .PARAMETER UserPrincipalName
        The full UPN for the user to report on
        .EXAMPLE
        Get-O365License -UserPrincipalName user@domain.com
        .NOTES
        Author: Matt McNabb
    #>
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true,Mandatory=$true)]
        [string]
        $UserPrincipalName
    )

    process
    {
        $MSOLUser = Get-MsolUser -UserPrincipalName $UserPrincipalName
        foreach ($License in $MSOLUser.Licenses)
        {
            $EnabledPlans = @()
            foreach ($ServicePlan in $License.ServiceStatus)
            {
                if ($ServicePlan.ProvisioningStatus -ne 'Disabled')
                {
                    $EnabledPlans += $ServicePlan.ServicePlan.ServiceName
                }
            }

            [PSCustomObject]@{AccountSkuId = $License.AccountSkuId; EnabledPlans = $EnabledPlans}
        }
    }
}