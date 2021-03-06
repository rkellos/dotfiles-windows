#--------------------------------------
# This module:
#  'Does-the-wotk' --> copies items, 
#     from executed powershell file-enrated lists within current execution directory
#
#--------------------------------------
Write-Host "bootstrap.ps1 module called..." -ForegroundColor "Red"

$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"

New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue
New-Item $componentDir -ItemType Directory -Force -ErrorAction SilentlyContinue

Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./components/** -Destination $componentDir -Include **
Copy-Item -Path ./home/** -Destination $home -Include **

Remove-Variable componentDir
Remove-Variable profileDir
