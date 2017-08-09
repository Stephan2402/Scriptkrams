
<#
 # Implizites Remotingmodul
 # Generiert auf 07.04.2016 11:50:43
 # von Cmdlet Export-PSSession
 # Wird mit der folgenden Befehlszeile aufgerufen:             $null = Export-PSSession -Session $SkypeSession -OutputModule $ModulePath -AllowClobber -Force

 #>
        
@{
    GUID = '3f1eae3c-133c-46d5-98aa-5dbdcdbb8b86'
    Description = 'Implizites Remoting für https://admin1e.online.lync.com/OcsPowershellLiveId?AdminDomain=bechtle.ms'
    ModuleToProcess = @('SkypeForBusiness.psm1')
    FormatsToProcess = @('SkypeForBusiness.format.ps1xml')

    ModuleVersion = '1.0'

    PrivateData = @{
        ImplicitRemoting = $true
    }
}
        