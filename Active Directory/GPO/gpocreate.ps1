$ErrorActionPreference = "SilentlyContinue"
Import-Module GroupPolicy
Import-Module ActiveDirectory
$GPOlist = Get-Content c:\temp\GPOs\GPOlist.txt
$PermissionGroup1 = "RG-DEVIS-SPG-LocalSupporter"
$PermissionGroup2 = "RG-DEVIS-GPADM"
foreach ($gpo in $GPOlist)
{
  $error.PSBase.Clear()
  $targetGPO = Get-GPO -Name $gpo
  If ($error.Count -eq 0)
  {
    Write-Host "GPO with name $gpo already exist!" -ForegroundColor Red
  }
  ElseIf ($error.Count -ne 0)
  {
    $gpoName = $gpo
    New-GPO -name $gpoName
    Write-Host "GPO $gpoName created!" -ForegroundColor Green
    $Set1 = Set-GPPermissions -Name $gpoName -PermissionLevel GpoEditDeleteModifySecurity -TargetName $PermissionGroup1 -TargetType Group
    Write-Host "Permission for $PermissionGroup1 added!" -ForegroundColor Green
    $Set2 = Set-GPPermissions -Name $gpoName -PermissionLevel GpoEditDeleteModifySecurity -TargetName $PermissionGroup2 -TargetType Group
    Write-Host "Permission for $PermissionGroup2 added!" -ForegroundColor Green
    Write-Host ""
    Write-Host ""
  }
}