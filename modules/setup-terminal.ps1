# setup-terminal.ps1
Write-Log "Setting up Admin Terminal Shortcuts..."

$cmd = "$env:windir\System32\cmd.exe"
$powershell = "$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe"

$desktop = [Environment]::GetFolderPath("Desktop")
New-Item -ItemType SymbolicLink -Path "$desktop\CMD Admin.lnk" -Target $cmd -Force
New-Item -ItemType SymbolicLink -Path "$desktop\PowerShell Admin.lnk" -Target $powershell -Force
Write-Log "Admin Terminal Shortcuts created on Desktop."