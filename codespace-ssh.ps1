<#
.SYNOPSIS
    Interactive codespace SSH launcher with tab-title integration for Windows Terminal.
#>

$ErrorActionPreference = 'Stop'

# Fetch codespaces
Write-Host ""
Write-Host "  Loading codespaces..." -ForegroundColor DarkGray -NoNewline
$json = gh codespace list --json name,displayName,repository,state 2>&1
Write-Host "`r                        " -NoNewline
Write-Host "`r" -NoNewline
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to list codespaces. Make sure you're logged in with 'gh auth login'." -ForegroundColor Red
    Write-Host $json
    Read-Host "Press Enter to exit"
    exit 1
}

$codespaces = $json | ConvertFrom-Json
if ($codespaces.Count -eq 0) {
    Write-Host "No codespaces found." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 0
}

# Display menu with arrow-key selection
Write-Host ""
Write-Host "  Available Codespaces" -ForegroundColor Cyan
Write-Host "  --------------------" -ForegroundColor DarkGray

$selected = 0

function Draw-Menu {
    param([int]$sel)
    for ($i = 0; $i -lt $codespaces.Count; $i++) {
        $cs = $codespaces[$i]
        $stateColor = if ($cs.state -eq 'Available') { 'Green' } elseif ($cs.state -eq 'Shutdown') { 'DarkGray' } else { 'Yellow' }
        if ($i -eq $sel) {
            Write-Host "  > " -NoNewline -ForegroundColor Cyan
            Write-Host "$($cs.displayName)" -NoNewline -ForegroundColor Green
        } else {
            Write-Host "    " -NoNewline
            Write-Host "$($cs.displayName)" -NoNewline -ForegroundColor White
        }
        Write-Host " - $($cs.repository)" -NoNewline -ForegroundColor DarkCyan
        Write-Host " [$($cs.state)]" -ForegroundColor $stateColor
    }
    Write-Host ""
    Write-Host "  Use " -NoNewline -ForegroundColor DarkGray
    Write-Host "[^] [v]" -NoNewline -ForegroundColor White
    Write-Host " to navigate, " -NoNewline -ForegroundColor DarkGray
    Write-Host "[Enter]" -NoNewline -ForegroundColor White
    Write-Host " to connect, " -NoNewline -ForegroundColor DarkGray
    Write-Host "[Esc]" -NoNewline -ForegroundColor White
    Write-Host " to exit" -ForegroundColor DarkGray
}

# Initial draw
Draw-Menu -sel $selected

# Read arrow keys until Enter
$menuLines = $codespaces.Count + 2  # items + blank line + hint line
while ($true) {
    $key = [Console]::ReadKey($true)
    if ($key.Key -eq 'UpArrow') {
        $selected = if ($selected -gt 0) { $selected - 1 } else { $codespaces.Count - 1 }
    } elseif ($key.Key -eq 'DownArrow') {
        $selected = if ($selected -lt $codespaces.Count - 1) { $selected + 1 } else { 0 }
    } elseif ($key.Key -eq 'Enter') {
        break
    } elseif ($key.Key -eq 'Escape') {
        exit 0
    }
    # Move cursor up to redraw menu
    [Console]::Write("`e[${menuLines}A")
    Draw-Menu -sel $selected
}

$chosen = $codespaces[$selected]

# Set tab title to display name
$title = $chosen.displayName
$Host.UI.RawUI.WindowTitle = $title
# Also send OSC escape sequence for Windows Terminal
[Console]::Write("`e]0;$title`a")

Clear-Host

# Connect via SSH
gh codespace ssh -c $chosen.name
