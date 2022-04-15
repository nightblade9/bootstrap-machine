###
# Entry-point for Powershell. Relies on Choco, obviously. Make sure it's idempotent.
# Can't replace with Python, because it's not installed. Oof.
###

#Requires -RunAsAdministrator

# From Chocolatey.org/install
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

foreach ($package in @('notepadplusplus', 'git', 'vscode', 'python')) {
    choco install $package -y
}
