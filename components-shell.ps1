# These components will be loaded when running Microsoft.Powershell (i.e. Not Visual Studio)

Push-Location (Join-Path (Split-Path -parent $profile) "components")

# this function loops through files generated from all powershell [RE --> shell components]
#  files executed within [install]/components directory
# From within the ./components directory...
. .\visualstudio.ps1
. .\console.ps1

Pop-Location
