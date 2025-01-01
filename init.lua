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

--New Key Mappings
--Set Leader Key
vim.g.mapleader = " " -- Set the global leader key to <Space>
--Disable leader key in insertmode
vim.keymap.set('i', '<Space>', '<Space>', { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>v', ':Vex<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>f', ':Ex<CR>', { noremap = true, silent = true })

-- LSP Keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { noremap = true, silent = true })


-- Telescope setup
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>', { noremap = true, silent = true }) -- Search text in files
vim.keymap.set('n', '<C-b>', ':Telescope buffers<CR>', { noremap = true, silent = true }) -- List open buffers
vim.keymap.set('n', '<Leader>ds', ':Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ws', ':Telescope lsp_workspace_symbols<CR>', { noremap = true, silent = true })

-- Keybindings for diagnostics
local function goto_next_with_action()
    vim.diagnostic.goto_next()
    vim.lsp.buf.code_action()
end

local function goto_prev_with_action()
    vim.diagnostic.goto_prev()
    vim.lsp.buf.code_action()
end
vim.keymap.set('n', ']e', goto_next_with_action, { desc = "Go to next diagnostic and suggest fix" })
vim.keymap.set('n', '[e', goto_prev_with_action, { desc = "Go to previous diagnostic and suggest fix" })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostic in a floating window" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Show diagnostics in location list" })

--Disabled for now I kind of like the letters
--local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "ℹ" }
--for type, icon in pairs(signs) do
--    local hl = "DiagnosticSign" .. type
 --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
--end

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
})

-- Easy Paste and Copy actions

vim.keymap.set('n', '<Leader>p', '"+p', { noremap = true, silent = true }) --Paste from system clipboard
vim.keymap.set('n', '<Leader>y', '"+y', { noremap = true, silent = true }) -- copy to system clipboard
vim.keymap.set('n', '<Leader>Y', 'gg"+yG', { noremap = true, silent = true }) --Copy entire file to system clipboard
