# Windows Setup Script for Customer Success Managers

Automated PowerShell installation for productivity, dev tools, and CSM-specific apps. Suitable for new machines without Microsoft Store access.

## 📦 Modules
- Core Apps: WhatsApp, VSCode, Git, GitHub
- Dev Tools: Docker, Postman, 7zip, Notepad++
- Essentials: Chrome, Adobe Reader, Python, Node.js
- Optional: Slack, Fiddler, ShareX, Windows Terminal
- CSM-Specific: Trello, OBS Studio, Teams, Greenshot

## 📝 Logging
- Logs setup actions and errors to `logs/setup-log.txt`
- Rerun or troubleshoot using the log

## 🚀 Usage

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup-productivity.ps1
