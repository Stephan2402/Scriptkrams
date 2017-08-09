function Get-O365PrincipalGroupMembership
{
	<#
		.DESCRIPTION
		Lists distribution group membership for an Exchange Online recipient

		.PARAMETER Identity
		Specifies an Exchange Online recipient. Valid attributes are:

		Displayname
		Example: 'Matthew McNabb'

		UserPrincipalName
		Example: matt@domain.com

		DistinguishedName
		Example: 'CN=Matthew McNabb,OU=Domain.onmicrosoft.com,OU=Microsoft Exchange Hosted Organizations,DC=NAMPR07B091,DC=prod,DC=outlook,DC=com'

		Alias
		Example: matt

		.EXAMPLE
		Get-O365PrincipalGroupMembership -Identity matt

		This command retrieves the group membership for the recipient with alias 'matt'
	#>
    
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('Identity')]
        [string]
        $UserPrincipalName
    )
    
    Reconnect-O365Exchange

    $Recipient = Get-Recipient -Identity $UserPrincipalName

    $Groups = Get-Group -ResultSize Unlimited -RecipientTypeDetails 'MailUniversalDistributionGroup','MailUniversalSecurityGroup'

    foreach ($Group in $Groups)
    {
        if ($Group.Members -contains $Recipient.Identity) { $Group.Identity }
    }
}