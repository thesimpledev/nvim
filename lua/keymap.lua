-- Keybindings for diagnostics
local function goto_next_with_action() vim.diagnostic.goto_next()
    vim.lsp.buf.code_action()
end

local function goto_prev_with_action()
    vim.diagnostic.goto_prev()
    vim.lsp.buf.code_action()
end

vim.g.mapleader = " " -- Set the global leader key to <Space>
vim.keymap.set('i', '<Space>', '<Space>', { noremap = true, silent = true })

-- Lead Key Maps
vim.keymap.set('n', '<Leader>v', ':Vex<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>e', ':Ex<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ds', ':Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ws', ':Telescope lsp_workspace_symbols<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "Show diagnostic in a floating window" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Show diagnostics in location list" })
vim.keymap.set('n', '<Leader>p', '"+p', { noremap = true, silent = true }) --Paste from system clipboard
vim.keymap.set('n', '<Leader>y', '"+y', { noremap = true, silent = true }) -- copy to system clipboard normal mode
vim.keymap.set('v', '<Leader>y', '"+y', { noremap = true, silent = true }) -- copy to system clipboard visual mode
vim.keymap.set('n', '<Leader>Y', 'gg"+yG', { noremap = true, silent = true }) --Copy entire file to system clipboard
vim.keymap.set('n', '<Leader>b', '<C-^>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>f', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>r', vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>R', vim.lsp.buf.rename, { noremap = true, silent = true })

--LSP Shortcuts
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { noremap = true, silent = true })
-- Telescope setup
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>', { noremap = true, silent = true }) -- Search text in files
vim.keymap.set('n', '<C-b>', ':Telescope buffers<CR>', { noremap = true, silent = true }) -- List open buffers
vim.keymap.set('n', ']e', goto_next_with_action, { desc = "Go to next diagnostic and suggest fix" })
vim.keymap.set('n', '[e', goto_prev_with_action, { desc = "Go to previous diagnostic and suggest fix" })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- Move selected block down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- Move selected block up

vim.keymap.set('n', '<Leader>h', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>l', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>k', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>j', '<C-w>j', { noremap = true, silent = true })


vim.keymap.set('n', '<Leader>w', function()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(win).relative ~= '' then
			vim.api.nvim_win_close(win, false)
		end
	end
end, { noremap = true, silent = true, desc = "Close floating windows" })

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

-- This is required to restore paste to telescope with unnamedplus enabled for the clipboard
vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopePrompt",
    callback = function()
        vim.keymap.set('i', '<C-p>', '<C-r>"', { noremap = true, buffer = true, desc = "Paste yanked word in Telescope prompt" })
    end,
})
