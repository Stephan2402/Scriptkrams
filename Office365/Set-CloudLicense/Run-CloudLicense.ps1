# Run Default configuration with existing password file and settings.xml
.\Set-CloudLicense.ps1 -LicenseName Default -ConfigurationFile settings.xml -UsePasswordFile

# Run Planner Configuration in change mode with existing password file and settings.xml
.\Set-CloudLicense.ps1 -LicenseName Planner -ConfigurationFile settings.xml -UsePasswordFile -ChangeMode


#Get-MsolUser -All | where {$_.isLicensed -eq $true -and $_.Licenses[0].ServiceStatus[4].ProvisioningStatus -ne "Disabled" -and $_.Licenses[0].ServiceStatus[7].ProvisioningStatus -ne "Disabled"}

#(Get-MsolUser -UserPrincipalName bianca.schulten@test.verstegen-online.de).Licenses[0].ServiceStatus