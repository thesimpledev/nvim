-- Set relative line numbers
vim.opt.relativenumber = true

-- Also show the absolute number on the current line
vim.opt.number = true

-- Enable system clipboard access
vim.opt.clipboard = 'unnamedplus'

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = false 

vim.opt.cursorline = true

--Configuring line wraps
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.softtabstop = 4
vim.opt.tabstop = 4     
vim.opt.shiftwidth = 4 
vim.opt.smartindent = true

vim.opt.list = true -- Enable the display of whitespace characters
vim.opt.scrolloff=8
vim.opt.listchars = {
    tab = "▸ ",        -- Display tabs with an arrow and a space
    trail = "•",       -- Display trailing spaces as a bullet
    extends = "❯",     -- Display lines that extend beyond the window
    precedes = "❮",    -- Display lines that wrap to the previous screen
}

vim.o.updatetime = 200

require('plugins')
require('lsp')
require('completion')
require('setup')
require('additional')
require('keymap')
