# These components will be loaded for all PowerShell instances
Write-Host "components.ps1 module called..." -ForegroundColor "Red"

# this function loops through files generated from all powershell [RE --> 'other' additional dev applications]
#  files executed within [install]/components directory
Push-Location (Join-Path (Split-Path -parent $profile) "components")

# From within the ./components directory...

# . .\git.ps1
../vscode-ext-install.ps1
../Microsoft.PowerShell_profile.ps1

Pop-Location
