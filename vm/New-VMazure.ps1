$location = "eastus"


$param = "parameters.json"
$tmplt = "template.json"
$rgName = "vm07"
$rg = $rgName + "-rg"

$resourceGroup = New-AzResourceGroup -Name $rg -Location $location

Write-Output "Name of RG is $($resourceGroup.ResourceGroupName)"

$keyVaultName = $rgName + "-kv"
$keyVault = New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rg -Location $location

Write-Output "Name of KV is $($keyVault.VaultName)"


New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName $rg `
    -TemplateParameterFile $param `
    -TemplateFile $tmplt 

<#

## to remove just created rg
Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName


New-AzDeployment -Name ExampleDeployment `
    #-ResourceGroupName $rg `
    -TemplateParameterFile $param `
    -TemplateFile $tmplt 

#New-AzDeployment -Location $location -TemplateParameterFile "parameters.json" -TemplateFile "template.json"

Get-AzResourceGroup |
  Sort Location,ResourceGroupName |
  Format-Table -GroupBy Location ResourceGroupName,ProvisioningState,Tags

#>