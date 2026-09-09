<#
.SYNOPSIS
    Creates a desktop shortcut that opens the TIREPlus Invoice History app in
    its own browser window (no address bar), ready to pin to the taskbar.

.DESCRIPTION
    The app runs straight from the file system, so it cannot be installed as a
    normal web app. Instead this makes a shortcut that launches Edge or Chrome
    in "app mode" pointed at index.html, using the TIREPlus icon.

    Windows does not allow programs to pin things to the taskbar, so the last
    step is manual: right-click the new shortcut and choose "Pin to taskbar"
    (on Windows 11, first click "Show more options").

.EXAMPLE
    Right-click this file and choose "Run with PowerShell".

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\Add-To-Taskbar.ps1
#>

$ErrorActionPreference = 'Stop'

# The app folder is the parent of the folder holding this script
$appDir  = Split-Path -Parent $PSScriptRoot
$indexes = Join-Path $appDir 'index.html'
$icon    = Join-Path $appDir 'assets\tireplus.ico'

if (-not (Test-Path $indexes)) {
    Write-Host "Could not find index.html next to this script." -ForegroundColor Red
    Write-Host "Keep tools\Add-To-Taskbar.ps1 inside the app folder and try again."
    Read-Host "Press Enter to close"; exit 1
}

# Find a Chromium browser: app mode gives a clean window with no address bar
$candidates = @(
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)
$browser = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) {
    Write-Host "Neither Microsoft Edge nor Google Chrome was found." -ForegroundColor Red
    Write-Host "Install either one, or just double-click index.html to use the app."
    Read-Host "Press Enter to close"; exit 1
}

# file:/// URL with forward slashes and escaped spaces
$url = 'file:///' + ($indexes -replace '\\', '/') -replace ' ', '%20'

$linkPath = Join-Path ([Environment]::GetFolderPath('Desktop')) 'TIREPlus Invoice History.lnk'
$shell    = New-Object -ComObject WScript.Shell
$link     = $shell.CreateShortcut($linkPath)
$link.TargetPath       = $browser
$link.Arguments        = "--app=`"$url`""
$link.WorkingDirectory = $appDir
$link.Description      = 'Browse and print TIREPlus Orleans invoice history'
if (Test-Path $icon) { $link.IconLocation = "$icon,0" }
$link.Save()

Write-Host ""
Write-Host "Shortcut created on your Desktop:" -ForegroundColor Green
Write-Host "  $linkPath"
Write-Host "  opens with: $(Split-Path -Leaf $browser)"
Write-Host ""
Write-Host "To put it on the taskbar:" -ForegroundColor Cyan
Write-Host "  1. Right-click the new Desktop shortcut"
Write-Host "  2. Windows 11: click 'Show more options' first"
Write-Host "  3. Choose 'Pin to taskbar'"
Write-Host ""
Write-Host "(You can also just drag the shortcut onto the taskbar.)"
Read-Host "Press Enter to close"
