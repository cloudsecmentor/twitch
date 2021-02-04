$rgname = "sb-qualys-test"
$vmname = "sbQUAWINTST06"

Invoke-AzVMRunCommand -ResourceGroupName $rgname `
    -VMName $vmname `
    -CommandId 'RunPowerShellScript' `
    -ScriptPath 'runCommand_v2.ps1'


