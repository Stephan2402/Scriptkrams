<#  
.SYNOPSIS 
    Script that copies the primary emailaddress from proxyAddresses to the userPrincipalName attribute.  
    It runs in test mode and just logs the changes that would have bee done without any parameters.  
    It identifies an exchange user with the mail-attribute.  
.PARAMETER Production 
    Runs the script in production mode and makes the actual changes.   
#>
param(
[parameter(Mandatory=$false)]
[switch]
$Production = $false
)
#Define variables
$SearchMailSuffix = "@westfalen.com"
$SearchBase = "OU=test,DC=mso365,DC=local"
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$DateStamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$Logfile = $LogFile = ($PSScriptRoot + "\ProxyUPNSync-" + $DateStamp + ".log")
Function LogWrite
{
Param ([string]$logstring)
Add-content $Logfile -value $logstring
Write-Host $logstring
}
    try
    {
        Import-Module ActiveDirectory -ErrorAction Stop
    }
    catch
    {
        throw "Module ActiveDirectory not Installed"
    }
 
#For each AD-user with Mail *@westfalen.com, look up primary SMTP: in proxyAddresses
#and use that as the UPN
$CollObjects=Get-ADObject -LDAPFilter "(&(mail=*$SearchMailSuffix)(objectClass=user))" -SearchBase $SearchBase -Properties ProxyAddresses,distinguishedName,userPrincipalName
 
            foreach ($object in $CollObjects)
            {
                $Addresses = ""
                $DN=""
                $UserPrincipalName=""
                $Addresses = $object.proxyAddresses
                $ProxyArray=""
                $DN=$object.distinguishedName
                    foreach ($Address In $Addresses)
                    {
                        $ProxyArray=($ProxyArray + "," + $Address)
                        If ($Address -cmatch "SMTP:")
                            {
                                $PrimarySMTP = $Address
                                $UserPrincipalName=$Address -replace ("SMTP:","")
                                    #Found the object validating UserPrincipalName
                                    If ($object.userPrincipalName -notmatch $UserPrincipalName) {
                                        #Run in production mode if the production switch has been used
                                        If ($Production) {
                                            LogWrite ($DN + ";" + $object.userPrincipalName + ";NEW:" + $UserPrincipalName)
                                            Set-ADObject -Identity $DN -Replace @{userPrincipalName = $UserPrincipalName}
                                        }
                                        #Runs in test mode if the production switch has not been used
                                        else {
                                        LogWrite ($DN + ";" + $object.userPrincipalName + ";NEW:" + $UserPrincipalName)
                                        Set-ADObject -Identity $DN -WhatIf -Replace @{userPrincipalName = $UserPrincipalName}
                                        }
                            }
                            else
                            {
                            Write-Host "Info: All users primary email addresses are matching their userPrincipalName"
 
                            }
                        }
                    }
            }
 