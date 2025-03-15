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
Plug 'wakatime/vim-wakatime'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/everforest'
Plug 'NLKNguyen/papercolor-theme'
Plug 'sainnhe/sonokai'
Plug 'rose-pine/neovim'
Plug 'jacoborus/tender.vim'
Plug 'tanvirtin/monokai.nvim'
Plug 'windwp/nvim-ts-autotag'



Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'   
Plug 'mfussenegger/nvim-dap'                 
Plug 'mfussenegger/nvim-dap-python'         
Plug 'ray-x/go.nvim'                       
Plug 'ray-x/guihua.lua'                   

Plug 'angular/vscode-ng-language-service'
Plug 'hrsh7th/vscode-langservers-extracted'



Plug 'windwp/nvim-ts-autotag'        " Auto-close HTML/XML tags
Plug 'norcalli/nvim-colorizer.lua'  " Color visualization in CSS/HTML
Plug 'mattn/emmet-vim'              " HTML quick expansion


Plug 'NoahTheDuke/vim-just'

call plug#end()
]]

