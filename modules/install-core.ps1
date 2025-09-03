# install-core.ps1
Write-Log "Installing Core Productivity Apps..."

# WhatsApp
try {
    Invoke-WebRequest -Uri "https://web.whatsapp.com/desktop/windows/release/x64/WhatsAppSetup.exe" -OutFile "$env:TEMP\WhatsAppSetup.exe"
    Write-Log "WhatsApp installer re-downloaded successfully."
} catch {
    Write-Log "Failed to download WhatsApp installer: $_"
}
if (Test-Path "$env:TEMP\WhatsAppSetup.exe") {
    Start-Process -FilePath "$env:TEMP\WhatsAppSetup.exe" -ArgumentList "/S" -Wait
    Write-Log "WhatsApp installed successfully."
} else {
    Write-Log "WhatsApp installer not found, skipping installation."
}

# VSCode, Git, GitHub Desktop, Node.js
choco install vscode git github-desktop nodejs-lts -y
