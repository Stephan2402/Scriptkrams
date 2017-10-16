<# 
    .SYNOPSIS 
    This small script create GPOs from csv with permissions.
    Also you can migrate GPOs Cross-Forest/Domain.
	
    Stephan Verstegen 
	
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
	
    Version 1.0, 2017-09-19
	
    Please send ideas, comments and suggestions to support@verstegen-online.de
	
    .LINK 
    
    .LINK
    
    .DESCRIPTION 
    This small script create GPOs from csv with permissions. Also you can migrate GPOs Cross-Forest/Domain.
    Please read all first.
    
    .NOTES 
    Requirements 
    - GlobalFuntions Modul https://www.powershellgallery.com/packages/GlobalFunctions/2.0
    - Active Directory PowerShell Modul
    - GPMC PowerShell Modul
    - Trust between the Forest/Domains
    - Permission to all GPOs then will be in touch.
    - CSV list of GPOs
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial release
    
	
    .PARAMETER

    GpoRead, GpoApply, GpoEdit, GpoEditDeleteModifySecurity or None.

	
    .EXAMPLE


#>
[CmdletBinding()]
Param(
  [string]$Mode = 'create',
  [string]$CSVPath = 'C:\GPOs\gpolist.csv',
  [string]$PermissionGroup = 'Domain-Admins',
  [string]$PermissionLevel = 'GpoEditDeleteModifySecurity',
  [string]$PermissionType = 'Group',
  [string]$TargetDomain = 'contoso.com',
  [string]$TargetDomainController = 'DC0001.contoso.com',
  [string]$SourceDomain = 'fabrikam.com',
  [string]$SourceDomainController = 'DC0001.fabrikam.com'
)

# Import required modules
Import-Module -Name ActiveDirectory
Import-Module -Name GroupPolicy
Import-Module -Name GlobalFunctions

# Define some general script parameters
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

# Let's measure the time 
$stopWatch = [diagnostics.stopwatch]::startNew() 

# Create logger
$logger = New-Logger -ScriptRoot $ScriptDir -ScriptName $ScriptName -LogFileRetention 14
$logger.Write('Script started ####################################################')


funtion test-all {
                        # Test Domain

                        # Test Domain Controller

                        # Test CSV Path
                        
                    
}

function create-gpo {
                        # Get GPO List to work with and AD permission group(s)
                        $GPOlist = Get-Content $CSVPath

                        #Error action to silent
                        $ErrorActionPreference = "SilentlyContinue"

                        #Loop to create GPOs
                        foreach ($gpo in $GPOlist)
                        {
                          $error.PSBase.Clear()
                          $targetGPO = Get-GPO -Name $gpo
                          If ($error.Count -eq 0)
                          {
                            $logger.write(('The {0} GPO already exist in destination active directory' -f $gpo))
                          }
                          ElseIf ($error.Count -ne 0)
                          {
                            $error = null
                            $gpoName = $gpo
                            $CreateGPO = New-GPO -name $gpoName -Domain $TargetDomain -Server $TargetDomainController
                            $SetPerm1 = Set-GPPermissions -Name $gpoName -PermissionLevel $PermissionLevel -TargetName $PermissionGroup -TargetType $PermissionType
                            If ($error.Count -eq 0)
                            {
                                $logger.write(('GPO created: {0} | Permission added: {1} | Permission Level: {2} ' -f $gpoName, $PermissionGroup, $PermissionLevel))
                            }
                            ElseIf ($error.Count -ne 0)   
                            {
                                $logger.write(('Error: {0}' -f $error))
                            }
                          }
                        }
                   }

function migrate-gpo {

}
function create-migration-csv {

# Delete FQDN and get RDN


Add-Content -Path $CSVPath -Value '"Source","Destination","Type"'

$entries = @( 

'"$SourceDomain"', '"$TargetDomain"', '"Domain"'
'"$SourceDomain"', '"$TargetDomain"', '"Domain"'
'"$SourceDomain"', '"$TargetDomain"', '"Domain"'
'"$SourceDomain"', '"$TargetDomain"', '"Domain"'
)



}
## MAIN ####################################################################################################



if($Mode = "create"){
    if(Test-Path -Path $CSVPath){
        create-gpo
    }
    else {
        $logger.write(('CSV file doesent exist: {0}' -f $CSVPath))
        }
}

if($Mode = "migrate"){

}


# We are finsihed
$stopWatch.Stop()
$elapsedTime = ('{0:00}:{1:00}:{2:00}' -f $stopWatch.Elapsed.Hours,$stopWatch.Elapsed.Minutes,$stopWatch.Elapsed.Seconds)
$logger.Write('Script runtime: {0}' -f $script:elapsedTime)
$logger.Write('Script finished #############################')