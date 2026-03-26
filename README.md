# gh-codespace-windows-terminal

A [GitHub CLI extension](https://docs.github.com/en/github-cli/github-cli/using-github-cli-extensions) that adds a **Codespace SSH** profile to [Windows Terminal](https://github.com/microsoft/terminal) (Windows) or [iTerm2](https://iterm2.com/) (macOS).

When you open the profile, it shows an interactive menu of your codespaces and connects via SSH — with the tab automatically renamed to the codespace's display name.

The extension automatically detects the operating system and installs the appropriate profile.

## Install

```
gh extension install <owner>/gh-codespace-windows-terminal
gh codespace-windows-terminal install
```

- **Windows**: restart Windows Terminal — you'll see **Codespace SSH** in the new tab dropdown.
- **macOS**: restart iTerm2 — you'll see **Codespace SSH** in the profiles list.

## Uninstall

```
gh codespace-windows-terminal uninstall
gh extension remove codespace-windows-terminal
```

## Features

- Interactive arrow-key menu to pick a codespace
- Shows display name, repository, and state (Available/Shutdown)
- Sets the tab title to the codespace display name
- Clears the screen before connecting
- Works with all codespace states — `gh` handles starting shutdown codespaces
- **Windows**: installs as a [Windows Terminal fragment extension](https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions) — no manual settings.json editing
- **macOS**: installs as an [iTerm2 Dynamic Profile](https://iterm2.com/documentation-dynamic-profiles.html) — no manual profile editing

## Prerequisites

### Windows
- [GitHub CLI](https://cli.github.com/) (`gh`) — authenticated with `gh auth login`
- [PowerShell 7+](https://github.com/PowerShell/PowerShell) (`pwsh`)
- [Windows Terminal](https://github.com/microsoft/terminal)

### macOS
- [GitHub CLI](https://cli.github.com/) (`gh`) — authenticated with `gh auth login`
- [iTerm2](https://iterm2.com/)
- `python3` (required; check with `python3 --version` and install via Homebrew or Xcode Command Line Tools if missing)
- [`fzf`](https://github.com/junegunn/fzf) (optional, recommended — `brew install fzf`) — provides an arrow-key searchable picker; falls back to a numbered menu without it

## How it works

### Windows

The extension installs two files as a Windows Terminal fragment at:

```
%LOCALAPPDATA%\Microsoft\Windows Terminal\Fragments\gh-codespace-windows-terminal\
├── fragment.json        # Registers the profile with Windows Terminal
└── codespace-ssh.ps1    # Interactive launcher script
```

The fragment uses a [deterministic v5 UUID](https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions#generating-a-new-profile-guid) (`{3a1967af-b849-5bb3-b630-e693b72a951a}`) derived from the WT fragment namespace, ensuring a stable profile GUID across installations.

### macOS

The extension installs two files:

```
~/Library/Application Support/iTerm2/DynamicProfiles/gh-codespaces.json  # Registers the profile with iTerm2
~/.local/bin/codespace-ssh                                                 # Interactive launcher script
```

The launcher script lists your codespaces via `gh codespace list`, lets you pick one interactively (using `fzf` if available, otherwise a numbered menu), sets the iTerm2 tab and window title to the codespace display name using OSC escape sequences, then connects via `gh codespace ssh`.
