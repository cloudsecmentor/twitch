param (
  $param = "parameters.json",
  $tmplt = "template.json",
  $rgName = "vm07",
  $location = "eastus"
  )

$rg = $rgName + "-rg"

$resourceGroup = New-AzResourceGroup -Name $rg -Location $location

Write-Output "Name of RG is $($resourceGroup.ResourceGroupName)"

$parameters = Get-Content $param | ConvertFrom-Json
$password = ("!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".tochararray() | sort --random-sort )[0..15] -join ''

Write-Output "Password: $password"

$parameters.parameters.adminPassword.value = $password
$parameters.parameters.virtualMachineRG.value = $rg

# if there is no such attribute as adminPassword
#$pass = @{value = $password}   
#$parameters.parameters  | Add-Member -MemberType NoteProperty -Name 'adminPassword' -Value $pass   

$parameters | ConvertTo-Json -Depth 5 | Out-File -FilePath $param 


New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName $rg `
    -TemplateParameterFile $param `
    -TemplateFile $tmplt 

./Invoke-AzRC-UserChromeO365.ps1 -rgname $rg -vmname $parameters.parameters.virtualMachineName.value

#change password back to TBC
$parameters.parameters.adminPassword.value = "TBC"
$parameters | ConvertTo-Json -Depth 5 | Out-File -FilePath $param 



<#

## to remove just created rg
Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName
Remove-AzResourceGroup -Name "vm07-rg"

## KeyVault require some work
$keyVaultName = $rgName + "-kv"
$keyVault = New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rg -Location $location
Write-Output "Name of KV is $($keyVault.VaultName)"



New-AzDeployment -Name ExampleDeployment `
    #-ResourceGroupName $rg `
    -TemplateParameterFile $param `
    -TemplateFile $tmplt 

#New-AzDeployment -Location $location -TemplateParameterFile "parameters.json" -TemplateFile "template.json"

Get-AzResourceGroup |
  Sort Location,ResourceGroupName |
  Format-Table -GroupBy Location ResourceGroupName,ProvisioningState,Tags

#>