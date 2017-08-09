
<#
 # Implizites Remotingmodul
 # Generiert auf 07.04.2016 16:54:49
 # von Cmdlet Export-PSSession
 # Wird mit der folgenden Befehlszeile aufgerufen:             $null = Export-PSSession -Session $ExchSession -OutputModule $ModulePath -AllowClobber -Force

 #>
        
@{
    GUID = '3951ea50-9256-4d91-bd73-d23bcb5bc621'
    Description = 'Implizites Remoting für https://outlook.office365.com/powershell-liveid/'
    ModuleToProcess = @('ExchangeOnline.psm1')
    FormatsToProcess = @('ExchangeOnline.format.ps1xml')

    ModuleVersion = '1.0'

    PrivateData = @{
        ImplicitRemoting = $true
    }
}
        