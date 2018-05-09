# Make vscode the default editor
Set-Environment "EDITOR" "code --nofork"
Set-Environment "GIT_EDITOR" $Env:EDITOR

# Disable the Progress Bar
$ProgressPreference='SilentlyContinue'
