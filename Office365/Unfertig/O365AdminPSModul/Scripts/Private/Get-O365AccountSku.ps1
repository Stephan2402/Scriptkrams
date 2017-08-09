function Get-O365AccountSku
{
    $Skus = Get-MsolAccountSku -ErrorAction stop
    $CustomSkus = @()
    foreach ($Sku in $Skus)
    {
        $Elements = $Sku.AccountSkuId -split ':'
        $DomainName = $Elements[0]
        $AccountSkuId = $Elements[1]
        $CustomSku = [PsCustomObject]@{
            AccountSkuId = $AccountSkuId
            AvailablePlans = $Sku.Servicestatus.ServicePlan.ServiceName
            DomainName = $DomainName
        }
        $CustomSkus += $CustomSku
    }
    $CustomSkus
}