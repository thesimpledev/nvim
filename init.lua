-- Set relative line numbers
vim.opt.relativenumber = true

-- Also show the absolute number on the current line
vim.opt.number = true

-- Enable system clipboard access
vim.opt.clipboard = 'unnamedplus'

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = false

vim.opt.tabstop = 4     
vim.opt.shiftwidth = 4 

vim.opt.list = true -- Enable the display of whitespace characters
vim.opt.listchars = {
    space = "·",       -- Display spaces as a middle dot
    tab = "▸ ",        -- Display tabs with an arrow and a space
    trail = "•",       -- Display trailing spaces as a bullet
    extends = "❯",     -- Display lines that extend beyond the window
    precedes = "❮",    -- Display lines that wrap to the previous screen
}

-- Load plugins
require('plugins')

-- Load LSP configurations
require('lsp')

-- Load autocompletion setup
require('completion')

