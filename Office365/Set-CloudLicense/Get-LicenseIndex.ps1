<#$hashtblAccountSKUID = @{"ENTERPRISEPACK" = "Office 365 Enterprise E3";  
"EMSPREMIUM" = "Enterprise Mobility + Security E5"} 
 
$ServiceName = ("PROJECTWORKMANAGEMENT")
 
Get-MsolUser -All | Where-Object { $_.isLicensed -eq $True } | ForEach-Object { 
    #----------------[ get license(s) and ServicePlan index for user ]--------- 
    $licensedetails = $_.Licenses # Get the user's licences 
    # 
    if ($licensedetails.Count -gt 0){ # If there's a license, show the details, otherwise, the output is blank. 
        foreach ($license in $licensedetails){ # loop through licenses 
        # 
        # Get the license accountskuid in human readable form by looking it up in the hashtable 
        # 
        $licName = $hashtblAccountSKUID.Get_Item($license.accountskuid.split(":")[1]) 
        # 
        # Loop through ServiceNames and find the one you need: 
        # 
        $index = $null # make sure $index is empty 
        for ($i=0; $i -le ($license.Servicestatus.ServicePlan.ServiceName.Count-1); $i++){ 
                if ($ServiceName -contains $license.Servicestatus.ServicePlan.ServiceName[$i]){ 
                $index = $i 
                break 
                } # End if ServiceName gevonden 
            } # End loop through serviceplans  
       #----------------[ license and ServicePlan index are known ]---------- 
       Write-host $_.DisplayName "$licName , ServiceName: $ServiceName Index: $index "
       } # End loop foreach license  
    } # End if there are licences 
} # Loop Get-MsolUser
#>
#########################################################################################

# Table for existing AccountSkuId`s with normal names
$hashtblAccountSKUID = @{"ENTERPRISEPACK" = "Office 365 Enterprise E3";  
"EMSPREMIUM" = "Enterprise Mobility + Security E5"} 
 
#Needed service name 
$ServiceName = ("Deskless")
 
# Get license configuration
$licInfo = Get-MsolAccountSku | where {$_.AccountSkuId -eq "bechtle042017:ENTERPRISEPACK"}

# Split license name from tenantId
$licName = $hashtblAccountSKUID.Get_Item($licInfo.accountskuid.split(":")[1]) 

# Set license index to $null
$licIndex = $null

# Find service name and save index number
        for ($i=0; $i -le ($licInfo.Servicestatus.ServicePlan.ServiceName.Count-1); $i++){ 
                if ($ServiceName -contains $licInfo.Servicestatus.ServicePlan.ServiceName[$i]){ 
                $licIndex = $i 
                break 
                } 
            }
           Write-host "$licName , ServiceName: $ServiceName Index: $licIndex "

