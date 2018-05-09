# These components will be loaded for all PowerShell instances

# this function loops through files generated from all powershell [RE --> 'other' additional dev applications]
#  files executed within [install]/components directory
Push-Location (Join-Path (Split-Path -parent $profile) "components")

# From within the ./components directory...
#. .\coreaudio.ps1
. .\git.ps1

Pop-Location
