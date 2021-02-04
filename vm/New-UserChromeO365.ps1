
param (
    $rgname = "csm-test-rg",
    $vmname = "csmVM01"
)

Write-Host "RG: $rgname, VM: $vmname"


Invoke-AzVMRunCommand -ResourceGroupName $rgname `
    -VMName $vmname `
    -CommandId 'RunPowerShellScript' `
    -ScriptPath 'runCommand_v2.ps1' `
    -Parameter @{pass = "lkjh204895njs!"}


