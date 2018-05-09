# These components will be loaded within a Visual Studio shell (e.g. Package Manager Console)

# this function loops through files generated from all powershell [RE --> nuget components]
#  files executed within [install]/components directory
Push-Location (Join-Path (Split-Path -parent $profile) "components")

# From within the ./components directory...

Pop-Location

