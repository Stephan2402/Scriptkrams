function Reconnect-O365Exchange
{
    <#
            .DESCRIPTION
            Checks for available connections to Exchange Online and 
            reconects if session is in a disconnected or broken state.    
    #>

    try {Get-PSSession | Test-O365ExchSessionState}
    catch
    {
        Write-Warning -Message 'The connection to Exchange Online has timed out. Reconnecting...'
        Disconnect-O365 -Services Exchange
        Connect-O365 -Services Exchange
    }
}