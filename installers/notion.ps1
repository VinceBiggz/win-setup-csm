function Install-Notion {
    $packageName = "notion"
    $displayName = "Notion"

    $installed = choco list --local-only | Select-String "^$packageName"

    if ($installed) {
        Write-Log "$displayName is already installed. Attempting upgrade..."
        Show-Message "$displayName already installed. Upgrading..." -color "Yellow"
        choco upgrade $packageName -y
    } else {
        try {
            choco install $packageName -y
        } catch {
            Write-Log "Chocolatey install failed for Notion. Trying direct installer..."
            $installerPath = "$env:TEMP\NotionSetup.exe"
            Invoke-WebRequest -Uri "https://www.notion.so/desktop" -OutFile $installerPath
            Start-Process $installerPath -Wait
        }
    }
    Show-Message "$displayName setup complete ✅" -color "Green"
}
