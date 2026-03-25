# gh-codespace-windows-terminal

A [GitHub CLI extension](https://docs.github.com/en/github-cli/github-cli/using-github-cli-extensions) that adds a **Codespace SSH** profile to [Windows Terminal](https://github.com/microsoft/terminal).

When you open the profile, it shows an interactive menu of your codespaces and connects via SSH — with the tab automatically renamed to the codespace's display name.

## Install

```
gh extension install <owner>/gh-codespace-windows-terminal
gh codespace-windows-terminal install
```

Then restart Windows Terminal. You'll see **Codespace SSH** in the new tab dropdown.

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
- Installs as a [Windows Terminal fragment extension](https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions) — no manual settings.json editing

## Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`) — authenticated with `gh auth login`
- [PowerShell 7+](https://github.com/PowerShell/PowerShell) (`pwsh`)
- [Windows Terminal](https://github.com/microsoft/terminal)

## How it works

The extension installs two files as a Windows Terminal fragment at:

```
%LOCALAPPDATA%\Microsoft\Windows Terminal\Fragments\gh-codespace-windows-terminal\
├── fragment.json        # Registers the profile with Windows Terminal
└── codespace-ssh.ps1    # Interactive launcher script
```

The fragment uses a [deterministic v5 UUID](https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions#generating-a-new-profile-guid) (`{3a1967af-b849-5bb3-b630-e693b72a951a}`) derived from the WT fragment namespace, ensuring a stable profile GUID across installations.
