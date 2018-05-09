#--------------------------------------
# This module:
#   Creates a temp directory, locates the local zip-file 'win-dotfiles.zip'
#   Unzips zip-file, containing this project from temp directory 'win-dotfiles' 
#   Pulls the tmp-files and and prepares them for copying into '%SysDir%\dotfiles-windows'
#   then, passes the reference-name of the dotfiles directory onto 'bootstrap.ps1' --> which does the work
#--------------------------------------- 

# $account = "username"
# $repo    = "dotfiles-windows"
# $branch  = "master"

# $sourceFile = "win-dotfiles.zip"
$destFolderName    = "dotfiles-windows"
# $dotfilesTempDir = Join-Path $env:TEMP "\win-dotfiles\"
$dotfilesInstallDir = "c:\dev\" + $destFolderName

# if (![System.IO.Directory]::Exists($dotfilesTempDir)) {[System.IO.Directory]::CreateDirectory($dotfilesTempDir)}
if (![System.IO.Directory]::Exists($dotfilesInstallDir)) {[System.IO.Directory]::CreateDirectory($dotfilesInstallDir)}
Write-Host "Installing to..." $dotfilesInstallDir

# $dotfilesTempDir = Join-Path $env:TEMP "\win-dotfiles"
# Write-Host "Installing temp directory..." $dotfilesTempDir
# if (![System.IO.Directory]::Exists($dotfilesTempDir)) {[System.IO.Directory]::CreateDirectory($dotfilesTempDir)}
# $sourceFile = "./win-dotfiles.zip"
# Write-Host "Installing from zip..." $sourceFile
# $dotfilesInstallDir = Join-Path "c:\dev\" "$destFolderName"
# if (![System.IO.Directory]::Exists($dotfilesInstallDir)) {[System.IO.Directory]::CreateDirectory($dotfilesInstallDir)}
# Write-Host "Installing to..." $dotfilesInstallDir

#### get files from repo
# function Download-File {
#   param (
#     [string]$url,
#     [string]$file
#   )
#   Write-Host "Downloading $url to $file"
#   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#   Invoke-WebRequest -Uri $url -OutFile $file

# }

# function Unzip-File {
#     param (
#         [string]$File,
#         [string]$Destination = (Get-Location).Path
#     )

#     $filePath = Resolve-Path $File
#     Write-Host "Unzip-file :: filePath: " $filePath " passed: " $File
#     $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)
#     Write-Host "Unzip-file :: destinationPath: " $destinationPath " passed: " $Destination

#     If (($PSVersionTable.PSVersion.Major -ge 3) -and
#         (
#             [version](Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -ge [version]"4.5" -or
#             [version](Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -ge [version]"4.5"
#         )) {
#         try {
#             [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
#             Write-Host "Unzip-file :: ExtractToDirectory : filePath param:" $filePath "destinationPath param: " $destinationPath
#             [System.IO.Compression.ZipFile]::ExtractToDirectory($filePath, $destinationPath)
#         } catch {
#             Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
#         }
#     } else {
#         try {
#             $shell = New-Object -ComObject Shell.Application
#             $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
#         } catch {
#             Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
#         }
#     }
# }

# # Download-File "https://github.com/$account/$repo/archive/$branch.zip" $sourceFile

# if ([System.IO.Directory]::Exists($dotfilesInstallDir)) {[System.IO.Directory]::Delete($dotfilesInstallDir, $true)}
# Unzip-File $sourceFile $dotfilesInstallDir

Write-Host "Processing :: dotfilesInstallDir: " $dotfilesInstallDir " ... calling .\bootstap.ps1"
Push-Location $dotfilesInstallDir
& .\bootstrap.ps1
. .\Get-PackageParameters.ps1
. .\Java.ps1
. .\SonarQube.pms1
. .\SetupSonarQube.ps1
. .\deps.ps1
. .\functions.ps1
. .\exports.ps1
. .\aliases.ps1
. .\components.ps1
. .\components-nuget.ps1
Pop-Location

$newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
$newProcess.Arguments = "-nologo";
[System.Diagnostics.Process]::Start($newProcess);
exit

