#--------------------------------------
# This module:
#   Installs important developer utilties
#   --> this needs runAsAdmin privleges and attempts to set thhat itself
#       attempts to verify if (at-least) .NET 4.6 has been installed   
#
#     -- various devloper tools are installed (used throughout this install, also) :
#        NuGet
#        PowerShell Modules: 'Posh' and 'PowerShellGet' (https://github.com/OneGet/oneget)
#        chocolatey - package manager for Windows (https://chocolatey.org/)
#        curl
#        custom written functions
#--------------------------------------- 
Write-Host "deps.ps1 module called..." -ForegroundColor "Red"

# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}

#Colors
# Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red,
# Magenta, Yellow, White

### Update Help for Modules
Write-Host "Updating Help..." -ForegroundColor "Yellow"
#Update-Help -Force


### Package Providers
Write-Host "Installing Package Providers..." -ForegroundColor "Green"
# Get-PackageProvider NuGet -Force | Out-Null
# Import-PackageProvider -Name "NuGet" -Force | Out-Null
Get-PackageProvider PowerShellGet -Force | Out-Null 
# Get-PackageProvider Programs -Force | Out-Null 
# Get-PackageProvider Msi -Force | Out-Null 
# Get-PackageProvider Msu -Force | Out-Null 

# Chocolatey Provider may not be ready yet. Otherwise, se normal Chocolatey
Find-PackageProvider ChocolateyGet -verbose 
Install-PackageProvider ChocolateyGet -verbose -Force | Out-Null
Get-PackageProvider ChocolateyGet -Force | Out-Null
Import-PackageProvider ChocolateyGet 


### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." -ForegroundColor "Magenta"
Install-Module Posh-Git -Scope CurrentUser -Force
#Install-Module PSWindowsUpdate -Scope CurrentUser -Force
Install-Module PowerShellGet -Scope CurrentUser -Force -AllowClobber ## (https://docs.microsoft.com/en-us/powershell/gallery/readme)
Install-Module -Name 7Zip4Powershell -Scope CurrentUser -Force # provide powershell zip capability

#usage: install-msiproduct .\example.msi -destination (join-path $env:ProgramFiles Example)
#PS.Core: https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/PowerShell-6.0.2-win-x64.msi
#usage: install-msiproduct ./components/PowerShell-6.0.2-win-x64.msi [optional: -destination (join-path $env:ProgramFiles Example)]
Install-Package msi -provider PowerShellGet -Scope CurrentUser -Force
# Install-msiProduct .\components\PowerShell-6.0.2-win-x64.msi -Scope CurrentUser -Force

#always want Windows PowerShell PSModulePath loaded
# Install-Module WindowsPSModulePath -Scope CurrentUser -Force
# Add-WindowsPSModulePath -Scope CurrentUser -Force

Write-Host "Installing Developer Tools..." -ForegroundColor "Blue"
$Global:CurrentDirectory = Split-Path $Script:MyInvocation.MyCommand.Path
#install some developer tools
###
# ## VSCode, first
# # $ErrorActionPreference = 'Stop'
 
# # $toolsDir = Split-Path $MyInvocation.MyCommand.Definition
 
# $pp = Get-PackageParameters 
# $mergeTasks = "!runCode"
# $mergeTasks += ', ' + '!'*$pp.NoDesktopIcon        + 'desktopicon'
# $mergeTasks += ', ' + '!'*$pp.NoQuicklaunchIcon    + 'quicklaunchicon'
# $mergeTasks += ', ' + '!'*$pp.NoContextMenuFiles   + 'addcontextmenufiles'
# $mergeTasks += ', ' + '!'*$pp.NoContextMenuFolders + 'addcontextmenufolders'
# $mergeTasks += ', ' + '!'*$pp.DontAddToPath        + 'addtopath'
# Write-Host "Merge Tasks: `n$mergeTasks"
 
# Get-Process code -ea 0 | ForEach-Object { $_.CloseMainWindow() | Out-Null }
# Start-Sleep 1
# Get-Process code -ea 0 | Stop-Process  #in case gracefull shutdown did not succeed, try hard kill
 
# $packageArgs = @{
#   packageName    = 'visualstudiocode'
#   fileType       = 'EXE'
#   url            = 'https://az764295.vo.msecnd.net/stable/7c7da59c2333a1306c41e6e7b68d7f0caa7b3d45/VSCodeSetup-ia32-1.23.0.exe'
#   url64bit       = 'https://az764295.vo.msecnd.net/stable/7c7da59c2333a1306c41e6e7b68d7f0caa7b3d45/VSCodeSetup-x64-1.23.0.exe'
 
#   softwareName   = 'Microsoft Visual Studio Code'
 
#   checksum       = 'e169e2d39c0d094417a21d3b159d2bf986e82c9b73abe243ca1e07cf596cfecb'
#   checksumType   = 'sha256'
#   checksum64     = '3313356942dcb24376008eb3fc1d0580c9799f66bcfd3fb8992bc3699f447421'
#   checksumType64 = 'sha256'
 
#   silentArgs     = "/verysilent /suppressmsgboxes /mergetasks=""$mergeTasks"" /log=""$env:temp\vscode.log"""
#   validExitCodes = @(0, 3010, 1641)
# }
 
# Install-ChocolateyPackage @packageArgs

find-package notepadplusplus -verbose -provider ChocolateyGet -AdditionalArguments --exact | install-package -Force
find-package 7Zip -verbose -provider ChocolateyGet -AdditionalArguments --exact | install-package -Force

### Chocolatey - package manager for Windows
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# system and cli -- some choco calls are backup-installs, a second-try
choco install curl                --limit-output
choco install nuget.commandline   --limit-output
choco install webpi               --limit-output
choco install git.install         --limit-output -params '"/GitAndUnixToolsOnPath "'  #/NoShellIntegration
choco install nvm.portable        --limit-output
choco install ruby                --limit-output

# browsers
choco install GoogleChrome        --limit-output

# -- other browsers
# choco install GoogleChrome.Canary --limit-output
# choco install Firefox             --limit-output
# choco install Opera               --limit-output

# dev tools and frameworks
# choco install atom                --limit-output
choco install VisualStudioCode 1.23.0               --limit-output

choco install postman             --limit-output
choco install vim                 --limit-output
choco install winmerge            --limit-output
#choco install ultraedit            --limit-output
choco install notepadplusplus     --limit-output
choco install 7Zip                --limit-output

Refresh-Environment

nvm on
$nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
nvm install $nodeLtsVersion
nvm use $nodeLtsVersion
Remove-Variable nodeLtsVersion

gem pristine --all --env-shebang

### Windows Features
Write-Host "Installing Windows Features..." -ForegroundColor "Yellow"
# IIS Base Configuration
Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "IIS-BasicAuthentication", `
    "IIS-DefaultDocument", `
    "IIS-DirectoryBrowsing", `
    "IIS-HttpCompressionDynamic", `
    "IIS-HttpCompressionStatic", `
    "IIS-HttpErrors", `
    "IIS-HttpLogging", `
    "IIS-ISAPIExtensions", `
    "IIS-ISAPIFilter", `
    "IIS-ManagementConsole", `
    "IIS-RequestFiltering", `
    "IIS-StaticContent", `
    "IIS-WebSockets", `
    "IIS-WindowsAuthentication" `
    -NoRestart | Out-Null

# ASP.NET Base Configuration
Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "NetFx3", `
    "NetFx4-AdvSrvs", `
    "NetFx4Extended-ASPNET45", `
    "IIS-NetFxExtensibility", `
    "IIS-NetFxExtensibility45", `
    "IIS-ASPNET", `
    "IIS-ASPNET45" `
    -NoRestart | Out-Null

# Web Platform Installer for remaining Windows features
webpicmd /Install /AcceptEula /Products:"UrlRewrite2"
webpicmd /Install /AcceptEula /Products:"NETFramework462"
webpicmd /Install /AcceptEula /Products:"NETFramework472"
#webpicmd /Install /AcceptEula /Products:"Python279"

nvm install 10.0
### Node Packages used for installation
Write-Host "Installing Node Packages..." -ForegroundColor "Yellow"
if (which npm) {
    npm i npm -gdl
    npm update -g
    npm dedupe -g
    npm install -g gulp
    npm install -g mocha
    # npm install -g node-inspector
    npm install -g yo
    npm doctor -g
    npm rebuild -g
    npm cache verify -g
}

# ### specific-user customizations for vim
# Write-Host "Installing Janus..." -ForegroundColor "Yellow"
# if ((which curl) -and (which vim) -and (which rake) -and (which bash)) {
#     curl.exe -L https://bit.ly/janus-bootstrap | bash
# }


### Visual Studio Plugins
if (which Install-VSExtension) {
    ### Visual Studio 2017
    # SonarLint
    Install-VSExtension https://sonarsource.gallerycdn.vsassets.io/extensions/sonarsource/sonarlintforvisualstudio2017/4.0.0.3479/1525365347294/SonarLint.VSIX-4.0.0.3479-2017.vsix
    
    # Sonar Metro Tool
    Install-VSExtension https://jorgemanuelestevesdacosta.gallerycdn.vsassets.io/extensions/jorgemanuelestevesdacosta/vssonarextension/6.3.7/1504692950731/100611/72/VSSonarExtensionMetroVs2013.vsix

    #gitignore
    Install-VSExtension https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/ignore/1.2.71/1482143287772/212799/18/ignore%20v1.2.71.vsix
}

# Write-Host "Installing Janus..." -ForegroundColor "Yellow"
Write-Host "ready to attempt java download..." -ForegroundColor "Yellow"
if ((which curl)) {
    curl.exe -C - -LR#OH "Cookie: oraclelicense=accept-securebackup-cookie" -k "#https://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171_windows-x64_bin.exe"
	Write-Host "java download complete..." -ForegroundColor "White"
}

$javaSource = "C:\temp\jdk-8u171_windows-x64_bin.exe"
$javaInstallFolder = "C:\Program Files\Java" #jdk1.8.0_171
if(-not(Test-Path $javaSource))
{
    Get-Java -DownloadLocation (Split-Path -Parent $javaSource) -Verbose:$RunAsVerboseSession
}

#Install Java JDK
Install-JavaRuntimeEnvironment -JreInstallerPath (Join-Path $javaInstallFolder jdk-8u171) -Verbose

$source = " C:\temp\sonarqube-7.1.zip"
$installFolder = "C:\SonarQube"#sonarqube-7.1
#Download SonarQube server files
Write-Host "ready to attempt sonar download..." -ForegroundColor "Yellow"
if(-not(Test-Path $source))
{
    Get-SonarQube -DownloadLocation (Split-Path -Parent $source) -Verbose:$RunAsVerboseSession
	Write-Host "sonar download complete..." -ForegroundColor "White"
}


#Install SonarQube Service
Install-SonarQubeService -SonarSource (Join-Path $installFolder sonarqube-7.1) -Verbose

Write-Host "deps.ps1 complete..." -ForegroundColor "Magenta"
