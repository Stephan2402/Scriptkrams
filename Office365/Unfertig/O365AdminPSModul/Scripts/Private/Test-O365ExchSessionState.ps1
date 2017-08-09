function Test-O365ExchSessionState
{
    <#
            .DESCRIPTION
            Checks for a current Exchange Online session. If session does
            not exist or is broken, an error is returned.
    #>
    param
    (
        [parameter(ValueFromPipeline=$true)]
        [System.Management.Automation.Runspaces.PSSession]
        $Session
    )

    begin {
        $ExchSessions = @()
    }

    process {
        if ($Session.computername -eq $ExchComputerName)
        {
            $ExchSessions += $Session
            if (($Session.state -ne 'Opened') -or ($Session.availability -ne 'Available'))
            {
                throw
            }
        }
    }

    end {
        if (!$ExchSessions)
        {
            throw
        }
    }
}