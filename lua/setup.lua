local npairs = require('nvim-autopairs')

npairs.setup({
    enable_check_bracket_line = true, -- Don't add a pair if it exists in the same line
    check_ts = true, -- Use treesitter to handle advanced pair behavior
    disable_filetype = { "TelescopePrompt" }, -- Disable in specific file types
    map_cr = true, -- Automatically add closing braces after Enter
    map_bs = true, -- Allow <BS> to delete both pair characters
    map_c_h = true, -- Skip over closing braces when typing
})

require('tabout').setup({
    tabkey = '',            -- Disable default Tab mapping (we handle it in cmp)
    backwards_tabkey = '',  -- Disable default Shift-Tab mapping
    completion = false,     -- We integrate with cmp manually
    tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = '`', close = '`' },
        { open = '(', close = ')' },
        { open = '[', close = ']' },
        { open = '{', close = '}' },
        { open = '<', close = '>' },
    },
    ignore_beginning = true,
    exclude = {},
})

require('mini.surround').setup()

require('flash').setup({
    modes = {
        char = {
            enabled = false,  -- Don't override f/t/F/T
        },
    },
})

require('colorizer').setup()

require('Comment').setup()

require('telescope').setup {
	defaults = {
		vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden', -- Include hidden files for live_grep
        },
        file_ignore_patterns = { "node_modules", "%.git/" }, -- Ignore patterns
        prompt_prefix = "🔍 ", -- Customize the prompt icon
    },
    pickers = {
        find_files = {
            theme = "dropdown", -- Compact UI for file finding
			hidden = true,
        },
    },
}


vim.cmd('colorscheme monokai')


require('nvim-ts-autotag').setup()

vim.opt.foldmethod = "expr"
vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel  = 99  -- open all folds by default

require('fidget').setup({
    notification = {
        window = {
            winblend = 0,  -- Background transparency (0 = opaque)
        },
    },
})

require('claudecode').setup()

require('godotdev').setup({})

require('nvim-treesitter-textobjects').setup({
    select = {
        lookahead = true,
    },
    move = {
        set_jumps = true,
    },
})

local ts_select = function(query)
    return function()
        require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
    end
end
local ts_move = function(fn, query)
    return function()
        require('nvim-treesitter-textobjects.move')[fn](query, 'textobjects')
    end
end

vim.keymap.set({ 'n', 'x', 'o' }, ']f', ts_move('goto_next_start', '@function.outer'),  { desc = 'Next function start' })
vim.keymap.set({ 'n', 'x', 'o' }, '[f', ts_move('goto_previous_start', '@function.outer'), { desc = 'Prev function start' })
vim.keymap.set({ 'n', 'x', 'o' }, ']F', ts_move('goto_next_end', '@function.outer'),    { desc = 'Next function end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[F', ts_move('goto_previous_end', '@function.outer'),   { desc = 'Prev function end' })
vim.keymap.set({ 'n', 'x', 'o' }, ']c', ts_move('goto_next_start', '@class.outer'),     { desc = 'Next class start' })
vim.keymap.set({ 'n', 'x', 'o' }, '[c', ts_move('goto_previous_start', '@class.outer'),    { desc = 'Prev class start' })

vim.keymap.set({ 'x', 'o' }, 'af', ts_select('@function.outer'), { desc = 'Around function' })
vim.keymap.set({ 'x', 'o' }, 'if', ts_select('@function.inner'), { desc = 'Inner function' })
vim.keymap.set({ 'x', 'o' }, 'ac', ts_select('@class.outer'),    { desc = 'Around class' })
vim.keymap.set({ 'x', 'o' }, 'ic', ts_select('@class.inner'),    { desc = 'Inner class' })
