# ImportTrimarcGPOs.ps1
#
# This script is intended to be used to quickly import all Trimarc GPOs.
#
# GPOs must first be downloaded from https://github.com/techBrandon/Trimarc-GPO-Templates
#
# Script prompts the user to select a folder containing the downloaded GPOs
#
# GPOs are imported into local domain
#
# Requires being run as Administrator using a privileged account on a DC or computer with RSOP installed
#
Import-Module ActiveDirectory            
Import-Module GroupPolicy  
$app = New-Object -com Shell.Application
$targetFolder = $app.BrowseForFolder(0, "Select Folder", 0, "C:\")
$GPOFolderPath = $targetFolder.Self.Path
$GPOList = Get-ChildItem $GPOFolderPath
foreach ($GPO in $GPOList) {
    $XMLgpreport = $GPO.FullName + "\gpreport.xml"
    if(Test-Path $XMLgpreport){
        $XMLData = [XML](Get-Content $XMLgpreport)#trycatch
        $GPOName = $XMLData.GPO.Name
        Import-Gpo -BackupId $GPO.Name -TargetName $GPOName -path $GPOFolderPath -CreateIfNeeded
    }
}