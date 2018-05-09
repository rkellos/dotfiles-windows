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
Install-module PowerShellGet -Scope CurrentUser -Force -AllowClobber ## (https://docs.microsoft.com/en-us/powershell/gallery/readme)
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
#install some developer tools
find-package notepadplusplus -verbose -provider ChocolateyGet -AdditionalArguments --exact | install-package -Force
find-package 7Zip -verbose -provider ChocolateyGet -AdditionalArguments --exact | install-package -Force

### Chocolatey - package manager for Windows
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# system and cli
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
    npm update npm -gdl
    npm update -g
    npm dedupe -g
    npm install -g gulp
    npm install -g mocha
    npm install -g node-inspector
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

function Get-InstalledSoftwares
{
	$installedSoftwares = @{}
	$path = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 
    $registry32 = [microsoft.win32.registrykey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry32)
    $registry64 = [microsoft.win32.registrykey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
	$packages = RetrievePackages $path $registry32
	$packages += RetrievePackages $path $registry64

	$packages.Where({$_.DisplayName}) |% { 
		if(-not($installedSoftwares.ContainsKey($_.DisplayName)))
		{
			$installedSoftwares.Add($_.DisplayName, $_) 
		}
	}
    $installedSoftwares.Values
}

function Install-JavaRuntimeEnvironment
{
       [CmdletBinding()]
       param
       (
              [Parameter(Mandatory=$true, Position=0)]
              [ValidateScript({Test-Path $_})]
              [string] $JreInstallerPath
       )

       "Installing java runtime environment" | Write-Verbose

       $arguments = "/s SPONSORS=0 /L $Env:Temp\jre_install.log"

       $proc = Start-Process $JreInstallerPath -ArgumentList $arguments -Wait -NoNewWindow -PassThru
       if($proc.ExitCode -ne 0)
       {
              throw "Unexpected error installing java runtime environment"
       }
       [Environment]::SetEnvironmentVariable('JAVA_HOME', "C:\Program Files\Java\jre1.8.0_171\bin", "Machine")
}

function Test-JavaInstalled
{
       $javaPackage = Get-InstalledSoftwares |? {$_.DisplayName.Contains('Java 8')}
       return $javaPackage -ne $null
}

#Install JRE
if(-not (Test-JavaInstalled))
{
       Install-JavaRuntimeEnvironment "C:\dev\dotfiles-windows\components\jdk-8u171-windows-x64.exe" -Verbose
}

function Get-SonarQube
{
    #    [CmdletBinding()]
    #    param
    #    (
    #           [Parameter(Mandatory=$false, Position=0)]
    #           [string] $DownloadLink = "https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-7.1.zip",

    #           [Parameter(Mandatory=$false, Position=1)]
    #           [ValidateScript({Test-Path $_})]
    #           [string] $DownloadLocation = "C:\dev\dotfiles-windows\components\"
    #    )

    #    $fileName = $DownloadLink.SubString($DownloadLink.LastIndexOf("/") + 1)

    #    $target = Join-Path $DownloadLocation $fileName
      
    #    "Starting download file $DownloadLink" | Write-Verbose
    #    Invoke-WebRequest -Uri $DownloadLink -OutFile $target
    #    "Completed download to $target" | Write-Verbose

    $fileName = "sonarqube-7.1.zip"
    $sourceLocation = "C:\dev\dotfiles-windows\components\"
    $target = Join-Path $sourceLocation $fileName
    
    $target
}

function Expand-SonarQubePackage
{
       [CmdletBinding()]
       param
       (
              [Parameter(Mandatory=$false, Position=0)]
              [ValidateScript({Test-Path $_})]
              [string] $Source = "C:\dev\dotfiles-windows\components\sonarqube-7.1.zip",

              [Parameter(Mandatory=$false, Position=1)]
              [string] $Target = "C:\SonarQube"
       )

       if (![System.IO.Directory]::Exists($Target)) {[System.IO.Directory]::CreateDirectory($Target)}
       if(-not(Test-Path $Target))
       {
              "Creating new folder at location : $Target" | Write-Verbose
              New-Item -ItemType Directory -Path $Target -Force | Out-Null
       }

       Add-Type -AssemblyName "System.IO.Compression.FileSystem" |  Out-Null

       "Extracting the contents of $Source to $Target" | Write-Verbose
       [IO.Compression.ZipFile]::ExtractToDirectory($Source, $Target)
}

$installFolder = "C:\SonarQube"

$source = " C:\dev\dotfiles-windows\components\sonarqube-7.1.zip"
#Download SonarQube server files
if(-not(Test-Path $source))
{
       Get-SonarQube -DownloadLocation (Split-Path -Parent $source) -Verbose:$RunAsVerboseSession
}

#Extract SonarQube files to the installation folder
$sonarQubeFolder = Join-Path $installFolder ([IO.Path]::GetFileNameWithoutExtension((Split-Path -Leaf $source)))
if(-not(Test-Path $sonarQubeFolder))
{
       Expand-SonarQubePackage -Source $source -Target $installFolder -Verbose:$RunAsVerboseSession
}

function Install-SonarQubeService
{
       [CmdletBinding()]
       param
       (
              [Parameter(Mandatory=$false, Position=0)]
              [ValidateScript({Test-Path $_})]
              [string] $SonarSource = "C:\SonarQube\sonarqube-7.1"
       )

       if(-not(Join-Path $SonarSource "bin\windows-x86-64\InstallNTService.bat" | Test-Path))
       {
              throw "Failed to find a sonarqube installation file"
       }

       if(( Get-Service |? {$_.Name -eq "SonarQube" }) -eq $null)
       {
              "Installing SonarQube service" | Write-Verbose
              Start-Process -FilePath (Join-Path $SonarSource "bin\windows-x86-64\InstallNTService.bat") -Wait -NoNewWindow
       }
}

#Install SonarQube Service
Install-SonarQubeService -SonarSource (Join-Path $installFolder sonarqube-7.1) -Verbose

# Before we start the service, we need to update the log on account under which the service is running.

function Get-InstalledSoftwares
{
	$installedSoftwares = @{}
	$path = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 
    $registry32 = [microsoft.win32.registrykey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry32)
    $registry64 = [microsoft.win32.registrykey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
	$packages = RetrievePackages $path $registry32
	$packages += RetrievePackages $path $registry64

	$packages.Where({$_.DisplayName}) |% { 
		if(-not($installedSoftwares.ContainsKey($_.DisplayName)))
		{
			$installedSoftwares.Add($_.DisplayName, $_) 
		}
	}
    $installedSoftwares.Values
}

function Set-ServiceLogonProperties
{
       [CmdletBinding()]
       param
       (
              [Parameter(Mandatory=$false, Position=0)]
              [string] $Name = "SonarQube",

              [Parameter(Mandatory=$false, Position=1)]
              [string] $Username = "$env:USERDOMAIN\$env:USERNAME"
       )

       $credential = Get-Credential -UserName $Username -Message "Provide password"
       $password = $credential.GetNetworkCredential().Password

       $filter = 'Name=' + "'" + $Name + "'" + ''
       $service = Get-WMIObject -namespace "root\cimv2" -class Win32_Service -Filter $filter
       $service.Change($null,$null,$null,$null,$null,$null,$Username,$password)
       $service.StopService()

       while ($service.Started)
       {
              sleep 2
              $service = Get-WMIObject -namespace "root\cimv2" -class Win32_Service -Filter $filter
       }
       $service.StartService()
}
#Setup sonarqube service account credentials
Set-ServiceLogonProperties -Verbose
