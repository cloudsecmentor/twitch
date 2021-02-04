$location = "eastus"


$param = "parameters.json"
$tmplt = "template.json"
$rgName = "vm07"
$rg = $rgName + "-rg"

$resourceGroup = New-AzResourceGroup -Name $rg -Location $location

Write-Output "Name of RG is $($resourceGroup.ResourceGroupName)"



New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName $rg `
    -TemplateParameterFile $param `
    -TemplateFile $tmplt 

$parameters = Get-Content $param | ConvertFrom-Json

./New-UserChromeO365.ps1 -rgname $rg -vmname $parameters.parameters.virtualMachineName.value

<#

## to remove just created rg
Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName

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