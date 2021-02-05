
param (
    $rgname = "csm-test-rg",
    $vmname = "csmVM01"
)

Write-Host "RG: $rgname, VM: $vmname"
$password = ("!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".tochararray() | sort --random-sort )[0..15] -join ''
$username = "csmUser01"

Write-Output "New user: $username"
Write-Output "Password: $password"


Invoke-AzVMRunCommand -ResourceGroupName $rgname `
    -VMName $vmname `
    -CommandId 'RunPowerShellScript' `
    -ScriptPath 'New-UserChromeO365-local.ps1' `
    -Parameter @{pass = $password; username = $username}


