vim.cmd [[
call plug#begin('~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'       " Configures LSP servers
Plug 'hrsh7th/nvim-cmp'            " Completion plugin
Plug 'hrsh7th/cmp-nvim-lsp'        " LSP completion source
Plug 'hrsh7th/cmp-buffer'          " Buffer completion source
Plug 'hrsh7th/cmp-path'            " Path completion source
Plug 'hrsh7th/cmp-cmdline'         " Command-line completion
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Better syntax highlighting
Plug 'nvim-lua/plenary.nvim'       " Required by some plugins
Plug 'nvim-telescope/telescope.nvim' " Fuzzy finder
Plug 'windwp/nvim-autopairs'       " Autopairs for brackets and braces

Plug 'arcticicestudio/nord-vim'

call plug#end()
]]

