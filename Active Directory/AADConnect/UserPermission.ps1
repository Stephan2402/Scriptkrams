############################################################################
###
### Azure AD Connect On-Premise Sync User Account Creation Script
###
### Please send your questions or concerns to stephan.verstegen@bechtle.com
###
### Stephan Verstegen / (c) 2016
###
############################################################################
### USAGE
###
### This small script gives the specified User the minimal Userrights to Sync with Azure AD.
### Before starting the script please edit the variables.
### $DN = Specifie the OU on which you want to set the rights.
### $Account = the useraccount that will be granted
###
############################################################################
### CHANGELOG
###
### version 1.2 (stephan.verstegen@bechtle.com):
### * Update msDS-ExternalDirectoryObjectID
### * Support Version 1.1.110.1
###
### version 1.1 (stephan.verstegen@bechtle.com):
### * Update for Password Writeback
###
### version 1.0 (Sven.Westphal@bechtle.com):
### * initial release
###
############################################################################

### Variables
$DN = "OU=MSO365,DC=mso365,DC=local"
$Account = "mso365\testsyncperm2"
### Variables

############################################################################
### DO NOT CHANGE ANYTHING BELOW THIS LINE
### BEGIN SIGN
############################################################################

### Immer benötigt
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;mS-DS-ConsistencyGuid;user'"
Invoke-Expression $cmd

### Update Attributes HYBRID-CONFIG

# Object type: user
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;proxyAddresses;user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;msExchUCVoiceMailSettings;user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;msExchUserHoldPolicies;user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;msExchArchiveStatus;user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;msExchSafeSendersHash;user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;msExchBlockedSendersHash;user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;msExchSafeRecipientsHash;user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;msDS-ExternalDirectoryObjectID;user'"
Invoke-Expression $cmd
# Object type: group
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;proxyAddresses;group'"
Invoke-Expression $cmd
# Object type: contact
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;proxyAddresses;contact'"
Invoke-Expression $cmd
  
$RootDSE = [ADSI]"LDAP://RootDSE"
$DefaultNamingContext = $RootDse.defaultNamingContext
$ConfigurationNamingContext = $RootDse.configurationNamingContext
 
### Update Attributes PASSWORD SYNC
 
# Object type: user
$cmd = "dsacls '$DefaultNamingContext' /G '`"$Account`":CA;`"Replicating Directory Changes`";'"
Invoke-Expression $cmd
$cmd = "dsacls '$DefaultNamingContext' /G '`"$Account`":CA;`"Replicating Directory Changes All`";'"
Invoke-Expression $cmd
 
### Update Attributes PASSWORD WRITEBACK
 
# Object type: user
 
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":CA;`"Reset Password`";user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":CA;`"Change Password`";user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;pwdLastSet;user'"
Invoke-Expression $cmd
$cmd = "dsacls '$DN' /I:S /G '`"$Account`":WP;lockoutTime;user'"
Invoke-Expression $cmd
############################################################################
### END SIGN
### DO NOT CHANGE ANYTHING ABOVE THIS LINE
############################################################################