# install-essentials.ps1
Write-Log "Installing Essential Apps..."

# Adobe Acrobat Reader (via Chocolatey)
choco install adobereader -y

# Google Chrome
choco install googlechrome -y

# Python & JavaScript Runtime
choco install python nodejs-lts -y

# Microsoft Edge
choco install microsoft-edge -y 

# VLC Media Player
choco install vlc -y    

# WinRAR
choco install winrar -y

