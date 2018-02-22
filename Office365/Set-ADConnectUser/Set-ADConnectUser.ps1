<# 
    .SYNOPSIS 
    This small script gives the specified User the minimal Userrights to Sync with Azure AD.
	
    Stephan Verstegen 
	
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
	
    Version 1.0, 2017-08-09
	
    Please send ideas, comments and suggestions to support@verstegen-online.de
	
    .LINK 
    
    .LINK
    
    .DESCRIPTION 
	This small script gives the specified User the minimal Userrights to Sync with Azure AD.
    Please read all first.
    
    .NOTES 
    Requirements 
    - GlobalFuntions Modul https://www.powershellgallery.com/packages/GlobalFunctions/2.0
    - Active Directory PowerShell Modul
    - Existing AD Service Account
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release
    1.1      Add Exchange Hybrid function
    
	
	
    .PARAMETER OnPremUser
    Name of the existing Service Account "Domain\SAMAccountName"
	
    .PARAMETER DistinguishedName
    DistinguishedName where the permission will be set. Recommended like "DC=contoso,DC=com"
	
    .PARAMETER PasswordSync
    Set all needed permission for password sync

    .PARAMETER PasswordWritback
    Set all needed permission for password writeback.
    WARNING: You will need Azure AD Premium Plan 1/2 to use this feature.

    .PARAMETER PasswordWritback
    Set all needed permission for Exchange Hybrid environments.
	
    .EXAMPLE
    Set-ADConnectUser -OnPremUser "constoso\John.doe" -DistinguishedName "DC=contoso,DC=com" -PasswordSync

    Add all needed minimal Permissions for AD User John Doe in "DC=constoso,DC=com" for AD Connect with PasswordSync.

#>
[CmdletBinding()]
Param(
  [string]$OnPremUser= 'domain\user',
  [string]$DistinguishedName = 'DC=contoso,DC=com',
  [switch]$PasswordSync,
  [switch]$PasswordWriteback,
  [switch]$ExchangeHybrid
)

# Import required modules
Import-Module -Name ActiveDirectory
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')

function Set-Permissions {
    [CmdletBinding()]
    Param(
      [string]$cmd = '',
      [string]$Status = 'No Status'
    )
    try{
        $Log = Invoke-Expression $cmd
    } catch {
    $logger.Write(('Failed to set permissions {0} for {1}' -f $Status, $OnPremUser))
    $logger.Write(('Error: {0}' -f $_))
    return
    }
    $Log | Out-File "$ScriptDir\logs\$Status.log" -Append
    $logger.Write(('Permission on {0} set for {1}' -f $Status, $OnPremUser))
}

## MAIN ####################################################################################################

# Always needed, because AD Connect will write the GUID back to On-Premises
        $logger.Write('### Set permission for global attributes')
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;mS-DS-ConsistencyGuid;user'" -Status "mS-DS-ConsistencyGuid"

# Password Sync
if($PasswordSync){
        $logger.Write('### Set permission for password sync attributes')
        $RootDSE = [ADSI]"LDAP://RootDSE"
        $DefaultNamingContext = $RootDse.defaultNamingContext
        $ConfigurationNamingContext = $RootDse.configurationNamingContext

        Set-Permissions -cmd "dsacls '$DefaultNamingContext' /G '`"$OnPremUser`":CA;`"Replicating Directory Changes`";'" -Status "Replicating Directory Changes"
        Set-Permissions -cmd "dsacls '$DefaultNamingContext' /G '`"$OnPremUser`":CA;`"Replicating Directory Changes All`";'" -Status "Replicating Directory Changes All"
}

# Password Writeback ATTENTION - Azure AD Premium needed!
if($PasswordWriteback){
        $logger.Write('### Set permission for password writeback attributes')
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":CA;`"Reset Password`";user'" -Status "Reset Password"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":CA;`"Change Password`";user'" -Status "Change Password"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;pwdLastSet;user'" -Status "Password last set"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;lockoutTime;user'" -Status "Lockout time"
}

# Exchange Hybrid
if($ExchangeHybrid){
        $logger.Write('### Set permission for Exchange Hybrid attributes')
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;msDS-ExternalDirectoryObjectID;user'" -Status "msDS-ExternalDirectoryObjectID"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;msExchArchiveStatus;user'" -Status "msExchArchiveStatus"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;msExchBlockedSendersHash;user'" -Status "msExchBlockedSendersHash"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;msExchSafeRecipientsHash;user'" -Status "msExchSafeRecipientsHash"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;msExchSafeSendersHash;user'" -Status "msExchSafeSendersHash"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;msExchUCVoiceMailSettings;user'" -Status "msExchUCVoiceMailSettings"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;msExchUserHoldPolicies;user'" -Status "msExchUserHoldPolicies"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;proxyAddresses;user'" -Status "proxyAddresses-User"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;proxyAddresses;group'" -Status "proxyAddresses-Group"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;proxyAddresses;contact'" -Status "proxyAddresses-Contact"
        Set-Permissions -cmd "dsacls '$DistinguishedName' /I:S /G '`"$OnPremUser`":WP;publicDelegates;user'" -Status "publicDelegates"        
}


# We are finsihed
$logger.Write('For more information see specified log files')
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')