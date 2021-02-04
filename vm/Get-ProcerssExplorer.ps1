$filename = "ProcessExplorer.zip"
$uri = "https://download.sysinternals.com/files/" + $filename

$path = "C:\procexp"
$path = "."
New-Item -ItemType Directory -Force -Path $path

$output = $path + "\" + $filename

#$output = "."

Invoke-WebRequest -Uri $uri -OutFile $output


Write-Host "Success!"