


# define your file URI
$fileUri = 'https://vm07storageaccount.blob.core.windows.net/psextension/Get-ProcerssExplorer.ps1'

$rg = "vm07-rg"
# create vm object
$vm = Get-AzVM -Name "CStest01" -ResourceGroupName $rg

Set-AzVMCustomScriptExtension -ResourceGroupName  $rg `
    -VMName "CStest01" `
    -Location $vm.Location `
    -FileUri $fileUri `
    -Run 'Get-ProcerssExplorer.ps1' `
    -Name "ProcExplorerExt"


<#

# create vm object
$vm = Get-AzureVM -Name "CStest01" -ServiceName <cloudServiceName>

# set extension
Set-AzureVMCustomScriptExtension -VM $vm -FileUri $fileUri -Run 'Create-File.ps1'

# update vm
$vm | Update-AzureVM

#>
