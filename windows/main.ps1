###
# Entry-point for Powershell. Relies on Choco, obviously. Make sure it's idempotent.
# 1) Can't replace with Python, because it's not installed. Oof.
# 2) Some of these (e.g. Steam) don't show up in "choco list" so we can't check for installation before (re)installing.
###

#Requires -RunAsAdministrator

# From Chocolatey.org/install
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

foreach ($package in @('vivaldi', 'notepadplusplus', 'git', 'vscode', 'python', 'steam-client', 'epicgameslauncher')) {
    choco install $package -y
    refreshenv
}
