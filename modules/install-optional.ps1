# install-optional.ps1
Write-Log "Installing Optional Collaboration and Debugging Tools..."

choco install slack zoom sharex fiddler windows-terminal -y

# Notion (Chocolatey package may be unofficial — fallback to direct installer)
try {
    Install-Or-Upgrade -packageName "notion" -displayName "Notion"
} catch {
    Write-Log "Chocolatey install failed for Notion. Trying direct installer..."
    $notionInstaller = "$env:TEMP\NotionSetup.exe"
    Invoke-WebRequest -Uri "https://www.notion.so/desktop" -OutFile $notionInstaller
    Start-Process $notionInstaller -Wait
    Write-Log "Notion installed via direct download."
    Show-Message "Notion installed via direct download ✅" -color "Green"
}

# Obsidian
try {
    Install-Or-Upgrade -packageName "obsidian" -displayName "Obsidian"
} catch {
    Write-Log "Error installing Obsidian: $_"
    Show-Message "Obsidian installation failed ❌" -color "Red"
}

# Flow Launcher
try {
    Install-Or-Upgrade -packageName "flow-launcher" -displayName "Flow Launcher"
} catch {
    Write-Log "Error installing Flow Launcher: $_"
    Show-Message "Flow Launcher installation failed ❌" -color "Red"
}

Write-Log "Optional tools installed successfully."