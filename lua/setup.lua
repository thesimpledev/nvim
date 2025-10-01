local npairs = require('nvim-autopairs')


npairs.setup({
    enable_check_bracket_line = true, -- Don't add a pair if it exists in the same line
    check_ts = true, -- Use treesitter to handle advanced pair behavior
    disable_filetype = { "TelescopePrompt" }, -- Disable in specific file types
    map_cr = true, -- Automatically add closing braces after Enter
    map_bs = true, -- Allow <BS> to delete both pair characters
    map_c_h = true, -- Skip over closing braces when typing
})


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


require('nvim-treesitter.configs').setup {
    autotag = {
        enable = true,
    },
}


vim.opt.foldmethod = "expr"
vim.opt.foldexpr   = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel  = 99  -- open all folds by default

