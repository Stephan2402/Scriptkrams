# Add-Computer.ps1  
# -----------------------------------------------  
# Create a new computer object in a new computer specific  
# OU which will be created as a child of a configured base OU.  
# Two new security groups will be created and added to the newly created OU.  
# A new GPO will be created from a GPO template and linked to the new computer OU.  
  
# Fetch comand line parameters first  
Param([string]$servername="")  
  
# Get date and time for script start  
$dateScriptStart = Get-Date -Format "yyyy-MM-dd HH:mm:ss"  
  
# Configuration settings  
# ====================== MAKE CHANGES HERE  
$ouPrefix = "OU_"                                           # Prefix for new created OUs  
$groupPrefixAdm = "ADM_"                                    # Groupname prefix for admin users  
$groupPrefixRdp = "RDP_"                                    # Groupname prefix for RDP users  
$ouBaseDN = "OU=Test,OU=ICC IT, DC=ICOMCEPT, DC=DE"         # Base OU for computer specific OU  
  
$gpoTemplateName = "ADM Server Master Template"             # Name of the gpo template  
$admGroupTemplateName = "ADM_LocalAdministratorsTemplate"   # Name of the admin group name template  
$rdpGroupTemplateName = "ADM_RemoteDesktopUsersTemplate"    # Name of the remote desktop template  
$gpoTargetNamePrefix = "ADM Server Admin "                  # GPO name prefix, server name will be added      
  
# Local GPO export path, will be created automatically  
$gpoExportPath = "c:\GPOExport"                               
# Folder path to groups settings  
$gpoGroupsSettingsPath = "\DomainSysvol\GPO\Machine\Preferences\Groups\Groups.xml"   
# ======================  
  
# Decription for new OU, security groups and computer objects  
$ouDescription = "OU automatically generated " + $dateScriptStart  
$groupDescription = "Group automatically generated " + $dateScriptStart  
$computerDescription = "Computer account generated " + $dateScriptStart  
  
# Add Quest AD Management Snapin  
if ( (Get-PSSnapin -Name Quest.ActiveRoles.ADManagement -ErrorAction SilentlyContinue) -eq $null )  
{  
    Add-PsSnapin Quest.ActiveRoles.ADManagement  
}  
# Import active directory powershell module  
Import-Module grouppolicy  
  
If($servername -eq "")  
{  
    Write-Host "Did you forget the servername?"  
    $servername = Read-Host -Prompt "Severname: "  
}  
  
# Fetch base OU first  
$baseOU = Get-QADObject -Type organizationalUnit -Identity $ouBaseDN  
  
# Check if base object has been found  
if(($baseOU.ParentContainerDN -ne "") -and ($servername -ne ""))  
{  
    Write-Host "Base OU found: " $baseOU.DN  
      
    $servernameUpper = $servername.ToUpper()  
    Write-Host "Create new Server: " $servernameUpper  
  
    # Build new OU name  
    $ouNew = $ouPrefix + $servernameUpper  
    Write-Host "  New OU Name:   " $ouNew  
      
    # Add new OU and use computer account container as parent container  
    New-QADObject -Type organizationalUnit -ParentContainer $baseOU.DN -Name $ouNew -Description $ouDescription  
      
    # Fetch new OU object from ad  
    $ouGenerated = Get-QADObject -Type organizationalUnit -Name $ouNew  
      
    # Check if new OU exists  
    if($ouGenerated.ParentContainerDN -ne "")  
    {  
        # Add new computer object in new computer OU  
        New-QADComputer -Name $servernameUpper -ParentContainer $ouGenerated.CanonicalName -Description $computerDescription  
  
        # build new group names  
        $newAdmGroup = $groupPrefixAdm + $servernameUpper  
        $newRdpGroup = $groupPrefixRdp + $servernameUpper  
        Write-Host "  New ADM Group: " $newAdmGroup  
        Write-Host "  New RDP Group: " $newRdpGroup  
          
        # Create new adm group in new OU  
        New-QADGroup -ParentContainer $ouGenerated.CanonicalName -Name $newAdmGroup -Description $groupDescription -GroupScope DomainLocal -SamAccountName $newAdmGroup  
          
        # Create new rdp group in new OU              
        New-QADGroup -ParentContainer $ouGenerated.CanonicalName -Name $newRdpGroup -Description $groupDescription -GroupScope DomainLocal -SamAccountName $newRdpGroup  
          
        # Copy GPO template and   
        # Check if GPO Export folder exists, otherwise create  
        if (Test-Path $gpoExportPath)  
        {   # Nothing to do }  
        else  
        {  
            Write-Host "Create GPO export folder " $gpoExportPath  
            MD $gpoExportPath  
        }  
          
        # Perform export tasks only, if GPO export path is present  
        if (Test-Path $gpoExportPath)  
        {  
            # Export GPO template to export folder  
            $gpoBackup = Backup-GPO $gpoTemplateName -Path $gpoExportPath  
              
            # We do get a new id with each backup, so we have to remind it  
            Write-Host "GPO template backed up as Id: " $gpoBackup.Id  
              
            $groupFile = $gpoExportPath + "\{" + $gpoBackup.Id + "}\" + $gpoGroupsSettingsPath 
            Write-Host "Modifing GPO settings in: " $groupFile 
             
            # Prepare gpo settings 
            $gpoAdminGroupName = $groupPrefixAdm + $servername 
            $gpoRdpGroupName = $groupPrefixRdp + $servername 
             
            # Get admin groups from ad 
            Write-Host "Fetching Server Admin group: " $gpoAdminGroupName 
            $serverAdminGroup = Get-QADGroup $gpoAdminGroupName 
            $admGroupTemplate = Get-QADGroup $admGroupTemplateName 
             
            # Get rdp groups from ad 
            Write-Host "Fetching Server RDP group  : " $gpoRdpGroupName 
            $serverRdpGroup = Get-QADGroup $gpoRdpGroupName 
            $rdpGroupTemplate = Get-QADGroup $rdpGroupTemplateName 
             
            # Check if we have found the servers administrators and the admin template groups 
            if(($serverAdminGroup -ne $null) -and ($admGroupTemplate -ne $null) -and ($serverRdpGroup -ne $null) -and ($rdpGroupTemplate -ne $null))  
            { 
                # Replace local administrators group name 
                Write-Host "Replacing [" $admGroupTemplateName "] with [" $gpoAdminGroupName "]" 
                $r = (Get-Content $groupFile) -replace $admGroupTemplateName, $gpoAdminGroupName 
                Set-Content $groupFile $r 
                 
                # Replace local administrators group SID 
                Write-Host "Replacing [" $admGroupTemplate.SID "] with [" $serverAdminGroup.SID "]" 
                $r = (Get-Content $groupFile) -replace $admGroupTemplate.SID, $serverAdminGroup.SID 
                Set-Content $groupFile $r 
                 
                # Now we try to replace the local rdp group members 
                # Replace local rdp group name 
                Write-Host "Replacing [" $rdpGroupTemplateName "] with [" $gpoRdpGroupName "]" 
                $r = (Get-Content $groupFile) -replace $rdpGroupTemplateName, $gpoRdpGroupName 
                Set-Content $groupFile $r 
                 
                # Replace local rdp group SID 
                Write-Host "Replacing [" $rdpGroupTemplate.SID "] with [" $serverRdpGroup.SID "]" 
                $r = (Get-Content $groupFile) -replace $rdpGroupTemplate.SID, $serverRdpGroup.SID 
                Set-Content $groupFile $r 
                 
                # Now, that we've modified the gpo, lets import the group and link it to the servers ou 
                $newGpoName = $gpoTargetNamePrefix + $servername 
                Write-Host "Importing modified GPO: " $newGpoName 
                Import-GPO -BackupId $gpoBackup.Id -TargetName $newGpoName -Path $gpoExportPath -CreateIfNeeded 
                 
                $serverOU = $ouPrefix + $servername 
                 
                # Find server OU 
                Write-Host "Linking GPO to OU     : " $serverOU 
                $ou = Get-QADObject $serverOU -Type organizationalUnit 
                 
                Get-GPO $newGpoName | New-GPLink -target $ou.DN -LinkEnabled Yes 
                 
                # Rename GUID named GPO backup file to a more readable one (server name) 
                $source = $gpoExportPath + "\{" + $gpoBackup.ID + "}" 
                $target = $gpoExportPath + "\" + $servername 
                Move-Item $source $target 
                 
                Write-Host $servernameUpper " account is ready to use." 
            } 
            else 
            { 
                Write-Host 
                Write-Host "!!!WARNING!!!" 
                Write-Host "One of the following groups were *NOT* found in Active Directory" 
                Write-Host "Admin Group         : " $gpoAdminGroupName 
                Write-Host "Admin Template Group: " $admGroupTemplateName 
                Write-Host "RDP Group           : " $gpoRdpGroupName 
                Write-Host "RDP Template Group  : " $rdpGroupTemplateName 
            } 
        } 
        else 
        { 
            Write-Host "GPO export path could not be created!" 
            Write-Host "Please check configuration"  
        }  
    }  
}  
  
Write-Host  