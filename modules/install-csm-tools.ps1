# install-csm-tools.ps1
Write-Log "Installing Tools Specific to Customer Success Role..."

# Trello for task tracking
choco install trello -y

# OBS Studio for demo recording
choco install obs-studio -y

# Microsoft Teams for collaboration
choco install microsoft-teams -y

# Greenshot for screenshots
choco install greenshot -y

# Grammarly & Krisp (manual installers)
Write-Log "Note: Please manually install Grammarly and Krisp from their websites."
Start-Process "https://www.grammarly.com/native/windows"
Start-Process "https://krisp.ai/download/"
Write-Log "Customer Success tools installed successfully."