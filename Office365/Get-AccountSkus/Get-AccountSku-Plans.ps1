<# 
  .SYNOPSIS 
  This script get all Account SKUs including all Service Plans and export them into a csv file.


  Version 1.0  

  .DESCRIPTION 
  This script get all Account SKUs including all Service Plans and export them into a csv file.
    
  .NOTES 
  Requirements 
  - GlobalFunctions library as described here: http://scripts.granikos.eu
    
  Revision History 
  -------------------------------------------------------------------------------- 
  1.0      Initial release 

  This PowerShell script has been developed using ISESteroids - www.powertheshell.com 


  .PARAMETER ExportFile
  Name of the export file


  .EXAMPLE
  Get-AccountSku-Plans.ps1 -ExportFile <csvFileName.csv>

#>

[CmdletBinding()]
Param(
  [string]$ExportFile = 'Export.csv'
)
# Import required modules
Import-Module -Name MSOnline
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name
$script:ExportData = @()
$script:AllEntries = @()


# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')


function Get-ServicePlans {
    
    $AccountSKUs = @()

    # Get genral Account SKUs from Tenant
    $logger.Write('Getting all Account SKUs')
    $AccountSKUs = Get-MsolAccountSku
    $logger.Write(('SKUs fetched: {0}' -f ($AccountSKUs | Measure-Object).Count))

    # Get service plans from each SKU
    foreach ($SKU in $AccountSKUs){

        $AccountSkuId = $SKU.AccountSkuId
        $logger.Write('Account ID: {0}' -f $AccountSkuId)
        $SkuPartNumber = $SKU.SkuPartNumber
        $logger.Write('Sku part number: {0}' -f $SkuPartNumber)

        $ServicePlans = @()
        $ServicePlans = (Get-MsolAccountSku | where-object {$_.AccountSkuId -eq $AccountSkuId}).ServiceStatus

        #Get single service plan names
        foreach ($ServicePlan in $ServicePlans){

                #Match part number with service plan name and type
                $script:AllEntries += [PSCustomObject]@{
                    SkuPartNumber = $SkuPartNumber
                    ServicePlan = $ServicePlan.ServicePlan.ServiceName
                    ServiceType = $ServicePlan.ServicePlan.ServiceType
               }
               $logger.write(('Service plan: {0} | Service type: {1}' -f $ServicePlan.ServicePlan.ServiceName, $ServicePlan.ServicePlan.ServiceType))
            }
        }

      
      

}

## MAIN ####################################################################################################

  # Connect to Office 365
  [pscredential]$Cred = Get-Credential -Message 'Enter Office 365 credentials'
  Connect-MsolService -Credential $cred

  # Get Service Plans
  Get-ServicePlans

  # Export to csv file
  $script:AllEntries | Export-Csv -Path $ExportFile -NoTypeInformation
  $logger.Write('File Exported to {0}' -f $ExportFile)

  # Export to HTML file
  # coming soon

  $logger.Write('Script finished ####################################################')
## END #####################################################################################################