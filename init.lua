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

require('nvim-autopairs').setup({
    enable_check_bracket_line = true, -- Don't add a pair if it exists in the same line
    check_ts = true, -- Use treesitter to handle advanced pair behavior
    disable_filetype = { "TelescopePrompt" }, -- Disable in specific file types
    map_cr = true, -- Automatically add closing braces after Enter
    map_bs = true, -- Allow <BS> to delete both pair characters
    map_c_h = true, -- Skip over closing braces when typing
})


