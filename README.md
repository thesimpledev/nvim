# Neovim Setup

Download the latest Neovim release from the official Neovim GitHub page. Do not use apt because that version is outdated.

Open Neovim and run:

:PlugInstall

Restart Neovim. Mason will automatically install all configured language servers on first launch based on your mason-setup.lua.

## Userful health commands
:LspInfo
:checkhealth lsp
:checkhealth mason

