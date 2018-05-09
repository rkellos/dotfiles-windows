Write-Host "Java.ps1 module called..." -ForegroundColor "Red"

# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}

function Get-Java
{
	# url = 'http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171_windows-x64_bin.exe'
	# $filename = $url.Substring($url.LastIndexOf("/") + 1);
	# $client = new-object System.Net.WebClient;
	# $client.Headers.Add("Cookie", "oraclelicense=accept-securebackup-cookie");
	# $client.DownloadFile( $url, $filename );
	# $result = (Start-Process -FilePath $filename -ArgumentList "/quiet /qn /norestart /l* jdk8_install.log" -Wait -Passthru).ExitCode;
	# echo $result;
	# Get-WmiObject -Class Win32_Product -Filter "Name LIKE '%java% Development Kit 8%'";

	# IdentifyingNumber : {64A3A4F4-B792-11D6-A78A-00B0D0170600}
	# Name              : Java SE Development Kit 7 Update 60 (64-bit)
	# Vendor            : Oracle
	# Version           : 1.7.0.600
	# Caption           : Java SE Development Kit 7 Update 60 (64-bit)
	# InvokeWebrequest -C - -LR#OH "Cookie: oraclelicense=accept-securebackup-cookie" -k "#http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171_windows-x64_bin.exe"
	# curl -C - -LR#OH "Cookie: oraclelicense=accept-securebackup-cookie" -k "http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_windows-x64_bin.exe"
		

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$false, Position=0)]
		[string] $DownloadLink = "-C - -LR#OH 'Cookie: oraclelicense=accept-securebackup-cookie' -k '#http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171_windows-x64_bin.exe'",

		[Parameter(Mandatory=$false, Position=1)]
		[ValidateScript({Test-Path $_})]
		[string] $DownloadLocation = "C:\Temp"
	)

	$fileName = $DownloadLink.SubString($DownloadLink.LastIndexOf("/") + 1)

	$target = Join-Path $DownloadLocation $fileName
	
	"Starting download file $DownloadLink" | Write-Verbose
	Invoke-WebRequest -Uri $DownloadLink -OutFile $target
	"Completed download to $target" | Write-Verbose
	$target
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
	$javaPackage = Get-InstalledSoftwares |? {$_.DisplayName.Contains('Java 8 Update 171')}
	return $javaPackage -ne $null
}