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

# --- ⚙️ SCRIPT CONFIGURATION ---
$ErrorActionPreference = "Stop" # Stop on any error, allows catch blocks to handle them

# --- 📊 STATE TRACKING ---
$SucceededInstalls = [System.Collections.ArrayList]@()
$FailedInstalls = [System.Collections.ArrayList]@()

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

function Write-ErrorLog {
    param (
        [string]$component,
        [System.Management.Automation.ErrorRecord]$errorRecord
    )
    Write-Log "ERROR in ${component}: $($errorRecord.Exception.Message)"
    Write-Log "  - At: $($errorRecord.InvocationInfo.ScriptName), Line: $($errorRecord.InvocationInfo.ScriptLineNumber)"
    Write-Log "  - Full Error: $errorRecord"
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

function Install-ChocoPackage {
    param (
        [string[]]$packageNames
    )
    foreach ($pkg in $packageNames) {
        try {
            Show-Message "Installing $pkg..." -color "Yellow"
            # Use --fail-on-unfound to ensure choco exits with an error code if package is not found
            choco install $pkg -y --fail-on-unfound

            if ($LASTEXITCODE -eq 0) {
                Show-Message "Successfully installed $pkg ✅" -color "Green"
                Write-Log "Successfully installed $pkg."
                [void]$SucceededInstalls.Add($pkg)
            } else {
                # This block will catch non-zero exit codes from choco
                throw "Chocolatey exited with code $LASTEXITCODE. Package '$pkg' may not have been installed correctly."
            }
        } catch {
            Write-ErrorLog -component "Install-ChocoPackage" -errorRecord $_
            Show-Message "Failed to install $pkg. Check logs for details. ❌" -color "Red"
            [void]$FailedInstalls.Add($pkg)
        }
    }
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
        Write-ErrorLog -component "Chocolatey Installation" -errorRecord $_
        Show-Message "Error installing Chocolatey. Check logs for details. ❌" -color "Red"
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
            Write-ErrorLog -component "$mod.ps1" -errorRecord $_
            Show-Message "Error in $mod.ps1. Check logs for details. ❌" -color "Red"
        }
    } else {
        Write-Log "Module not found: $mod.ps1"
        Show-Message "Module not found: $mod.ps1 ⚠️" -color "DarkYellow"
    }
}

# --- 📊 FINAL SUMMARY ---
function Show-Summary {
    Show-Message "--- Installation Summary ---" -color "Magenta"
    if ($SucceededInstalls.Count -gt 0) {
        Show-Message "✅ Successfully Installed:" -color "Green"
        $SucceededInstalls | ForEach-Object { Write-Host " - $_" }
    }
    if ($FailedInstalls.Count -gt 0) {
        Show-Message "❌ Failed to Install:" -color "Red"
        $FailedInstalls | ForEach-Object { Write-Host " - $_" }
        Show-Message "Please check the log file for details: $logPath" -color "Yellow"
    }
    if ($SucceededInstalls.Count -eq 0 -and $FailedInstalls.Count -eq 0) {
        Show-Message "No new packages were installed." -color "Cyan"
    }
}

Show-Summary

# --- ✅ FINALIZATION ---
Write-Log "System setup complete."
Show-Message "🚀 Setup process complete!" -color "Magenta"

if ($FailedInstalls.Count -gt 0) {
    exit 1
}
