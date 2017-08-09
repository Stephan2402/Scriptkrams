
<#
 # Implizites Remotingmodul
 # Generiert auf 07.04.2016 11:50:43
 # von Cmdlet Export-PSSession
 # Wird mit der folgenden Befehlszeile aufgerufen:             $null = Export-PSSession -Session $SkypeSession -OutputModule $ModulePath -AllowClobber -Force

 #>
        
param(
    <# Optionaler Parameter zum Festlegen der Sitzung, für die dieses Proxymodul verwendet wird #>    
    [System.Management.Automation.Runspaces.PSSession] $PSSessionOverride,
    [System.Management.Automation.Remoting.PSSessionOption] $PSSessionOptionOverride
)

$script:__psImplicitRemoting_versionOfScriptGenerator = [Microsoft.PowerShell.Commands.ExportPSSessionCommand, Microsoft.PowerShell.Commands.Utility, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35]::VersionOfScriptGenerator
if ($script:__psImplicitRemoting_versionOfScriptGenerator.Major -ne 1.0)
{
    throw 'Das Modul kann nicht geladen werden, weil es mit einer inkompatiblen Version des Cmdlets "Export-PSSession" erstellt wurde. Erstellen Sie das Modul mit dem Cmdlet "Export-PSSession" aus der aktuellen Version, und laden Sie das Modul erneut.'
}


$script:WriteHost = $executionContext.InvokeCommand.GetCommand('Write-Host', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:WriteWarning = $executionContext.InvokeCommand.GetCommand('Write-Warning', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:WriteInformation = $executionContext.InvokeCommand.GetCommand('Write-Information', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:GetPSSession = $executionContext.InvokeCommand.GetCommand('Get-PSSession', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:NewPSSession = $executionContext.InvokeCommand.GetCommand('New-PSSession', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:ConnectPSSession = $executionContext.InvokeCommand.GetCommand('Connect-PSSession', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:NewObject = $executionContext.InvokeCommand.GetCommand('New-Object', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:RemovePSSession = $executionContext.InvokeCommand.GetCommand('Remove-PSSession', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:InvokeCommand = $executionContext.InvokeCommand.GetCommand('Invoke-Command', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:SetItem = $executionContext.InvokeCommand.GetCommand('Set-Item', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:ImportCliXml = $executionContext.InvokeCommand.GetCommand('Import-CliXml', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:NewPSSessionOption = $executionContext.InvokeCommand.GetCommand('New-PSSessionOption', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:JoinPath = $executionContext.InvokeCommand.GetCommand('Join-Path', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:ExportModuleMember = $executionContext.InvokeCommand.GetCommand('Export-ModuleMember', [System.Management.Automation.CommandTypes]::Cmdlet)
$script:SetAlias = $executionContext.InvokeCommand.GetCommand('Set-Alias', [System.Management.Automation.CommandTypes]::Cmdlet)

$script:MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
        
##############################################################################

function Write-PSImplicitRemotingMessage
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $message)
        
    try { & $script:WriteHost -Object $message -ErrorAction SilentlyContinue } catch { }
}

function Get-PSImplicitRemotingSessionOption
{
    if ($PSSessionOptionOverride -ne $null)
    {
        return $PSSessionOptionOverride
    }
    else
    {
        return $(& $script:NewPSSessionOption -Culture 'de-DE' -UICulture 'de-DE' -CancelTimeOut 60000 -IdleTimeOut 900000 -OpenTimeOut 180000 -OperationTimeOut 180000 -MaximumRedirection 0 -ProxyAccessType None -ProxyAuthentication Negotiate )
    }
}

$script:PSSession = $null

function Get-PSImplicitRemotingModuleName { $myInvocation.MyCommand.ScriptBlock.File }

function Set-PSImplicitRemotingSession
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [AllowNull()]
        [Management.Automation.Runspaces.PSSession] 
        $PSSession, 

        [Parameter(Mandatory = $false, Position = 1)]
        [bool] $createdByModule = $false)

    if ($PSSession -ne $null)
    {
        $script:PSSession = $PSSession

        if ($createdByModule -and ($script:PSSession -ne $null))
        {
            $moduleName = Get-PSImplicitRemotingModuleName 
            $script:PSSession.Name = 'Sitzung für implizites Remotingmodul bei {0}' -f $moduleName
            
            $oldCleanUpScript = $script:MyModule.OnRemove
            $removePSSessionCommand = $script:RemovePSSession
            $script:MyModule.OnRemove = { 
                & $removePSSessionCommand -Session $PSSession -ErrorAction SilentlyContinue
                if ($oldCleanUpScript)
                {
                    & $oldCleanUpScript $args
                }
            }.GetNewClosure()
        }
    }
}

if ($PSSessionOverride) { Set-PSImplicitRemotingSession $PSSessionOverride }

function Get-PSImplicitRemotingSession
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] 
        $commandName
    )

    $savedImplicitRemotingHash = ''

    if (($script:PSSession -eq $null) -or ($script:PSSession.Runspace.RunspaceStateInfo.State -ne 'Opened'))
    {
        Set-PSImplicitRemotingSession `
            (& $script:GetPSSession `
                -InstanceId 15defd8a-6b5f-4d0e-bd7a-dbeb5c326d4e `
                -ErrorAction SilentlyContinue )
    }
    if (($script:PSSession -ne $null) -and ($script:PSSession.Runspace.RunspaceStateInfo.State -eq 'Disconnected'))
    {
        # If we are handed a disconnected session, try re-connecting it before creating a new session.
        Set-PSImplicitRemotingSession `
            (& $script:ConnectPSSession `
                -Session $script:PSSession `
                -ErrorAction SilentlyContinue)
    }
    if (($script:PSSession -eq $null) -or ($script:PSSession.Runspace.RunspaceStateInfo.State -ne 'Opened'))
    {
        Write-PSImplicitRemotingMessage ('Neue Sitzung für implizite Remotevorgänge des Befehls "{0}" wird erstellt...' -f $commandName)

        Set-PSImplicitRemotingSession `
            -CreatedByModule $true `
            -PSSession ( 
            $( 
                & $script:NewPSSession `
                    -connectionUri 'https://admin1e.online.lync.com/OcsPowershellLiveId?AdminDomain=bechtle.ms' -ConfigurationName 'Microsoft.PowerShell' `
                    -SessionOption (Get-PSImplicitRemotingSessionOption) `
                    -Credential ( $host.UI.PromptForCredential( 'Bei Windows PowerShell anmelden', 'Geben Sie Ihre Anmeldeinformationen für https://admin1e.online.lync.com/OcsPowershellLiveId?AdminDomain=bechtle.ms ein.', 'opaque=PHNhbWw6QXNzZXJ0aW9uIE1ham9yVmVyc2lvbj0iMSIgTWlub3JWZXJzaW9uPSIxIiBBc3NlcnRpb25JRD0iU2FtbFNlY3VyaXR5VG9rZW4tZjg3M2Y0YzgtNTMzNi00N2E5LWEzNDMtMzMxZWFiYjQwMGY2IiBJc3N1ZXI9Imh0dHBzOi8vYW1zMWUwMHRhZDAyLmluZnJhLmx5bmMuY29tOjQ0NDMvZDg2YzZkNzMtOThhNy01ZDk1LTg4ODEtZjEzMDA0NTRmZDRkIiBJc3N1ZUluc3RhbnQ9IjIwMTYtMDQtMDdUMDk6NTA6NDAuMjM2WiIgeG1sbnM6c2FtbD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6MS4wOmFzc2VydGlvbiI+PHNhbWw6Q29uZGl0aW9ucyBOb3RCZWZvcmU9IjIwMTYtMDQtMDdUMDk6NTA6NDAuMjM2WiIgTm90T25PckFmdGVyPSIyMDE2LTA0LTA3VDE3OjQ3OjMxLjIzNloiPjxzYW1sOkF1ZGllbmNlUmVzdHJpY3Rpb25Db25kaXRpb24+PHNhbWw6QXVkaWVuY2U+aHR0cHM6Ly9hZG1pbjFlLm9ubGluZS5seW5jLmNvbS88L3NhbWw6QXVkaWVuY2U+PC9zYW1sOkF1ZGllbmNlUmVzdHJpY3Rpb25Db25kaXRpb24+PC9zYW1sOkNvbmRpdGlvbnM+PHNhbWw6QXV0aGVudGljYXRpb25TdGF0ZW1lbnQgQXV0aGVudGljYXRpb25NZXRob2Q9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjEuMDphbTp1bnNwZWNpZmllZCIgQXV0aGVudGljYXRpb25JbnN0YW50PSIyMDE2LTA0LTA3VDA5OjUwOjQwLjIzNloiPjxzYW1sOlN1YmplY3Q+PHNhbWw6TmFtZUlkZW50aWZpZXIgRm9ybWF0PSJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiPlMtMS01LTIxLTIzMjU0OTc4MDctMjYyNTU5MDcxNS0xMjk2OTUzNzg2LTIwNTc0NDI0PC9zYW1sOk5hbWVJZGVudGlmaWVyPjxzYW1sOlN1YmplY3RDb25maXJtYXRpb24+PHNhbWw6Q29uZmlybWF0aW9uTWV0aG9kPnVybjpvYXNpczpuYW1lczp0YzpTQU1MOjEuMDpjbTpob2xkZXItb2Yta2V5PC9zYW1sOkNvbmZpcm1hdGlvbk1ldGhvZD48S2V5SW5mbyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PGU6RW5jcnlwdGVkS2V5IHhtbG5zOmU9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jIyI+PGU6RW5jcnlwdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI2t3LWFlczI1NiI+PC9lOkVuY3J5cHRpb25NZXRob2Q+PEtleUluZm8+PEtleU5hbWU+ZDg2YzZkNzMtOThhNy01ZDk1LTg4ODEtZjEzMDA0NTRmZDRkOjhkMzVlYmJmOTM3ZDI3NjwvS2V5TmFtZT48L0tleUluZm8+PGU6Q2lwaGVyRGF0YT48ZTpDaXBoZXJWYWx1ZT5LRGw3QzY3SjFHT0lZSVlyVWxNa1hxVElBZGVEa2I3R1d2MHVOREFlN1cwT1pWYUVQUFhvTHc9PTwvZTpDaXBoZXJWYWx1ZT48L2U6Q2lwaGVyRGF0YT48L2U6RW5jcnlwdGVkS2V5PjwvS2V5SW5mbz48L3NhbWw6U3ViamVjdENvbmZpcm1hdGlvbj48L3NhbWw6U3ViamVjdD48L3NhbWw6QXV0aGVudGljYXRpb25TdGF0ZW1lbnQ+PFNpZ25hdHVyZSB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFNpZ25lZEluZm8+PENhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiPjwvQ2Fub25pY2FsaXphdGlvbk1ldGhvZD48U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI3JzYS1zaGExIj48L1NpZ25hdHVyZU1ldGhvZD48UmVmZXJlbmNlIFVSST0iI1NhbWxTZWN1cml0eVRva2VuLWY4NzNmNGM4LTUzMzYtNDdhOS1hMzQzLTMzMWVhYmI0MDBmNiI+PFRyYW5zZm9ybXM+PFRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNlbnZlbG9wZWQtc2lnbmF0dXJlIj48L1RyYW5zZm9ybT48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIj48L1RyYW5zZm9ybT48L1RyYW5zZm9ybXM+PERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiI+PC9EaWdlc3RNZXRob2Q+PERpZ2VzdFZhbHVlPkRvelBMM0lsdE1pbXg3M1Q2cll3NWpwR2NUQ3B4UFU5cGFXandyUEljVUk9PC9EaWdlc3RWYWx1ZT48L1JlZmVyZW5jZT48L1NpZ25lZEluZm8+PFNpZ25hdHVyZVZhbHVlPlpNRXRYSDhNZnZheFR1d3VkdHhIQUdNMG5xdFdmTHZ5ZzBnb2ZyV3R1M21jQjZISkZOTkUxSUEzbDNvRHNPdXdrTnFucWxtV0UxaU9rMXZwZFJHOVc3NVZDL1o5Skozd3dYQ3VxcXBwdHBLSWVKbEVKMVV3NHhhVzVxMDBPbXhtUVE1VUxDR2ViME5oaEQ4bEVNNmNDZ1NxRlVQdU53UGJJeGZOMVpNYmYxeENOM0NsZHJaeS9TamJjTTgzVXM2RXQxSllJVDA0NXBFT2RJMTFKRU9oZCtxY0p5MGQrRUd0Y0lxMlNCZFlTN0MxNytzNkdqdUlMdkNoeENNaTVQVmlPeGUwSXptRjdxNkdDRXVUUHVYYmVUOUlxNDdwR3p3Q3djYnpWVC91R09yY0ptamJ2RzJuQTM0SGZDQ1VXaFBhZWMrT2d5WE4vOXlJTU1NNHhVcDA2Zz09PC9TaWduYXR1cmVWYWx1ZT48S2V5SW5mbz48bzpTZWN1cml0eVRva2VuUmVmZXJlbmNlIHhtbG5zOm89Imh0dHA6Ly9kb2NzLm9hc2lzLW9wZW4ub3JnL3dzcy8yMDA0LzAxL29hc2lzLTIwMDQwMS13c3Mtd3NzZWN1cml0eS1zZWNleHQtMS4wLnhzZCI+PG86S2V5SWRlbnRpZmllciBWYWx1ZVR5cGU9Imh0dHA6Ly9kb2NzLm9hc2lzLW9wZW4ub3JnL3dzcy9vYXNpcy13c3Mtc29hcC1tZXNzYWdlLXNlY3VyaXR5LTEuMSNUaHVtYnByaW50U0hBMSI+YnQwQjEzTWdhZXZ6TXRPNFlHeFFna2xzRjZvPTwvbzpLZXlJZGVudGlmaWVyPjwvbzpTZWN1cml0eVRva2VuUmVmZXJlbmNlPjwvS2V5SW5mbz48L1NpZ25hdHVyZT48L3NhbWw6QXNzZXJ0aW9uPg==', 'admin1e.online.lync.com' ) ) `
                     `
                    -Authentication Basic `
                     `
            )
 )

        if ($savedImplicitRemotingHash -ne '')
        {
            $newImplicitRemotingHash = [string]($script:PSSession.ApplicationPrivateData.ImplicitRemoting.Hash)
            if ($newImplicitRemotingHash -ne $savedImplicitRemotingHash)
            {
                & $script:WriteWarning -Message 'Die in der neuen Remotesitzung verfügbaren Befehle unterscheiden sich von denen, die bei Erstellung des impliziten Remotingmoduls verfügbar waren. Erstellen Sie das Modul ggf. mit dem Cmdlet "Export-PSSession" neu.'
            }
        }

        
    }
    if (($script:PSSession -eq $null) -or ($script:PSSession.Runspace.RunspaceStateInfo.State -ne 'Opened'))
    {
        throw 'Dem impliziten Remotingmodul wurde keine Sitzung zugeordnet.'
    }
    return [Management.Automation.Runspaces.PSSession]$script:PSSession
}

function Modify-PSImplicitRemotingParameters
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [hashtable]
        $clientSideParameters,

        [Parameter(Mandatory = $true, Position = 1)]
        $PSBoundParameters,

        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        $parameterName,

        [Parameter()]
        [switch]
        $leaveAsRemoteParameter)
        
    if ($PSBoundParameters.ContainsKey($parameterName))
    {
        $clientSideParameters.Add($parameterName, $PSBoundParameters[$parameterName])
        if (-not $leaveAsRemoteParameter) { 
            $null = $PSBoundParameters.Remove($parameterName) 
        }
    }
}

function Get-PSImplicitRemotingClientSideParameters
{
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        $PSBoundParameters,

        [Parameter(Mandatory = $true, Position = 2)]
        $proxyForCmdlet)

    $clientSideParameters = @{}
    $parametersToLeaveRemote = 'ErrorAction', 'WarningAction', 'InformationAction'

    Modify-PSImplicitRemotingParameters $clientSideParameters $PSBoundParameters 'AsJob'
    if ($proxyForCmdlet)
    {
        foreach($parameter in [System.Management.Automation.Cmdlet]::CommonParameters)
        {
            if($parametersToLeaveRemote -contains $parameter)
            {
                Modify-PSImplicitRemotingParameters $clientSideParameters $PSBoundParameters $parameter -LeaveAsRemoteParameter
            }
            else
            {
                Modify-PSImplicitRemotingParameters $clientSideParameters $PSBoundParameters $parameter
            }
        }
    }

    return $clientSideParameters
}

##############################################################################

& $script:SetItem 'function:script:Clear-CsOnlineTelephoneNumberReservation' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${ReservationId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${InventoryType},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Clear-CsOnlineTelephoneNumberReservation') `
                            -Arg ('Clear-CsOnlineTelephoneNumberReservation', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Clear-CsOnlineTelephoneNumberReservation
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Copy-CsVoicePolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${PolicyName},

    [switch]
    ${LocalStore},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Copy-CsVoicePolicy') `
                            -Arg ('Copy-CsVoicePolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Copy-CsVoicePolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Disable-CsMeetingRoom' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Disable-CsMeetingRoom') `
                            -Arg ('Disable-CsMeetingRoom', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Disable-CsMeetingRoom
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Disable-CsOnlineDialInConferencingUser' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${SendEmailFromDisplayName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wv')]
    ${WarningVariable},

    ${TenantDomain},

    [Alias('db')]
    [switch]
    ${Debug},

    ${SendEmailToAddress},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${SendEmailFromAddress},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [switch]
    ${SendEmail},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Disable-CsOnlineDialInConferencingUser') `
                            -Arg ('Disable-CsOnlineDialInConferencingUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Disable-CsOnlineDialInConferencingUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Disable-CsOnlineUMMailBox' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${TenantId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [switch]
    ${IgnoreDefaultScope},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    ${KeepProperties},

    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Disable-CsOnlineUMMailBox') `
                            -Arg ('Disable-CsOnlineUMMailBox', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Disable-CsOnlineUMMailBox
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Enable-CsMeetingRoom' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${OriginatorSid},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${SipAddressType},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${PassThru},

    ${SipDomain},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('HostingProvider')]
    ${HostingProviderProxyFqdn},

    ${SipAddress},

    [Alias('ob')]
    ${OutBuffer},

    ${RegistrarPool},

    ${ProxyPool},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('wv')]
    ${WarningVariable},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Enable-CsMeetingRoom') `
                            -Arg ('Enable-CsMeetingRoom', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Enable-CsMeetingRoom
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Enable-CsOnlineDialInConferencingUser' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${AllowPstnOnlyMeetings},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${ServiceNumber},

    ${SendEmailFromDisplayName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('Passcode')]
    ${ConferenceId},

    [Alias('wv')]
    ${WarningVariable},

    ${TenantDomain},

    [Alias('db')]
    [switch]
    ${Debug},

    ${SendEmailToAddress},

    ${SendEmailFromAddress},

    [switch]
    ${SendEmail},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${ReplaceProvider},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Enable-CsOnlineDialInConferencingUser') `
                            -Arg ('Enable-CsOnlineDialInConferencingUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Enable-CsOnlineDialInConferencingUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Enable-CsOnlineUMMailBox' `
{
    param(
    
    [switch]
    ${Force},

    ${TenantId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${ValidateOnly},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('db')]
    [switch]
    ${Debug},

    ${SendWelcomeMail},

    ${SIPResourceIdentifier},

    ${Extensions},

    [Alias('ob')]
    ${OutBuffer},

    ${PinExpired},

    ${NotifyEmail},

    ${Identity},

    [switch]
    ${IgnoreDefaultScope},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wv')]
    ${WarningVariable},

    ${UMMailboxPolicy},

    ${AutomaticSpeechRecognitionEnabled},

    ${DomainController},

    ${Pin},

    [switch]
    ${WhatIf},

    ${PilotNumber},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Enable-CsOnlineUMMailBox') `
                            -Arg ('Enable-CsOnlineUMMailBox', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Enable-CsOnlineUMMailBox
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsAudioConferencingProvider' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsAudioConferencingProvider') `
                            -Arg ('Get-CsAudioConferencingProvider', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsAudioConferencingProvider
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsBroadcastMeetingConfiguration' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${ExposeSDNConfigurationJsonBlob},

    [Alias('ov')]
    ${OutVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [switch]
    ${LocalStore},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${Filter},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsBroadcastMeetingConfiguration') `
                            -Arg ('Get-CsBroadcastMeetingConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsBroadcastMeetingConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsBroadcastMeetingPolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsBroadcastMeetingPolicy') `
                            -Arg ('Get-CsBroadcastMeetingPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsBroadcastMeetingPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsClientPolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsClientPolicy') `
                            -Arg ('Get-CsClientPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsClientPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsConferencingPolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${ApplicableTo},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsConferencingPolicy') `
                            -Arg ('Get-CsConferencingPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsConferencingPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsDialPlan' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsDialPlan') `
                            -Arg ('Get-CsDialPlan', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsDialPlan
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsExternalAccessPolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${ApplicableTo},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsExternalAccessPolicy') `
                            -Arg ('Get-CsExternalAccessPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsExternalAccessPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsExUmContact' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${Credential},

    [Alias('ev')]
    ${ErrorVariable},

    ${LdapFilter},

    ${Filter},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    ${OU},

    ${DomainController},

    ${ResultSize},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsExUmContact') `
                            -Arg ('Get-CsExUmContact', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsExUmContact
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsHostedVoicemailPolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsHostedVoicemailPolicy') `
                            -Arg ('Get-CsHostedVoicemailPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsHostedVoicemailPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsHostingProvider' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsHostingProvider') `
                            -Arg ('Get-CsHostingProvider', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsHostingProvider
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsHybridPSTNSite' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsHybridPSTNSite') `
                            -Arg ('Get-CsHybridPSTNSite', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsHybridPSTNSite
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsImFilterConfiguration' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsImFilterConfiguration') `
                            -Arg ('Get-CsImFilterConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsImFilterConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsIPPhonePolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsIPPhonePolicy') `
                            -Arg ('Get-CsIPPhonePolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsIPPhonePolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsMeetingConfiguration' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsMeetingConfiguration') `
                            -Arg ('Get-CsMeetingConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsMeetingConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsMeetingRoom' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${Credential},

    [Alias('ev')]
    ${ErrorVariable},

    ${LdapFilter},

    ${Filter},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    ${OU},

    ${DomainController},

    ${ResultSize},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsMeetingRoom') `
                            -Arg ('Get-CsMeetingRoom', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsMeetingRoom
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDialInConferencingBridge' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${Name},

    [Alias('wv')]
    ${WarningVariable},

    ${TenantDomain},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDialInConferencingBridge') `
                            -Arg ('Get-CsOnlineDialInConferencingBridge', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDialInConferencingBridge
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDialInConferencingLanguagesSupported' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${Force},

    [Alias('DC')]
    ${DomainController},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDialInConferencingLanguagesSupported') `
                            -Arg ('Get-CsOnlineDialInConferencingLanguagesSupported', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDialInConferencingLanguagesSupported
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDialinConferencingPolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDialinConferencingPolicy') `
                            -Arg ('Get-CsOnlineDialinConferencingPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDialinConferencingPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDialInConferencingServiceNumber' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${BridgeName},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${TenantDomain},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    ${BridgeId},

    [Alias('wa')]
    ${WarningAction},

    ${ResultSize},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    ${City},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDialInConferencingServiceNumber') `
                            -Arg ('Get-CsOnlineDialInConferencingServiceNumber', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDialInConferencingServiceNumber
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDialinConferencingTenantConfiguration' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDialinConferencingTenantConfiguration') `
                            -Arg ('Get-CsOnlineDialinConferencingTenantConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDialinConferencingTenantConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDialInConferencingTenantSettings' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDialInConferencingTenantSettings') `
                            -Arg ('Get-CsOnlineDialInConferencingTenantSettings', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDialInConferencingTenantSettings
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDialInConferencingUser' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${BridgeName},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${ServiceNumber},

    ${TenantDomain},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${LdapFilter},

    ${Identity},

    ${Tenant},

    ${BridgeId},

    [Alias('wa')]
    ${WarningAction},

    ${ResultSize},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDialInConferencingUser') `
                            -Arg ('Get-CsOnlineDialInConferencingUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDialInConferencingUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDialInConferencingUserState' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${TenantDomain},

    ${Provider},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${LicenseState},

    ${Identity},

    [Alias('wv')]
    ${WarningVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${ResultSize},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDialInConferencingUserState') `
                            -Arg ('Get-CsOnlineDialInConferencingUserState', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDialInConferencingUserState
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDirectoryTenant' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDirectoryTenant') `
                            -Arg ('Get-CsOnlineDirectoryTenant', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDirectoryTenant
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineDirectoryTenantNumberCities' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${Force},

    [Alias('DC')]
    ${DomainController},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineDirectoryTenantNumberCities') `
                            -Arg ('Get-CsOnlineDirectoryTenantNumberCities', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineDirectoryTenantNumberCities
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineEnhancedEmergencyServiceDisclaimer' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    ${Version},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    ${CountryOrRegion},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineEnhancedEmergencyServiceDisclaimer') `
                            -Arg ('Get-CsOnlineEnhancedEmergencyServiceDisclaimer', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineEnhancedEmergencyServiceDisclaimer
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineLisCivicAddress' `
{
    param(
    
    [Alias('DC')]
    ${DomainController},

    ${CountryOrRegion},

    ${Description},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${NumberOfResultsToSkip},

    [switch]
    ${PopulateNumberOfVoiceUsers},

    ${CivicAddressId},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    ${Tenant},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('wa')]
    ${WarningAction},

    ${ResultSize},

    ${LocationId},

    ${City},

    ${ValidationStatus},

    [switch]
    ${Force},

    ${AssignmentStatus},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineLisCivicAddress') `
                            -Arg ('Get-CsOnlineLisCivicAddress', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineLisCivicAddress
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineLisLocation' `
{
    param(
    
    [Alias('DC')]
    ${DomainController},

    ${CountryOrRegion},

    ${Description},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('db')]
    [switch]
    ${Debug},

    ${NumberOfResultsToSkip},

    [switch]
    ${PopulateNumberOfVoiceUsers},

    ${CivicAddressId},

    ${Location},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    ${Tenant},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('wa')]
    ${WarningAction},

    ${ResultSize},

    ${LocationId},

    ${City},

    ${ValidationStatus},

    [switch]
    ${Force},

    ${AssignmentStatus},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineLisLocation') `
                            -Arg ('Get-CsOnlineLisLocation', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineLisLocation
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineNumberPortInOrder' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${PortInOrderId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineNumberPortInOrder') `
                            -Arg ('Get-CsOnlineNumberPortInOrder', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineNumberPortInOrder
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineTelephoneNumber' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${InventoryType},

    [Alias('ov')]
    ${OutVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('CityCode')]
    ${CapitalOrMajorCity},

    ${TelephoneNumber},

    [Alias('ob')]
    ${OutBuffer},

    ${TelephoneNumberGreaterThan},

    ${TelephoneNumberStartsWith},

    ${Assigned},

    ${Tenant},

    ${TelephoneNumberLessThan},

    [Alias('wa')]
    ${WarningAction},

    ${ResultSize},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${IsNotAssigned},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineTelephoneNumber') `
                            -Arg ('Get-CsOnlineTelephoneNumber', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineTelephoneNumber
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineTelephoneNumberAvailableCount' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${InventoryType},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineTelephoneNumberAvailableCount') `
                            -Arg ('Get-CsOnlineTelephoneNumberAvailableCount', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineTelephoneNumberAvailableCount
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineTelephoneNumberInventoryAreas' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${Force},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    ${Tenant},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${InventoryType},

    [Alias('Country')]
    ${CountryOrRegion},

    [Alias('wa')]
    ${WarningAction},

    [Alias('Region')]
    ${RegionalGroup},

    [Alias('DC')]
    ${DomainController},

    ${Area},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineTelephoneNumberInventoryAreas') `
                            -Arg ('Get-CsOnlineTelephoneNumberInventoryAreas', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineTelephoneNumberInventoryAreas
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineTelephoneNumberInventoryCities' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${Force},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    ${Tenant},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('City')]
    ${CapitalOrMajorCity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${InventoryType},

    [Alias('Country')]
    ${CountryOrRegion},

    [Alias('wa')]
    ${WarningAction},

    [Alias('Region')]
    ${RegionalGroup},

    [Alias('DC')]
    ${DomainController},

    ${Area},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineTelephoneNumberInventoryCities') `
                            -Arg ('Get-CsOnlineTelephoneNumberInventoryCities', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineTelephoneNumberInventoryCities
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineTelephoneNumberInventoryCountries' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    ${Tenant},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${InventoryType},

    [Alias('Country')]
    ${CountryOrRegion},

    [Alias('wa')]
    ${WarningAction},

    [Alias('Region')]
    ${RegionalGroup},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineTelephoneNumberInventoryCountries') `
                            -Arg ('Get-CsOnlineTelephoneNumberInventoryCountries', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineTelephoneNumberInventoryCountries
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineTelephoneNumberInventoryRegions' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${InventoryType},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('Region')]
    ${RegionalGroup},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineTelephoneNumberInventoryRegions') `
                            -Arg ('Get-CsOnlineTelephoneNumberInventoryRegions', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineTelephoneNumberInventoryRegions
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineTelephoneNumberInventoryTypes' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${Force},

    [Alias('DC')]
    ${DomainController},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineTelephoneNumberInventoryTypes') `
                            -Arg ('Get-CsOnlineTelephoneNumberInventoryTypes', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineTelephoneNumberInventoryTypes
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineTelephoneNumberReservationsInformation' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineTelephoneNumberReservationsInformation') `
                            -Arg ('Get-CsOnlineTelephoneNumberReservationsInformation', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineTelephoneNumberReservationsInformation
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineUMDialplan' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ov')]
    ${OutVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    ${TenantId},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineUMDialplan') `
                            -Arg ('Get-CsOnlineUMDialplan', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineUMDialplan
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineUMMailBox' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${Organization},

    ${TenantId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [switch]
    ${ReadFromDomainController},

    [Alias('ov')]
    ${OutVariable},

    ${SortBy},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${Credential},

    [Alias('ev')]
    ${ErrorVariable},

    ${OrganizationalUnit},

    ${Filter},

    [switch]
    ${IgnoreDefaultScope},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    ${AccountPartition},

    ${DomainController},

    ${ResultSize},

    ${Anr},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineUMMailBox') `
                            -Arg ('Get-CsOnlineUMMailBox', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineUMMailBox
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineUMMailBoxPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${TenantId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${Organization},

    ${DomainController},

    ${UMDialPlan},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineUMMailBoxPolicy') `
                            -Arg ('Get-CsOnlineUMMailBoxPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineUMMailBoxPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineUser' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${Credential},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${LdapFilter},

    ${Filter},

    [Alias('OnLyncServer')]
    [switch]
    ${OnModernServer},

    [switch]
    ${OnOfficeCommunicationServer},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    ${OU},

    ${DomainController},

    [switch]
    ${UnassignedUser},

    ${ResultSize},

    [switch]
    ${SkipUserPolicies},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineUser') `
                            -Arg ('Get-CsOnlineUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsOnlineVoiceUser' `
{
    param(
    
    [Alias('DC')]
    ${DomainController},

    ${Skip},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [switch]
    ${NumberNotAssigned},

    [switch]
    ${NumberAssigned},

    [Alias('ob')]
    ${OutBuffer},

    ${First},

    [switch]
    ${GetFromAAD},

    ${EnterpriseVoiceStatus},

    [Alias('db')]
    [switch]
    ${Debug},

    ${SearchQuery},

    ${CivicAddressId},

    ${PSTNConnectivity},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [Alias('wv')]
    ${WarningVariable},

    ${Tenant},

    [switch]
    ${ExpandLocation},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ov')]
    ${OutVariable},

    ${LocationId},

    [switch]
    ${GetPendingUsers},

    [switch]
    ${Force},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsOnlineVoiceUser') `
                            -Arg ('Get-CsOnlineVoiceUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsOnlineVoiceUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsPresencePolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsPresencePolicy') `
                            -Arg ('Get-CsPresencePolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsPresencePolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsPrivacyConfiguration' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsPrivacyConfiguration') `
                            -Arg ('Get-CsPrivacyConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsPrivacyConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsPushNotificationConfiguration' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsPushNotificationConfiguration') `
                            -Arg ('Get-CsPushNotificationConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsPushNotificationConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsTenant' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${ResultSize},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    ${DomainController},

    ${Filter},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ev')]
    ${ErrorVariable},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsTenant') `
                            -Arg ('Get-CsTenant', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsTenant
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsTenantFederationConfiguration' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsTenantFederationConfiguration') `
                            -Arg ('Get-CsTenantFederationConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsTenantFederationConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsTenantHybridConfiguration' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsTenantHybridConfiguration') `
                            -Arg ('Get-CsTenantHybridConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsTenantHybridConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsTenantLicensingConfiguration' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsTenantLicensingConfiguration') `
                            -Arg ('Get-CsTenantLicensingConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsTenantLicensingConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsTenantPublicProvider' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsTenantPublicProvider') `
                            -Arg ('Get-CsTenantPublicProvider', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsTenantPublicProvider
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsUserAcp' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${Credential},

    [Alias('ev')]
    ${ErrorVariable},

    ${LdapFilter},

    ${Filter},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    ${ResultSize},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsUserAcp') `
                            -Arg ('Get-CsUserAcp', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsUserAcp
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsUserPstnSettings' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${Force},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsUserPstnSettings') `
                            -Arg ('Get-CsUserPstnSettings', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsUserPstnSettings
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsUserServicesPolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsUserServicesPolicy') `
                            -Arg ('Get-CsUserServicesPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsUserServicesPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsVoicePolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsVoicePolicy') `
                            -Arg ('Get-CsVoicePolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsVoicePolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Get-CsVoiceRoutingPolicy' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${Filter},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${LocalStore},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Get-CsVoiceRoutingPolicy') `
                            -Arg ('Get-CsVoiceRoutingPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Get-CsVoiceRoutingPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsBroadcastMeetingPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsBroadcastMeetingPolicy') `
                            -Arg ('Grant-CsBroadcastMeetingPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsBroadcastMeetingPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsClientPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsClientPolicy') `
                            -Arg ('Grant-CsClientPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsClientPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsConferencingPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsConferencingPolicy') `
                            -Arg ('Grant-CsConferencingPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsConferencingPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsDialPlan' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsDialPlan') `
                            -Arg ('Grant-CsDialPlan', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsDialPlan
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsExternalAccessPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsExternalAccessPolicy') `
                            -Arg ('Grant-CsExternalAccessPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsExternalAccessPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsHostedVoicemailPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsHostedVoicemailPolicy') `
                            -Arg ('Grant-CsHostedVoicemailPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsHostedVoicemailPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsIPPhonePolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsIPPhonePolicy') `
                            -Arg ('Grant-CsIPPhonePolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsIPPhonePolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsVoicePolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsVoicePolicy') `
                            -Arg ('Grant-CsVoicePolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsVoicePolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Grant-CsVoiceRoutingPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PolicyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Grant-CsVoiceRoutingPolicy') `
                            -Arg ('Grant-CsVoiceRoutingPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Grant-CsVoiceRoutingPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Invoke-CsUcsRollback' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Invoke-CsUcsRollback') `
                            -Arg ('Invoke-CsUcsRollback', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Invoke-CsUcsRollback
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsEdgeAllowAllKnownDomains' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsEdgeAllowAllKnownDomains') `
                            -Arg ('New-CsEdgeAllowAllKnownDomains', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsEdgeAllowAllKnownDomains
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsEdgeAllowList' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${AllowedDomain},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsEdgeAllowList') `
                            -Arg ('New-CsEdgeAllowList', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsEdgeAllowList
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsEdgeDomainPattern' `
{
    param(
    
    ${Domain},

    [Alias('ov')]
    ${OutVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsEdgeDomainPattern') `
                            -Arg ('New-CsEdgeDomainPattern', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsEdgeDomainPattern
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsExUmContact' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${Description},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${SipAddress},

    ${DisplayNumber},

    [Alias('wa')]
    ${WarningAction},

    ${OU},

    ${AutoAttendant},

    ${RegistrarPool},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsExUmContact') `
                            -Arg ('New-CsExUmContact', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsExUmContact
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsHybridPSTNSite' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${EdgeFQDN},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [switch]
    ${InMemory},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsHybridPSTNSite') `
                            -Arg ('New-CsHybridPSTNSite', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsHybridPSTNSite
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsOnlineBulkAssignmentInput' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('DC')]
    ${DomainController},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${TelephoneNumber},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${LocationID},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsOnlineBulkAssignmentInput') `
                            -Arg ('New-CsOnlineBulkAssignmentInput', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsOnlineBulkAssignmentInput
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsOnlineLisCivicAddress' `
{
    param(
    
    [Alias('DC')]
    ${DomainController},

    ${CountryOrRegion},

    ${Description},

    ${PreDirectional},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${CompanyName},

    [Alias('wa')]
    ${WarningAction},

    [Alias('db')]
    [switch]
    ${Debug},

    ${StreetName},

    ${StreetSuffix},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    ${PostDirectional},

    [Alias('wv')]
    ${WarningVariable},

    ${HouseNumber},

    ${PostalCode},

    ${StateOrProvince},

    ${Tenant},

    ${HouseNumberSuffix},

    ${City},

    [Alias('ev')]
    ${ErrorVariable},

    [switch]
    ${Force},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsOnlineLisCivicAddress') `
                            -Arg ('New-CsOnlineLisCivicAddress', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsOnlineLisCivicAddress
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsOnlineLisLocation' `
{
    param(
    
    ${PostalCode},

    [Alias('ob')]
    ${OutBuffer},

    ${Description},

    [Alias('Country')]
    ${CountryOrRegion},

    [Alias('db')]
    [switch]
    ${Debug},

    [switch]
    ${Force},

    [Alias('wv')]
    ${WarningVariable},

    ${PostDirectional},

    ${StreetSuffix},

    ${Tenant},

    [Alias('ea')]
    ${ErrorAction},

    ${StreetName},

    ${City},

    ${HouseNumber},

    ${CivicAddressId},

    [Alias('State')]
    ${StateOrProvince},

    ${HouseNumberSuffix},

    [Alias('ov')]
    ${OutVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${Location},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('Name')]
    ${CompanyName},

    ${PreDirectional},

    [Alias('DC')]
    ${DomainController},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsOnlineLisLocation') `
                            -Arg ('New-CsOnlineLisLocation', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsOnlineLisLocation
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsOnlineNumberPortInOrder' `
{
    param(
    
    [Alias('wa')]
    ${WarningAction},

    ${LOABase64PayLoad},

    ${SubscriberStreetName},

    ${SubscriberCountry},

    ${InventoryType},

    ${LOAContentType},

    [switch]
    ${Force},

    ${SubscriberArea},

    ${SubscriberBusinessName},

    [Alias('wv')]
    ${WarningVariable},

    ${LosingTelcoPin},

    ${SubscriberAddressLine3},

    ${Tenant},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${FriendlyName},

    [switch]
    ${IsPartialPort},

    [Alias('ev')]
    ${ErrorVariable},

    ${RequestedFocDate},

    ${BillingTelephoneNumber},

    ${SubscriberCity},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    ${TelephoneNumbers},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${SubscriberAddressLine2},

    ${SubscriberAddressLine1},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${SubscriberLastName},

    ${LosingTelcoAccountId},

    ${SubscriberBuildingNumber},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('db')]
    [switch]
    ${Debug},

    ${EmailAddresses},

    ${LOAAuthorizingPerson},

    ${SubscriberFirstName},

    ${SubscriberZipCode},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsOnlineNumberPortInOrder') `
                            -Arg ('New-CsOnlineNumberPortInOrder', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsOnlineNumberPortInOrder
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsOnlineUMDialplan' `
{
    param(
    
    ${URIType},

    ${TenantId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${Name},

    ${CountryOrRegionCode},

    ${GenerateUMMailboxPolicy},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${NumberOfDigitsInExtension},

    ${VoIPSecurity},

    [Alias('ob')]
    ${OutBuffer},

    [switch]
    ${WhatIf},

    ${FaxEnabled},

    ${AccessTelephoneNumbers},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    [Alias('ov')]
    ${OutVariable},

    ${DomainController},

    ${DefaultLanguage},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsOnlineUMDialplan') `
                            -Arg ('New-CsOnlineUMDialplan', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsOnlineUMDialplan
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:New-CsOnlineUMMailBoxPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${TenantId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [switch]
    ${SharedUMDialPlan},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${Organization},

    ${DomainController},

    ${UMDialPlan},

    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'New-CsOnlineUMMailBoxPolicy') `
                            -Arg ('New-CsOnlineUMMailBoxPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName New-CsOnlineUMMailBoxPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsExUmContact' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    ${Identity},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsExUmContact') `
                            -Arg ('Remove-CsExUmContact', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsExUmContact
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsHybridPSTNSite' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${Force},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsHybridPSTNSite') `
                            -Arg ('Remove-CsHybridPSTNSite', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsHybridPSTNSite
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsOnlineDialInConferencingTenantSettings' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${Force},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsOnlineDialInConferencingTenantSettings') `
                            -Arg ('Remove-CsOnlineDialInConferencingTenantSettings', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsOnlineDialInConferencingTenantSettings
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsOnlineLisCivicAddress' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${CivicAddressId},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsOnlineLisCivicAddress') `
                            -Arg ('Remove-CsOnlineLisCivicAddress', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsOnlineLisCivicAddress
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsOnlineLisLocation' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('DC')]
    ${DomainController},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${LocationId},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsOnlineLisLocation') `
                            -Arg ('Remove-CsOnlineLisLocation', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsOnlineLisLocation
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsOnlineNumberPortInOrder' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${PortInOrderId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsOnlineNumberPortInOrder') `
                            -Arg ('Remove-CsOnlineNumberPortInOrder', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsOnlineNumberPortInOrder
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsOnlineTelephoneNumber' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${TelephoneNumber},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsOnlineTelephoneNumber') `
                            -Arg ('Remove-CsOnlineTelephoneNumber', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsOnlineTelephoneNumber
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsOnlineUMDialplan' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${TenantId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsOnlineUMDialplan') `
                            -Arg ('Remove-CsOnlineUMDialplan', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsOnlineUMDialplan
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsOnlineUMMailBoxPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${TenantId},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsOnlineUMMailBoxPolicy') `
                            -Arg ('Remove-CsOnlineUMMailBoxPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsOnlineUMMailBoxPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsUserAcp' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${Name},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ev')]
    ${ErrorVariable},

    ${ParticipantPasscode},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ov')]
    ${OutVariable},

    ${TollNumber},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsUserAcp') `
                            -Arg ('Remove-CsUserAcp', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsUserAcp
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Remove-CsVoicePolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${Force},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Remove-CsVoicePolicy') `
                            -Arg ('Remove-CsVoicePolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Remove-CsVoicePolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Search-CsOnlineTelephoneNumberInventory' `
{
    param(
    
    [switch]
    ${Force},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    ${InventoryType},

    ${Tenant},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('City')]
    ${CapitalOrMajorCity},

    ${TelephoneNumber},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Quantity},

    [Alias('Country')]
    ${CountryOrRegion},

    ${AreaCode},

    [Alias('wa')]
    ${WarningAction},

    [Alias('Region')]
    ${RegionalGroup},

    [Alias('DC')]
    ${DomainController},

    ${Area},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Search-CsOnlineTelephoneNumberInventory') `
                            -Arg ('Search-CsOnlineTelephoneNumberInventory', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Search-CsOnlineTelephoneNumberInventory
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Select-CsOnlineTelephoneNumberInventory' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${ReservationId},

    [switch]
    ${Force},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    ${Tenant},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('City')]
    ${CapitalOrMajorCity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('Country')]
    ${CountryOrRegion},

    [Alias('wa')]
    ${WarningAction},

    [Alias('Region')]
    ${RegionalGroup},

    [Alias('DC')]
    ${DomainController},

    ${TelephoneNumbers},

    ${Area},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Select-CsOnlineTelephoneNumberInventory') `
                            -Arg ('Select-CsOnlineTelephoneNumberInventory', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Select-CsOnlineTelephoneNumberInventory
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsBroadcastMeetingConfiguration' `
{
    param(
    
    [Alias('wa')]
    ${WarningAction},

    ${EnableSdnProviderForBroadcastMeeting},

    ${SdnAzureSubscriptionId},

    ${SdnPluginVersion},

    ${Identity},

    ${Instance},

    [Alias('ev')]
    ${ErrorVariable},

    ${SdnPluginTemplateUrl},

    ${EnableBroadcastMeeting},

    ${SdnApiTemplateUrl},

    [Alias('wv')]
    ${WarningVariable},

    ${EnableAnonymousBroadcastMeeting},

    ${EnforceBroadcastMeetingRecording},

    ${EnableTechPreviewFeatures},

    ${Tenant},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${SdnFallbackAttendeeThresholdCountForBroadcastMeeting},

    ${EnableSocialStreamIntegration},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${SdnApiToken},

    ${BroadcastMeetingSupportUrl},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${EnableOpenBroadcastMeeting},

    [switch]
    ${Force},

    ${EnableBroadcastMeetingRecording},

    [Alias('ob')]
    ${OutBuffer},

    ${SdnProviderName},

    ${SdnLicenseId},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsBroadcastMeetingConfiguration') `
                            -Arg ('Set-CsBroadcastMeetingConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsBroadcastMeetingConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsClientPolicy' `
{
    param(
    
    ${DisableMeetingSubjectAndLocation},

    ${DisableEmailComparisonCheck},

    ${DisableSavingIM},

    [Alias('wa')]
    ${WarningAction},

    ${TabURL},

    ${EnableIMAutoArchiving},

    ${EnableMediaRedirection},

    ${EnableSQMData},

    ${MaximumDGsAllowedInContactList},

    ${EnableAppearOffline},

    ${SPSearchCenterInternalURL},

    ${RequireContentPin},

    ${DisableHandsetOnLockedMachine},

    ${P2PAppSharingEncryption},

    ${EnableHotdesking},

    ${EnableServerConversationHistory},

    ${RateMyCallAllowCustomUserFeedback},

    ${DisableInkIM},

    ${EnableSkypeUI},

    ${CustomLinkInErrorMessages},

    ${EnableNotificationForNewSubscribers},

    ${DisableContactCardOrganizationTab},

    ${EnableHighPerformanceConferencingAppSharing},

    ${DisableHtmlIm},

    ${IMLatencySpinnerDelay},

    ${IMLatencyErrorThreshold},

    ${HotdeskingTimeout},

    [Alias('ov')]
    ${OutVariable},

    ${DisablePresenceNote},

    ${ConferenceIMIdleTimeout},

    ${HelpEnvironment},

    ${BlockConversationFromFederatedContacts},

    [Alias('db')]
    [switch]
    ${Debug},

    ${ShowSharepointPhotoEditLink},

    ${Description},

    ${DisablePoorNetworkWarnings},

    ${EnableUnencryptedFileTransfer},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${PlayAbbreviatedDialTone},

    ${EnableURL},

    ${DisablePoorDeviceWarnings},

    ${CustomizedHelpUrl},

    ${DisableFederatedPromptDisplayName},

    ${SearchPrefixFlags},

    ${MaximumNumberOfContacts},

    ${RateMyCallDisplayPercentage},

    ${DisableEmoticons},

    ${DisplayPhoto},

    ${DisableCalendarPresence},

    ${Tenant},

    ${ExcludedContactFolders},

    ${ShowRecentContacts},

    ${EnableExchangeDelegateSync},

    ${EnableClientMusicOnHold},

    ${EnableMeetingEngagement},

    ${EnableTracing},

    ${IMWarning},

    ${SPSearchInternalURL},

    ${CalendarStatePublicationInterval},

    ${DisableOneNote12Integration},

    ${EnableHighPerformanceP2PAppSharing},

    ${EnableConversationWindowTabs},

    ${MaxPhotoSizeKB},

    ${WebServicePollInterval},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${EnableExchangeContactSync},

    ${EnableFullScreenVideo},

    ${DisableOnlineContextualSearch},

    ${SPSearchCenterExternalURL},

    ${DisablePhonePresence},

    [Alias('wv')]
    ${WarningVariable},

    ${SPSearchExternalURL},

    ${CustomStateUrl},

    ${SupportModernFilePicker},

    ${EnableEnterpriseCustomizedHelp},

    ${EnableEventLogging},

    ${DisableRTFIM},

    ${DGRefreshInterval},

    ${MAPIPollInterval},

    ${TracingLevel},

    [Alias('ea')]
    ${ErrorAction},

    ${EnableCallLogAutoArchiving},

    ${DisablePICPromptDisplayName},

    ${DisableFreeBusyInfo},

    [switch]
    ${Force},

    ${AutoDiscoveryRetryInterval},

    ${PolicyEntry},

    [Alias('ev')]
    ${ErrorVariable},

    ${AttendantSafeTransfer},

    ${MusicOnHoldAudioFile},

    ${ShowManagePrivacyRelationships},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${DisableFeedsTab},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    ${AddressBookAvailability},

    ${EnableVOIPCallDefault},

    ${EnableClientAutoPopulateWithTeam},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsClientPolicy') `
                            -Arg ('Set-CsClientPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsClientPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsExUmContact' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${Description},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    ${EnterpriseVoiceEnabled},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${SipAddress},

    ${Identity},

    ${DisplayNumber},

    ${ExchangeArchivingPolicy},

    [Alias('wa')]
    ${WarningAction},

    ${DomainController},

    [Alias('CsEnabled')]
    ${Enabled},

    ${AutoAttendant},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsExUmContact') `
                            -Arg ('Set-CsExUmContact', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsExUmContact
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsHybridPSTNSite' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${EdgeFQDN},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsHybridPSTNSite') `
                            -Arg ('Set-CsHybridPSTNSite', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsHybridPSTNSite
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsIPPhonePolicy' `
{
    param(
    
    [Alias('wa')]
    ${WarningAction},

    ${PowerSavePostOfficeHoursTimeoutMS},

    ${Identity},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${Instance},

    ${EnableBetterTogetherOverEthernet},

    [Alias('db')]
    [switch]
    ${Debug},

    [switch]
    ${Force},

    ${KeyboardLockMaxPinRetry},

    ${LocalProvisioningServerAddress},

    ${PowerSaveDuringOfficeHoursTimeoutMS},

    ${Tenant},

    ${LocalProvisioningServerType},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ea')]
    ${ErrorAction},

    ${PrioritizedCodecsList},

    ${UserDialTimeoutMS},

    ${DateTimeFormat},

    ${LocalProvisioningServerPassword},

    [Alias('ov')]
    ${OutVariable},

    ${EnableDeviceUpdate},

    ${EnableOneTouchVoicemail},

    [Alias('wv')]
    ${WarningVariable},

    ${LocalProvisioningServerUser},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${EnableExchangeCalendaring},

    ${EnablePowerSaveMode},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsIPPhonePolicy') `
                            -Arg ('Set-CsIPPhonePolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsIPPhonePolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsMeetingConfiguration' `
{
    param(
    
    [Alias('wa')]
    ${WarningAction},

    ${PstnCallersBypassLobby},

    ${Identity},

    ${Instance},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [switch]
    ${Force},

    [Alias('wv')]
    ${WarningVariable},

    ${DesignateAsPresenter},

    ${Tenant},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${AllowConferenceRecording},

    ${UserUriFormatForStUser},

    ${AssignedConferenceTypeByDefault},

    ${LogoURL},

    [Alias('ov')]
    ${OutVariable},

    ${RequireRoomSystemsAuthorization},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    ${CustomFooterText},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${HelpURL},

    ${AllowCloudRecordingService},

    ${AdmitAnonymousUsersByDefault},

    ${LegalURL},

    ${EnableAssignedConferenceType},

    ${EnableMeetingReport},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsMeetingConfiguration') `
                            -Arg ('Set-CsMeetingConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsMeetingConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsMeetingRoom' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${PrivateLine},

    ${SipAddress},

    ${RemoteCallControlTelephonyEnabled},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${AudioVideoDisabled},

    ${EnterpriseVoiceEnabled},

    [Alias('ev')]
    ${ErrorVariable},

    ${LineServerURI},

    ${Identity},

    ${LineURI},

    [Alias('ob')]
    ${OutBuffer},

    ${ExchangeArchivingPolicy},

    [Alias('wa')]
    ${WarningAction},

    ${HostedVoiceMail},

    ${DomainController},

    [Alias('CsEnabled')]
    ${Enabled},

    ${AcpInfo},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsMeetingRoom') `
                            -Arg ('Set-CsMeetingRoom', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsMeetingRoom
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineDialInConferencingBridge' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${Name},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${DefaultServiceNumber},

    [Alias('wv')]
    ${WarningVariable},

    ${TenantDomain},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [switch]
    ${SetDefault},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineDialInConferencingBridge') `
                            -Arg ('Set-CsOnlineDialInConferencingBridge', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineDialInConferencingBridge
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineDialInConferencingServiceNumber' `
{
    param(
    
    [Alias('DC')]
    ${DomainController},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PrimaryLanguage},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [switch]
    ${RestoreDefaultLanguages},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    ${SecondaryLanguages},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineDialInConferencingServiceNumber') `
                            -Arg ('Set-CsOnlineDialInConferencingServiceNumber', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineDialInConferencingServiceNumber
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineDialInConferencingTenantSettings' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${SendEmailFromDisplayName},

    [Alias('ob')]
    ${OutBuffer},

    ${PinLength},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${SendEmailFromAddress},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${AllowPSTNOnlyMeetingsByDefault},

    [Alias('ev')]
    ${ErrorVariable},

    ${EnableEntryExitNotifications},

    ${Identity},

    ${EnableNameRecording},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ov')]
    ${OutVariable},

    ${SendEmailFromOverride},

    ${AutomaticallySendEmailsToUsers},

    ${AutomaticallyReplaceAcpProvider},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineDialInConferencingTenantSettings') `
                            -Arg ('Set-CsOnlineDialInConferencingTenantSettings', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineDialInConferencingTenantSettings
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineDialInConferencingUser' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${AllowPSTNOnlyMeetings},

    ${BridgeName},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${ServiceNumber},

    ${TenantDomain},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('Passcode')]
    ${ConferenceId},

    ${SendEmailFromDisplayName},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    ${SendEmailToAddress},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${SendEmailFromAddress},

    [switch]
    ${ResetLeaderPin},

    [Alias('ResetPasscode')]
    [switch]
    ${ResetConferenceId},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    ${BridgeId},

    [Alias('wa')]
    ${WarningAction},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [switch]
    ${Force},

    [switch]
    ${SendEmail},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineDialInConferencingUser') `
                            -Arg ('Set-CsOnlineDialInConferencingUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineDialInConferencingUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineDirectoryUser' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    ${Ring},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineDirectoryUser') `
                            -Arg ('Set-CsOnlineDirectoryUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineDirectoryUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineEnhancedEmergencyServiceDisclaimer' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${Version},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [switch]
    ${ForceAccept},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    ${CountryOrRegion},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineEnhancedEmergencyServiceDisclaimer') `
                            -Arg ('Set-CsOnlineEnhancedEmergencyServiceDisclaimer', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineEnhancedEmergencyServiceDisclaimer
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineLisCivicAddress' `
{
    param(
    
    [Alias('DC')]
    ${DomainController},

    ${Description},

    ${PreDirectional},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${CompanyName},

    [Alias('wa')]
    ${WarningAction},

    [Alias('db')]
    [switch]
    ${Debug},

    ${StreetName},

    ${City},

    ${StreetSuffix},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${CivicAddressId},

    [Alias('ob')]
    ${OutBuffer},

    ${PostDirectional},

    [Alias('wv')]
    ${WarningVariable},

    ${HouseNumber},

    ${PostalCode},

    ${StateOrProvince},

    ${Tenant},

    ${HouseNumberSuffix},

    ${CountryOrRegion},

    [Alias('ev')]
    ${ErrorVariable},

    [switch]
    ${Force},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineLisCivicAddress') `
                            -Arg ('Set-CsOnlineLisCivicAddress', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineLisCivicAddress
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineLisLocation' `
{
    param(
    
    ${PostalCode},

    [Alias('wa')]
    ${WarningAction},

    ${Description},

    ${CountryOrRegion},

    [Alias('db')]
    [switch]
    ${Debug},

    [switch]
    ${Force},

    [Alias('wv')]
    ${WarningVariable},

    ${PostDirectional},

    ${StreetSuffix},

    ${Tenant},

    [Alias('ea')]
    ${ErrorAction},

    ${StreetName},

    ${City},

    ${HouseNumber},

    ${LocationId},

    ${StateOrProvince},

    ${CivicAddressId},

    ${HouseNumberSuffix},

    [Alias('ov')]
    ${OutVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${PreDirectional},

    ${Location},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${CompanyName},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('DC')]
    ${DomainController},

    [Alias('ev')]
    ${ErrorVariable},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineLisLocation') `
                            -Arg ('Set-CsOnlineLisLocation', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineLisLocation
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineNumberPortInOrder' `
{
    param(
    
    [Alias('wa')]
    ${WarningAction},

    ${LOABase64PayLoad},

    ${SubscriberStreetName},

    ${SubscriberCountry},

    ${LOAContentType},

    [switch]
    ${Force},

    ${SubscriberArea},

    ${SubscriberBusinessName},

    [Alias('wv')]
    ${WarningVariable},

    ${LosingTelcoPin},

    ${SubscriberAddressLine3},

    ${Tenant},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${FriendlyName},

    ${IsPartialPort},

    [Alias('ev')]
    ${ErrorVariable},

    ${RequestedFocDate},

    ${BillingTelephoneNumber},

    ${SubscriberCity},

    [Alias('ov')]
    ${OutVariable},

    [Alias('DC')]
    ${DomainController},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${SubscriberAddressLine2},

    ${PortInOrderId},

    ${SubscriberAddressLine1},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${SubscriberLastName},

    ${LosingTelcoAccountId},

    ${SubscriberBuildingNumber},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('db')]
    [switch]
    ${Debug},

    ${EmailAddresses},

    ${LOAAuthorizingPerson},

    ${SubscriberFirstName},

    ${SubscriberZipCode},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineNumberPortInOrder') `
                            -Arg ('Set-CsOnlineNumberPortInOrder', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineNumberPortInOrder
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineUMDialplan' `
{
    param(
    
    [Alias('wa')]
    ${WarningAction},

    ${NationalNumberPrefix},

    ${InternationalNumberFormat},

    ${AllowedInCountryOrRegionGroups},

    ${AutomaticSpeechRecognitionEnabled},

    ${Identity},

    ${OutsideLineAccessCode},

    ${AllowDialPlanSubscribers},

    ${AudioCodec},

    ${TenantId},

    ${AllowHeuristicADCallingLineIdResolution},

    ${EquivalentDialPlanPhoneContexts},

    ${OperatorExtension},

    [Alias('db')]
    [switch]
    ${Debug},

    ${TUIPromptEditingEnabled},

    ${LogonFailuresBeforeDisconnect},

    ${DefaultLanguage},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${PilotIdentifierList},

    ${AllowExtensions},

    ${LegacyPromptPublishingPoint},

    ${InfoAnnouncementEnabled},

    ${SendVoiceMsgEnabled},

    ${ContactScope},

    ${MaxRecordingDuration},

    ${WelcomeGreetingEnabled},

    [switch]
    ${ForceUpgrade},

    [Alias('ov')]
    ${OutVariable},

    [Alias('ea')]
    ${ErrorAction},

    ${AllowedInternationalGroups},

    ${Extension},

    ${MaxCallDuration},

    ${WelcomeGreetingFilename},

    ${InternationalAccessCode},

    ${InfoAnnouncementFilename},

    ${NumberingPlanFormats},

    ${CallSomeoneEnabled},

    ${ContactAddressList},

    ${AccessTelephoneNumbers},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${CountryOrRegionCode},

    ${DomainController},

    ${FaxEnabled},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${ContactRecipientContainer},

    ${UMAutoAttendant},

    ${ConfiguredInternationalGroups},

    [Alias('ev')]
    ${ErrorVariable},

    ${ConfiguredInCountryOrRegionGroups},

    ${VoIPSecurity},

    [Alias('wv')]
    ${WarningVariable},

    ${CallAnsweringRulesEnabled},

    ${DialByNamePrimary},

    ${DialByNameSecondary},

    [Alias('ob')]
    ${OutBuffer},

    ${Name},

    ${RecordingIdleTimeout},

    ${InputFailuresBeforeDisconnect},

    ${InCountryOrRegionNumberFormat},

    ${MatchedNameSelectionMethod},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineUMDialplan') `
                            -Arg ('Set-CsOnlineUMDialplan', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineUMDialplan
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineUMMailBox' `
{
    param(
    
    [Alias('wa')]
    ${WarningAction},

    ${UMSMSNotificationOption},

    ${AutomaticSpeechRecognitionEnabled},

    ${Identity},

    ${PinlessAccessToVoiceMailEnabled},

    ${PlayOnPhoneEnabled},

    ${AnonymousCallersCanLeaveMessages},

    [Alias('ev')]
    ${ErrorVariable},

    ${UMMailboxPolicy},

    [Alias('db')]
    [switch]
    ${Debug},

    ${TUIAccessToEmailEnabled},

    [switch]
    ${IgnoreDefaultScope},

    [Alias('wv')]
    ${WarningVariable},

    ${TenantId},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${AllowUMCallsFromNonUsers},

    ${CallAnsweringAudioCodec},

    [Alias('ob')]
    ${OutBuffer},

    [switch]
    ${VerifyGlobalRoutingEntry},

    [Alias('ov')]
    ${OutVariable},

    ${SendWelcomeMail},

    ${OperatorNumber},

    ${DomainController},

    ${FaxEnabled},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${PhoneProviderId},

    ${TUIAccessToCalendarEnabled},

    ${ImListMigrationCompleted},

    ${PhoneNumber},

    ${CallAnsweringRulesEnabled},

    ${MissedCallNotificationEnabled},

    ${SubscriberAccessEnabled},

    ${Name},

    ${AirSyncNumbers},

    ${VoiceMailAnalysisEnabled},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineUMMailBox') `
                            -Arg ('Set-CsOnlineUMMailBox', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineUMMailBox
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineUMMailBoxPolicy' `
{
    param(
    
    [Alias('wa')]
    ${WarningAction},

    ${VoiceMailPreviewPartnerAssignedID},

    ${AllowVoiceResponseToOtherMessageTypes},

    ${AllowCommonPatterns},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    ${AllowDialPlanSubscribers},

    ${TenantId},

    ${UMDialPlan},

    ${AllowPinlessVoiceMailAccess},

    ${Name},

    [Alias('ev')]
    ${ErrorVariable},

    ${LogonFailuresBeforePINReset},

    ${VoiceMailPreviewPartnerAddress},

    [Alias('db')]
    [switch]
    ${Debug},

    ${AllowedInCountryOrRegionGroups},

    ${MaxGreetingDuration},

    ${AllowAutomaticSpeechRecognition},

    ${PINHistoryCount},

    ${AllowExtensions},

    ${AllowPlayOnPhone},

    ${ResetPINText},

    ${AllowVoiceMailAnalysis},

    ${FaxServerURI},

    ${AllowFax},

    ${InformCallerOfVoiceMailAnalysis},

    ${PINLifetime},

    ${FaxMessageText},

    ${VoiceMailPreviewPartnerMaxMessageDuration},

    ${AllowedInternationalGroups},

    [Alias('ea')]
    ${ErrorAction},

    ${AllowMissedCallNotifications},

    ${ProtectedVoiceMailText},

    ${AllowSMSNotification},

    ${AllowTUIAccessToEmail},

    [Alias('ov')]
    ${OutVariable},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${AllowMessageWaitingIndicator},

    ${SourceForestPolicyNames},

    ${DomainController},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${VoiceMailText},

    ${ProtectAuthenticatedVoiceMail},

    ${MinPINLength},

    [switch]
    ${ForceUpgrade},

    ${AllowSubscriberAccess},

    ${UMEnabledText},

    ${AllowVoiceMailPreview},

    ${ProtectUnauthenticatedVoiceMail},

    ${AllowVoiceNotification},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${VoiceMailPreviewPartnerMaxDeliveryDelay},

    ${AllowTUIAccessToCalendar},

    ${AllowCallAnsweringRules},

    ${AllowTUIAccessToDirectory},

    ${RequireProtectedPlayOnPhone},

    ${AllowTUIAccessToPersonalContacts},

    ${MaxLogonAttempts},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineUMMailBoxPolicy') `
                            -Arg ('Set-CsOnlineUMMailBoxPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineUMMailBoxPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineVoiceUser' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('DC')]
    ${DomainController},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${TelephoneNumber},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${LocationID},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineVoiceUser') `
                            -Arg ('Set-CsOnlineVoiceUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineVoiceUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsOnlineVoiceUserBulk' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    ${NumberAssignmentDetails},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsOnlineVoiceUserBulk') `
                            -Arg ('Set-CsOnlineVoiceUserBulk', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsOnlineVoiceUserBulk
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsPrivacyConfiguration' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${EnablePrivacyMode},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${PublishLocationDataDefault},

    ${AutoInitiateContacts},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${DisplayPublishedPhotoDefault},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsPrivacyConfiguration') `
                            -Arg ('Set-CsPrivacyConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsPrivacyConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsPushNotificationConfiguration' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${EnableApplePushNotificationService},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${EnableMicrosoftPushNotificationService},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsPushNotificationConfiguration') `
                            -Arg ('Set-CsPushNotificationConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsPushNotificationConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsTenantFederationConfiguration' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${SharedSipAddressSpace},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('ob')]
    ${OutBuffer},

    ${BlockedDomains},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${TreatDiscoveredPartnersAsUnverified},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${AllowFederatedUsers},

    [Alias('ev')]
    ${ErrorVariable},

    ${AllowedDomains},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${Identity},

    ${AllowPublicUsers},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsTenantFederationConfiguration') `
                            -Arg ('Set-CsTenantFederationConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsTenantFederationConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsTenantHybridConfiguration' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    ${HybridConfigServiceInternalUrl},

    [Alias('db')]
    [switch]
    ${Debug},

    ${UseOnPremDialPlan},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${HybridConfigServiceExternalUrl},

    ${Identity},

    [Alias('wv')]
    ${WarningVariable},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${PeerDestination},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsTenantHybridConfiguration') `
                            -Arg ('Set-CsTenantHybridConfiguration', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsTenantHybridConfiguration
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsTenantPublicProvider' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    ${Provider},

    [Alias('ov')]
    ${OutVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsTenantPublicProvider') `
                            -Arg ('Set-CsTenantPublicProvider', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsTenantPublicProvider
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsUser' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    ${SipAddress},

    [Alias('db')]
    [switch]
    ${Debug},

    ${OnPremLineURI},

    ${PrivateLine},

    ${RemoteCallControlTelephonyEnabled},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${AudioVideoDisabled},

    ${EnterpriseVoiceEnabled},

    [Alias('ev')]
    ${ErrorVariable},

    ${LineServerURI},

    ${Identity},

    ${LineURI},

    [Alias('ob')]
    ${OutBuffer},

    ${ExchangeArchivingPolicy},

    [Alias('wa')]
    ${WarningAction},

    ${HostedVoiceMail},

    ${DomainController},

    [Alias('CsEnabled')]
    ${Enabled},

    ${AcpInfo},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsUser') `
                            -Arg ('Set-CsUser', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsUser
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsUserAcp' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${Name},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [switch]
    ${PassThru},

    [Alias('wv')]
    ${WarningVariable},

    ${TollFreeNumbers},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    [Alias('ev')]
    ${ErrorVariable},

    ${ParticipantPasscode},

    ${Identity},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    ${Url},

    ${TollNumber},

    ${Domain},

    ${IsDefault},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsUserAcp') `
                            -Arg ('Set-CsUserAcp', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsUserAcp
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsUserPstnSettings' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    ${AllowInternationalCalls},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${HybridPSTNSite},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsUserPstnSettings') `
                            -Arg ('Set-CsUserPstnSettings', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsUserPstnSettings
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Set-CsUserServicesPolicy' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    ${MigrationDelayInDays},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('ev')]
    ${ErrorVariable},

    ${Identity},

    ${EnableAwaySinceIndication},

    ${Tenant},

    [Alias('wa')]
    ${WarningAction},

    ${UcsAllowed},

    [switch]
    ${Force},

    ${Instance},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Set-CsUserServicesPolicy') `
                            -Arg ('Set-CsUserServicesPolicy', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Set-CsUserServicesPolicy
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Test-CsOnlineCarrierPortabilityIn' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    ${TelephoneNumbers},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Test-CsOnlineCarrierPortabilityIn') `
                            -Arg ('Test-CsOnlineCarrierPortabilityIn', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Test-CsOnlineCarrierPortabilityIn
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Test-CsOnlineLisCivicAddress' `
{
    param(
    
    [Alias('DC')]
    ${DomainController},

    ${Description},

    ${PreDirectional},

    [Alias('ov')]
    ${OutVariable},

    [Alias('vb')]
    [switch]
    ${Verbose},

    ${CompanyName},

    [Alias('wa')]
    ${WarningAction},

    [Alias('db')]
    [switch]
    ${Debug},

    ${StreetName},

    ${City},

    ${StreetSuffix},

    ${CivicAddressId},

    [Alias('ob')]
    ${OutBuffer},

    ${PostDirectional},

    [Alias('wv')]
    ${WarningVariable},

    ${HouseNumber},

    ${PostalCode},

    ${StateOrProvince},

    ${Tenant},

    ${HouseNumberSuffix},

    ${CountryOrRegion},

    [Alias('ev')]
    ${ErrorVariable},

    [switch]
    ${Force},

    [Alias('ea')]
    ${ErrorAction},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Test-CsOnlineLisCivicAddress') `
                            -Arg ('Test-CsOnlineLisCivicAddress', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Test-CsOnlineLisCivicAddress
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Test-CsOnlinePortabilityIn' `
{
    param(
    
    [Alias('ea')]
    ${ErrorAction},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('ov')]
    ${OutVariable},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('wv')]
    ${WarningVariable},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wa')]
    ${WarningAction},

    [Alias('DC')]
    ${DomainController},

    ${TelephoneNumberRanges},

    ${TelephoneNumbers},

    [switch]
    ${Force},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Test-CsOnlinePortabilityIn') `
                            -Arg ('Test-CsOnlinePortabilityIn', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Test-CsOnlinePortabilityIn
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
& $script:SetItem 'function:script:Update-CsTenantMeetingUrl' `
{
    param(
    
    [Alias('wv')]
    ${WarningVariable},

    [Alias('ob')]
    ${OutBuffer},

    [Alias('wi')]
    [switch]
    ${WhatIf},

    [Alias('vb')]
    [switch]
    ${Verbose},

    [Alias('db')]
    [switch]
    ${Debug},

    [Alias('ov')]
    ${OutVariable},

    [switch]
    ${Force},

    [Alias('ev')]
    ${ErrorVariable},

    [Alias('cf')]
    [switch]
    ${Confirm},

    [Alias('ea')]
    ${ErrorAction},

    [Alias('wa')]
    ${WarningAction},

    ${Tenant},

    [switch]
    ${AsJob})

    Begin {
        try {
            $positionalArguments = & $script:NewObject collections.arraylist
            foreach ($parameterName in $PSBoundParameters.BoundPositionally)
            {
                $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
                $null = $PSBoundParameters.Remove($parameterName)
            }
            $positionalArguments.AddRange($args)

            $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

            $scriptCmd = { & $script:InvokeCommand `
                            @clientSideParameters `
                            -HideComputerName `
                            -Session (Get-PSImplicitRemotingSession -CommandName 'Update-CsTenantMeetingUrl') `
                            -Arg ('Update-CsTenantMeetingUrl', $PSBoundParameters, $positionalArguments) `
                            -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                         }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
        } catch {
            throw
        }
    }
    Process { 
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
 }
    End { 
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
 }

    # .ForwardHelpTargetName Update-CsTenantMeetingUrl
    # .ForwardHelpCategory Cmdlet
    # .RemoteHelpRunspace PSSession
}
        
##############################################################################

& $script:ExportModuleMember -Function @('Clear-CsOnlineTelephoneNumberReservation', 'Copy-CsVoicePolicy', 'Disable-CsMeetingRoom', 'Disable-CsOnlineDialInConferencingUser', 'Disable-CsOnlineUMMailBox', 'Enable-CsMeetingRoom', 'Enable-CsOnlineDialInConferencingUser', 'Enable-CsOnlineUMMailBox', 'Get-CsAudioConferencingProvider', 'Get-CsBroadcastMeetingConfiguration', 'Get-CsBroadcastMeetingPolicy', 'Get-CsClientPolicy', 'Get-CsConferencingPolicy', 'Get-CsDialPlan', 'Get-CsExternalAccessPolicy', 'Get-CsExUmContact', 'Get-CsHostedVoicemailPolicy', 'Get-CsHostingProvider', 'Get-CsHybridPSTNSite', 'Get-CsImFilterConfiguration', 'Get-CsIPPhonePolicy', 'Get-CsMeetingConfiguration', 'Get-CsMeetingRoom', 'Get-CsOnlineDialInConferencingBridge', 'Get-CsOnlineDialInConferencingLanguagesSupported', 'Get-CsOnlineDialinConferencingPolicy', 'Get-CsOnlineDialInConferencingServiceNumber', 'Get-CsOnlineDialinConferencingTenantConfiguration', 'Get-CsOnlineDialInConferencingTenantSettings', 'Get-CsOnlineDialInConferencingUser', 'Get-CsOnlineDialInConferencingUserState', 'Get-CsOnlineDirectoryTenant', 'Get-CsOnlineDirectoryTenantNumberCities', 'Get-CsOnlineEnhancedEmergencyServiceDisclaimer', 'Get-CsOnlineLisCivicAddress', 'Get-CsOnlineLisLocation', 'Get-CsOnlineNumberPortInOrder', 'Get-CsOnlineTelephoneNumber', 'Get-CsOnlineTelephoneNumberAvailableCount', 'Get-CsOnlineTelephoneNumberInventoryAreas', 'Get-CsOnlineTelephoneNumberInventoryCities', 'Get-CsOnlineTelephoneNumberInventoryCountries', 'Get-CsOnlineTelephoneNumberInventoryRegions', 'Get-CsOnlineTelephoneNumberInventoryTypes', 'Get-CsOnlineTelephoneNumberReservationsInformation', 'Get-CsOnlineUMDialplan', 'Get-CsOnlineUMMailBox', 'Get-CsOnlineUMMailBoxPolicy', 'Get-CsOnlineUser', 'Get-CsOnlineVoiceUser', 'Get-CsPresencePolicy', 'Get-CsPrivacyConfiguration', 'Get-CsPushNotificationConfiguration', 'Get-CsTenant', 'Get-CsTenantFederationConfiguration', 'Get-CsTenantHybridConfiguration', 'Get-CsTenantLicensingConfiguration', 'Get-CsTenantPublicProvider', 'Get-CsUserAcp', 'Get-CsUserPstnSettings', 'Get-CsUserServicesPolicy', 'Get-CsVoicePolicy', 'Get-CsVoiceRoutingPolicy', 'Grant-CsBroadcastMeetingPolicy', 'Grant-CsClientPolicy', 'Grant-CsConferencingPolicy', 'Grant-CsDialPlan', 'Grant-CsExternalAccessPolicy', 'Grant-CsHostedVoicemailPolicy', 'Grant-CsIPPhonePolicy', 'Grant-CsVoicePolicy', 'Grant-CsVoiceRoutingPolicy', 'Invoke-CsUcsRollback', 'New-CsEdgeAllowAllKnownDomains', 'New-CsEdgeAllowList', 'New-CsEdgeDomainPattern', 'New-CsExUmContact', 'New-CsHybridPSTNSite', 'New-CsOnlineBulkAssignmentInput', 'New-CsOnlineLisCivicAddress', 'New-CsOnlineLisLocation', 'New-CsOnlineNumberPortInOrder', 'New-CsOnlineUMDialplan', 'New-CsOnlineUMMailBoxPolicy', 'Remove-CsExUmContact', 'Remove-CsHybridPSTNSite', 'Remove-CsOnlineDialInConferencingTenantSettings', 'Remove-CsOnlineLisCivicAddress', 'Remove-CsOnlineLisLocation', 'Remove-CsOnlineNumberPortInOrder', 'Remove-CsOnlineTelephoneNumber', 'Remove-CsOnlineUMDialplan', 'Remove-CsOnlineUMMailBoxPolicy', 'Remove-CsUserAcp', 'Remove-CsVoicePolicy', 'Search-CsOnlineTelephoneNumberInventory', 'Select-CsOnlineTelephoneNumberInventory', 'Set-CsBroadcastMeetingConfiguration', 'Set-CsClientPolicy', 'Set-CsExUmContact', 'Set-CsHybridPSTNSite', 'Set-CsIPPhonePolicy', 'Set-CsMeetingConfiguration', 'Set-CsMeetingRoom', 'Set-CsOnlineDialInConferencingBridge', 'Set-CsOnlineDialInConferencingServiceNumber', 'Set-CsOnlineDialInConferencingTenantSettings', 'Set-CsOnlineDialInConferencingUser', 'Set-CsOnlineDirectoryUser', 'Set-CsOnlineEnhancedEmergencyServiceDisclaimer', 'Set-CsOnlineLisCivicAddress', 'Set-CsOnlineLisLocation', 'Set-CsOnlineNumberPortInOrder', 'Set-CsOnlineUMDialplan', 'Set-CsOnlineUMMailBox', 'Set-CsOnlineUMMailBoxPolicy', 'Set-CsOnlineVoiceUser', 'Set-CsOnlineVoiceUserBulk', 'Set-CsPrivacyConfiguration', 'Set-CsPushNotificationConfiguration', 'Set-CsTenantFederationConfiguration', 'Set-CsTenantHybridConfiguration', 'Set-CsTenantPublicProvider', 'Set-CsUser', 'Set-CsUserAcp', 'Set-CsUserPstnSettings', 'Set-CsUserServicesPolicy', 'Test-CsOnlineCarrierPortabilityIn', 'Test-CsOnlineLisCivicAddress', 'Test-CsOnlinePortabilityIn', 'Update-CsTenantMeetingUrl')
        
##############################################################################

& $script:ExportModuleMember -Alias @()
        