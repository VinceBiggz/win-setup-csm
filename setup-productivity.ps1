<#
.SYNOPSIS
Automates installation of core productivity and CSM-specific applications for Windows.

.DESCRIPTION
This script streamlines the setup of essential tools for productivity, development, and customer success workflows.
It installs packages via Chocolatey, sets up symbolic terminal shortcuts, and logs actions with timestamps.

.AUTHOR
Vincent Wachira

.VERSION
1.2.0

.DATE
2025-08-04

.NOTES
- Designed for fresh Windows environments with limited access to the Microsoft Store
- Ensures clean logging and graceful error handling
- Should be run with Administrator privileges
#>

# --- 🗂️ INITIALIZATION ---
$logPath = "$PSScriptRoot\logs\setup-log.txt"
if (!(Test-Path $logPath)) {
    New-Item -ItemType File -Path $logPath -Force | Out-Null
}

function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logPath -Value "$timestamp - $message"
}

function Show-Message {
    param (
        [string]$text,
        [ConsoleColor]$color = "White"
    )
    $origColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $color
    Write-Host $text
    $Host.UI.RawUI.ForegroundColor = $origColor
}

# --- ⚙️ INSTALL CHOCOLATEY ---
if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Show-Message "Installing Chocolatey..." -color "Yellow"
    Write-Log "Installing Chocolatey..."
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Log "Chocolatey installed successfully."
        Show-Message "Chocolatey installed successfully ✅" -color "Green"
    } catch {
        Write-Log "Error installing Chocolatey: $_"
        Show-Message "Error installing Chocolatey ❌" -color "Red"
    }
} else {
    Write-Log "Chocolatey already installed."
    Show-Message "Chocolatey already installed ✅" -color "Green"
}

# --- 📦 MODULE EXECUTION ---
$modules = @(
    "install-core",
    "install-devtools",
    "setup-terminal",
    "install-optional",
    "install-essentials",
    "install-csm-tools"
)

foreach ($mod in $modules) {
    $modPath = "$PSScriptRoot\modules\$mod.ps1"
    if (Test-Path $modPath) {
        Write-Log "Executing $mod.ps1..."
        Show-Message "Executing $mod.ps1 🛠️" -color "Cyan"
        try {
            . $modPath
            Write-Log "$mod.ps1 completed."
            Show-Message "$mod.ps1 completed successfully ✅" -color "Green"
        } catch {
            Write-Log "Error executing $mod.ps1: $_"
            Show-Message "Error in $mod.ps1 ❌" -color "Red"
        }
    } else {
        Write-Log "Module not found: $mod.ps1"
        Show-Message "Module not found: $mod.ps1 ⚠️" -color "DarkYellow"
    }
}

# --- ✅ FINALIZATION ---
Write-Log "System setup complete."
Show-Message "🚀 Setup process complete!" -color "Magenta"
