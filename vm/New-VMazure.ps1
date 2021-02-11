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

# ideally, you should push the password to a keyvault
Write-Output "Password: $password"

$parameters.parameters.adminPassword.value = $password
$parameters.parameters.virtualMachineRG.value = $rg

$myip = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
$parameters.parameters.networkSecurityGroupRules.value[0].properties.sourceAddressPrefix = $myip


# if there is no such attribute as adminPassword
#$pass = @{value = $password}   
#$parameters.parameters  | Add-Member -MemberType NoteProperty -Name 'adminPassword' -Value $pass   

$parameters | ConvertTo-Json -Depth 5 | Out-File -FilePath $param 



New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName $rg `
    -TemplateParameterFile $param `
    -TemplateFile $tmplt 

#/Invoke-AzRC-UserChromeO365.ps1 -rgname $rg -vmname $parameters.parameters.virtualMachineName.value

# Create RDP file
$RDPtext = "full address:s:" + `
  (Get-AzPublicIpAddress -Name $parameters.parameters.publicIpAddressName.value).IpAddress + `
  ":3389`n"
$RDPpass = ($password | ConvertTo-SecureString -AsPlainText -Force) | ConvertFrom-SecureString
$RDPtext += "username:s:" + $parameters.parameters.adminUsername.value + "`n"
$RDPtext += "password:s:" + $password + "`n"
$RDPtext += "password 51:b:" + $RDPpass + "`n"

$RDPtext | Out-File -FilePath "../../access.rdp"


#change password back to TBC
$parameters.parameters.adminPassword.value = "TBC"
$parameters.parameters.virtualMachineRG.value = "TBC"
$parameters.parameters.networkSecurityGroupRules.value[0].properties.sourceAddressPrefix = "TBC"

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