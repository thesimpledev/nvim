# Neovim Setup

Download the latest Neovim release from the official Neovim GitHub page. Do not use apt because that version is outdated.

Open Neovim and run:

:PlugInstall

Restart Neovim. Mason will automatically install all configured language servers on first launch based on your mason-setup.lua.

## Language notes

[docs/](docs/) has one file per language covering how it is set up here: which
language server runs, what happens on save, how to build, test and debug, and
what is currently broken or missing on this machine.

## Userful health commands
:LspInfo
:checkhealth lsp
:checkhealth mason

