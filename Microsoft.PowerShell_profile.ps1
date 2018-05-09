# Profile for the Microsoft.Powershell Shell, only. (Not Visual Studio or other PoSh instances)
# ===========
Write-Host "Microsoft.PoweShell_profile.ps1 module called..." -ForegroundColor "Red"

Push-Location (Split-Path -parent $profile)
"components-shell" | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
Pop-Location
