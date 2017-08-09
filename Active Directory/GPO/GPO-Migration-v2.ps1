PARAM(
#User Variables
[STRING]$SourceDomain
[STRING]$TargetDomain
[STRING]$PathtoCSV
)

$LogFile = "GPOLog.txt"
$backuppath = $PathtoCSV + "\backup\"
$PermissionGroup1 = "RG-GBHCN-SPG-LocalSupporter"
$PermissionGroup2 = "RG-GBHCN-GPADM"

#Function Logfile
function Write-Log ($Inhalt)
{
$FileExists = Test-Path $LogFile
    $DateNow = Get-Date -Format "dd.MM.yyyy HH:mm"
    $FileInp = $DateNow + ' | ' + $Inhalt                         
    If ($FileExists -eq $True){
        Add-Content $LogFile -value $FileInp
    } else {
       $new = New-Item $Logfile -type file
       Add-Content $LogFile -value $FileInp 
    }
}

$ErrorActionPreference = "SilentlyContinue"
#Module Import
Import-Module GroupPolicy
Import-Module ActiveDirectory

#Import CSV File with needed GPOs
$gpolist = Import-CSV $PathtoCSV -Header SourceGPO,TargetGPO

#Backup and Import GPOs
Write-Host "Start GPO migration ..." -ForegroundColor Yellow
Write-Host "........" -ForegroundColor Yellow
ForEach ($gpo in $gpolist){
                            $sourcegpo = $gpo.sourcegpo
                            $targetgpo = $gpo.targetgpo
                            $error.PSBase.Clear()
                            #Check if Target GPO exist
                            $CheckGPO2 = Get-GPO -Name $targetgpo -Domain $targetdomain
                              If ($error.Count -eq 0)
                                                      {
                                                        Write-Log -Inhalt "ERROR: GPO in $targetdomain with name $targetgpo already exist!"
                                                      }
                              ElseIf ($error.Count -ne 0)
                                                      {
                                                        #Check if Source GPO exist
                                                        $CheckGPO1 = Get-GPO -Name $sourcegpo -Domain $sourcedomain
                                                          If ($error.Count -eq 0)
                                                                                  {
                                                                                    Write-Log -Inhalt "ERROR: GPO in $sourcedomain with name $sourcegpo already exist!"
                                                                                  }
                                                              ElseIf ($error.Count -ne 0)
                                                                                          {
                                                                                            #Backup GPO from list
                                                                                            Write-Log "Starting Backup $sourcegpo" -ForegroundColor Yellow
                                                                                            $Backup = Backup-Gpo -Name $sourcegpo -Domain $sourcedomain -Path $backuppath
                                                                                            Write-Log "Backup for $sourcegpo done" -ForegroundColor DarkGreen
                                                                                            Write-Log "Changing $sourcegpo to $targetgpo" -ForegroundColor Red
                                                                                            #Import GPO from Backup
                                                                                            Write-Log "Starting Import $targetgpo" -ForegroundColor Yellow
                                                                                            $Backup = Import-Gpo -BackupGpoName $sourcegpo -TargetName $targetgpo -Domain $targetdomain -CreateIfNeeded -Path $backuppath
                                                                                            Write-Log "Import for $targetgpo done" -ForegroundColor DarkGreen
                                                                                            #Set GPO Permissons
                                                                                            #$Set1 = Set-GPPermissions -Name $targetgpo -PermissionLevel GpoEditDeleteModifySecurity -TargetName $PermissionGroup1 -TargetType Group
                                                                                            #Write-Log "Permission for $PermissionGroup1 added!" -ForegroundColor DarkGreen
                                                                                            #$Set2 = Set-GPPermissions -Name $targetgpo -PermissionLevel GpoEditDeleteModifySecurity -TargetName $PermissionGroup2 -TargetType Group
                                                                                            #Write-Log "Permission for $PermissionGroup2 added!" -ForegroundColor DarkGreen
                                                                                            Write-Log "-------------------" -ForegroundColor White
                                                                                            }
                                                        }
}
Write-Host "Please check log files" -ForegroundColor Yellow
Write-Host "GPO Migration done!" -ForegroundColor DarkGreen

