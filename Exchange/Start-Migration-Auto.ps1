############################################################################
###
### Exchange Migration to Cloud / Autostart MigrationBatch Script
###
### Please send your questions or concerns to info@verstegen-online.de
###
### Stephan Verstegen / (c) 2016
###
############################################################################
### USAGE
###
### This small script starts all MigrationBatch in Exchange Online that are not in Status: Completed, Completing, Syncing or Stopping!!
### Before starting the script please create the CRED.TXT file!
### You can do that by running following command
### read-host -assecurestring | convertfrom-securestring | out-file C:\temp\cred.txt --> Enter Password and you got the Hash-File
###
############################################################################
### CHANGELOG
###
### version 1.0 (Stephan@verstegen-online.de):
### * initial release
###
############################################################################
### PLEASE FEEL FREE TO EDIT THIS LINES
	$O365Username = "????@????.???"
	$PWFilePath = "C:\temp\cred.txt"
###
############################################################################
### DO NOT CHANGE ANYTHING BELOW THIS LINE
### BEGIN SIGN
############################################################################
$ErrorActionPreference = "SilentlyContinue"
$O365Password = get-content $PWFilePath | convertto-securestring
#Write-Host "Enter your Office 365 admin credentials" -ForegroundColor White
Write-Host " "
#$Credentials = Get-Credential -Message "Enter your Office 365 admin credentials"
$Credentials = New-Object -typename System.Management.Automation.PSCredential -argumentlist $O365Username,$O365Password
Write-Host "Credentials added!" -ForegroundColor Green
Write-Host " "
Write-Host "Create Session ..." -ForegroundColor White
Write-Host " "
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credentials -Authentication Basic -AllowRedirection -Name "Exchange Online"
$ImportSession = Import-PSSession $Session
If ($Error.Count -eq 0)
{
	Write-Host "Session started!" -ForegroundColor Green
	Write-Host " "
	Write-Host "Search for Migration Batches..." -ForegroundColor Green
	Write-Host "--------------------------------------------"
	$MigBatch = Get-MigrationBatch | Where-Object {$_.Status -NotMatch "Complet*" -and $_.Status -NotMatch "Syncing" -and $_.Status -NotMatch "Starting" -and $_.Status -NotMatch "Stopping" }

	If (!$MigBatch)
	{ 
		Write-Host " "
		Write-Host "All Migrations Batches are completed or running!" -ForegroundColor Red
		Write-Host " "
	}
	ElseIf ($MigBatch)
	{
		ForEach	($array in $MigBatch)
		{
			$BatchName = $array.identity.name
			Start-MigrationBatch -Identity $BatchName
			Write-Host "Found MigrationBatch $BatchName and start the Batch!" -ForegroundColor Green
			Write-Host " "
		}
	}
	Remove-PSSession -Name "Exchange Online"
	Write-Host " "
	Write-Host "Session ended!" -ForegroundColor Green
	Write-Host " "
}
If ($Error.Count -ne 0)
{
	Write-Host "Session cannot established!" -ForegroundColor Red
	Write-Host " "
	Write-Host $Error[0].Exception
}
############################################################################
### END SIGN
### DO NOT CHANGE ANYTHING ABOVE THIS LINE
############################################################################