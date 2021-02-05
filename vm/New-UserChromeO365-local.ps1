
param (
  $pass,
  $username = "csmUser01"
)

### new login user
$Password = ConvertTo-SecureString $pass -AsPlainText -force
New-LocalUser $username -Password $Password -FullName $username -Description $username
Add-LocalGroupMember -Group "Administrators" -Member $username

Write-Host "New user created"
Write-Output "User: $username Password: $password"


#### Chrome install
$LocalTempDir = $env:TEMP; 
$ChromeInstaller = "ChromeInstaller.exe"; 
(new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); 
& "$LocalTempDir\$ChromeInstaller" /silent /install; 
$Process2Monitor = "ChromeInstaller"; 
Do {
    $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; 
    If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } 
    else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } 
} Until (!$ProcessesFound)

Write-Host "Chrome installed"



### Office install
$uri = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_13530-20376.exe"
Invoke-WebRequest -Uri $uri -OutFile .\odt.exe
.\odt.exe /passive /quiet /extract:.
Start-Sleep -Seconds 30 ## need to wait until odt unpacks

$config = New-Item .\config.xml -Force
Set-Content $config.Name '
<!-- Office 365 client configuration file sample. To be used for Office 365 ProPlus apps, 
     Office 365 Business apps, Project Pro for Office 365 and Visio Pro for Office 365. 

     For detailed information regarding configuration options visit: http://aka.ms/ODT. 
     To use the configuration file be sure to remove the comments

     The following sample allows you to download and install the 64 bit version of the Office 365 ProPlus apps 
     and Visio Pro for Office 365 directly from the Office CDN using the Monthly Channel
     settings  -->

<Configuration>
  <Add OfficeClientEdition="64" Channel="Monthly">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
'

.\setup.exe /configure .\config.xml

Write-Host "Office installed"

### config.xml
<#
<!-- Office 365 client configuration file sample. To be used for Office 365 ProPlus apps, 
     Office 365 Business apps, Project Pro for Office 365 and Visio Pro for Office 365. 

     For detailed information regarding configuration options visit: http://aka.ms/ODT. 
     To use the configuration file be sure to remove the comments

     The following sample allows you to download and install the 64 bit version of the Office 365 ProPlus apps 
     and Visio Pro for Office 365 directly from the Office CDN using the Monthly Channel
     settings  -->

<Configuration>
  <Add OfficeClientEdition="64" Channel="Monthly">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
#>
