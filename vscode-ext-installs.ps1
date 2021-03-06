Write-Host "vscode-ext-installs.ps1 module called..." -ForegroundColor "Red"

$extension = $('')
$('code --install-extension christian-kohler.npm-intellisense')
$('code --install-extension codezombiech.gitignore') 
$('code --install-extension dbaeumer.vscode-eslint') 
$('code --install-extension donjayamanne.git-extension-pack')
$('code --install-extension donjayamanne.githistory')
$('code --install-extension DotJoshJohnson.xml')
$('code --install-extension eg2.vscode-npm-script')
$('code --install-extension felipecaputo.git-project-manager')
$('code --install-extension jchannon.csharpextensions')
$('code --install-extension joelday.docthis')
$('code --install-extension johnpapa.Angular1')
$('code --install-extension michelemelluso.gitignore')
$('code --install-extension mikestead.dotenv')
$('code --install-extension mohsen1.prettify-json')
$('code --install-extension ms-python.python')
$('code --install-extension ms-vscode.csharp')
$('code --install-extension ms-vscode.PowerShell')
$('code --install-extension msjsdiag.debugger-for-chrome')
$('code --install-extension nobuhito.printcode')
$('code --install-extension pflannery.vscode-versionlens')
$('code --install-extension rebornix.project-snippets')
$('code --install-extension robertohuertasm.vscode-icons')
$('code --install-extension searKing.preview-vscode')
$('code --install-extension SonarSource.sonarlint-vscode')
$('code --install-extension waderyan.gitblame')
$('code --install-extension yycalm.linecount')
$('code --install-extension ziyasal.vscode-open-in-github')
cmd.exe /c $extension > $result
Write-Host $result