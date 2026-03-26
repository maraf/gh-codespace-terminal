<#
.SYNOPSIS
    gh CLI extension: Installs/uninstalls a Windows Terminal profile for GitHub Codespace SSH.
.DESCRIPTION
    This is the entry point for the gh CLI extension. It copies a Windows Terminal
    fragment and launcher script to the appropriate location so that a "Codespace SSH"
    profile appears automatically in Windows Terminal.
.EXAMPLE
    gh codespace-terminal install
    gh codespace-terminal uninstall
    gh codespace-terminal status
#>

param(
    [Parameter(Position = 0)]
    [ValidateSet('install', 'uninstall', 'status', 'help', '')]
    [string]$Command = 'help'
)

$ErrorActionPreference = 'Stop'

$fragmentDir = Join-Path $env:LOCALAPPDATA "Microsoft\Windows Terminal\Fragments\gh-codespace-terminal"
$extensionDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Install-Fragment {
    if (-not (Test-Path $fragmentDir)) {
        New-Item -ItemType Directory -Path $fragmentDir -Force | Out-Null
    }

    Copy-Item (Join-Path $extensionDir "fragment.json") -Destination $fragmentDir -Force
    Copy-Item (Join-Path $extensionDir "codespace-ssh.ps1") -Destination $fragmentDir -Force

    Write-Host "Installed Windows Terminal fragment to:" -ForegroundColor Green
    Write-Host "  $fragmentDir" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Restart Windows Terminal to see the 'Codespace SSH' profile." -ForegroundColor Yellow
}

function Uninstall-Fragment {
    if (Test-Path $fragmentDir) {
        Remove-Item $fragmentDir -Recurse -Force
        Write-Host "Removed Windows Terminal fragment from:" -ForegroundColor Green
        Write-Host "  $fragmentDir" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Restart Windows Terminal to remove the 'Codespace SSH' profile." -ForegroundColor Yellow
    } else {
        Write-Host "Fragment is not installed." -ForegroundColor Yellow
    }
}

function Show-Status {
    if (Test-Path $fragmentDir) {
        Write-Host "Installed" -ForegroundColor Green -NoNewline
        Write-Host " at $fragmentDir"
        Write-Host ""
        Write-Host "Files:"
        Get-ChildItem $fragmentDir | ForEach-Object {
            Write-Host "  $($_.Name)" -ForegroundColor Cyan
        }
    } else {
        Write-Host "Not installed" -ForegroundColor Yellow
    }
}

function Show-Help {
    Write-Host "gh codespace-terminal" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Adds a 'Codespace SSH' profile to Windows Terminal that lets you"
    Write-Host "interactively pick a codespace and SSH into it."
    Write-Host ""
    Write-Host "USAGE" -ForegroundColor Yellow
    Write-Host "  gh codespace-terminal <command>"
    Write-Host ""
    Write-Host "COMMANDS" -ForegroundColor Yellow
    Write-Host "  install     Install the Windows Terminal fragment"
    Write-Host "  uninstall   Remove the Windows Terminal fragment"
    Write-Host "  status      Check installation status"
    Write-Host "  help        Show this help message"
}

switch ($Command) {
    'install'   { Install-Fragment }
    'uninstall' { Uninstall-Fragment }
    'status'    { Show-Status }
    default     { Show-Help }
}
