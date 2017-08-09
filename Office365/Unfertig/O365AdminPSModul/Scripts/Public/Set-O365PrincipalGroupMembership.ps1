function Set-O365PrincipalGroupMembership
{
    <#
        .DESCRIPTION
        Configures group membership for an Exchange Online recipient.

        .PARAMETER Identity
        Specifies an Exchange Online recipient whose group membership you will modify.

        .PARAMETER MemberOf
        Specifies the group(s) that the recipient will be a member of.

        .PARAMETER Replace
        If -Replace is included with -MemberOf then any previous group membership will be removed.

        .PARAMETER Clear
        The -Clear switch parameter will remove all group membership for the recipient.

        .EXAMPLE
        Set-O365PrincipalGroupMembership -Identity matt -Memberof 'sales','IT'

        Adds the sales and IT groups to Matt's current group membership
        .EXAMPLE
        Set-O365PrincipalGroupMembership -Identity matt -Memberof 'sales','IT' -Replace

        Replaces and current group membership for Matt with the Sales and IT groups

        .EXAMPLE
        Set-O365PrincipalGroupMembership -Identity matt -Clear

        Removes all group membership for Matt
    #>
    [CmdletBinding(DefaultParameterSetName = 'MemberOf')]
    Param
    (
        # Office 365 user to modify
        [parameter(ParameterSetName='MemberOf')]
        [parameter(ParameterSetName='Clear')]
        [parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias('Identity')]
        $UserPrincipalName,

        # An array of groups to add the user to. Separate group names with a comma.
        [parameter(ParameterSetName='MemberOf')]
        [ValidateNotNullorEmpty()]
        [string[]]$MemberOf,

        # If set then the user will be removed from any distribution groups not specified.
        [parameter(ParameterSetName='MemberOf')]
        [switch]$Replace,

        [parameter(ParameterSetName='Clear')]
        [switch]$Clear
    )

    Reconnect-O365Exchange

    If ($Replace -or $Clear)
    {
        Get-O365PrincipalGroupMembership  -UserPrincipalName $UserPrincipalName |
        ForEach-Object  -Process {
            $Params = @{
                Identity = $_
                Member = $UserPrincipalName
                Confirm = $false
                BypassSecurityGroupManagerCheck = $true
            }
            Remove-DistributionGroupMember @params
        }
    }

    If ($MemberOf -eq $null) {return}

    $MemberOf |
    ForEach-Object  -Process {
        $Params = @{
                Identity = $_
                Member = $UserPrincipalName
                Confirm = $false
                BypassSecurityGroupManagerCheck = $true
            }
        Add-DistributionGroupMember @Params
    }
}