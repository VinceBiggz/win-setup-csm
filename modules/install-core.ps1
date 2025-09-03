# install-core.ps1
Write-Log "Installing Core Productivity Apps..."

$corePackages = @(
    "whatsapp", "vscode", "git", "github-desktop", "nodejs-lts"
)

Install-ChocoPackage -packageNames $corePackages
