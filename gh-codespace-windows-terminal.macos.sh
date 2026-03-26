#!/usr/bin/env bash
# gh CLI extension installer for macOS iTerm2 support.
set -euo pipefail

EXTENSION_DIR="$(cd "$(dirname "$0")" && pwd)"
DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
LAUNCHER_DIR="$HOME/.local/bin"
PROFILE_FILE="$DYNAMIC_PROFILES_DIR/gh-codespaces.json"
LAUNCHER_FILE="$LAUNCHER_DIR/codespace-ssh"

install_iterm2() {
    mkdir -p "$DYNAMIC_PROFILES_DIR"
    mkdir -p "$LAUNCHER_DIR"

    cp "$EXTENSION_DIR/iterm2/gh-codespaces.json" "$PROFILE_FILE"
    cp "$EXTENSION_DIR/iterm2/codespace-ssh" "$LAUNCHER_FILE"
    chmod +x "$LAUNCHER_FILE"

    echo "Installed iTerm2 Dynamic Profile to:"
    echo "  $PROFILE_FILE"
    echo ""
    echo "Installed launcher script to:"
    echo "  $LAUNCHER_FILE"
    echo ""
    echo "Restart iTerm2 to see the 'Codespace SSH' profile."
    echo ""
    echo "Tip: to run 'codespace-ssh' directly from your shell, ensure $LAUNCHER_DIR is on your PATH."
}

uninstall_iterm2() {
    local removed=0

    if [[ -f "$PROFILE_FILE" ]]; then
        rm -f "$PROFILE_FILE"
        echo "Removed iTerm2 Dynamic Profile:"
        echo "  $PROFILE_FILE"
        removed=1
    fi

    if [[ -f "$LAUNCHER_FILE" ]]; then
        rm -f "$LAUNCHER_FILE"
        echo "Removed launcher script:"
        echo "  $LAUNCHER_FILE"
        removed=1
    fi

    if [[ $removed -eq 0 ]]; then
        echo "Not installed."
    else
        echo ""
        echo "Restart iTerm2 to remove the 'Codespace SSH' profile."
    fi
}

show_status() {
    local profile_ok=0
    local launcher_ok=0

    if [[ -f "$PROFILE_FILE" ]]; then
        echo "Dynamic Profile : installed"
        echo "  $PROFILE_FILE"
        profile_ok=1
    else
        echo "Dynamic Profile : not installed"
    fi

    if [[ -f "$LAUNCHER_FILE" ]]; then
        echo "Launcher script : installed"
        echo "  $LAUNCHER_FILE"
        launcher_ok=1
    else
        echo "Launcher script : not installed"
    fi

    if [[ $profile_ok -eq 1 && $launcher_ok -eq 1 ]]; then
        echo ""
        echo "Status: fully installed"
    elif [[ $profile_ok -eq 0 && $launcher_ok -eq 0 ]]; then
        echo ""
        echo "Status: not installed"
    else
        echo ""
        echo "Status: partially installed"
    fi
}

show_help() {
    echo "gh codespace-windows-terminal (macOS / iTerm2)"
    echo ""
    echo "Adds a 'Codespace SSH' profile to iTerm2 that lets you"
    echo "interactively pick a codespace and SSH into it."
    echo ""
    echo "USAGE"
    echo "  gh codespace-windows-terminal <command>"
    echo ""
    echo "COMMANDS"
    echo "  install     Install the iTerm2 Dynamic Profile and launcher script"
    echo "  uninstall   Remove the iTerm2 Dynamic Profile and launcher script"
    echo "  status      Check installation status"
    echo "  help        Show this help message"
    echo ""
    echo "FILES INSTALLED"
    echo "  $PROFILE_FILE"
    echo "  $LAUNCHER_FILE"
}

command="${1:-help}"
case "$command" in
    install)   install_iterm2 ;;
    uninstall) uninstall_iterm2 ;;
    status)    show_status ;;
    help)      show_help ;;
    *)
        echo "Unknown command: $command" >&2
        echo "" >&2
        show_help >&2
        exit 1
        ;;
esac
