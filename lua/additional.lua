
vim.cmd([[
  function! CustomVex()
    rightbelow vsplit
    Explore
  endfunction
  command! Vex call CustomVex()
]])


-- Create or get the 'spellcheck' augroup
local spellcheck_group = vim.api.nvim_create_augroup('spellcheck', { clear = true })

-- Define an autocommand for the 'FileType' event
vim.api.nvim_create_autocmd('FileType', {
  group = spellcheck_group,
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
})


-- Disable Perl provider
vim.g.loaded_perl_provider = 0

-- Disable Ruby provider
vim.g.loaded_ruby_provider = 0


require('nvim-treesitter.configs').setup {
    ensure_installed = { "go", "lua", "python", "javascript", "typescript", "html", "css" }, -- add the languages you use
    highlight = { enable = true },
    indent    = { enable = true },
    autotag   = { enable = true },
    fold      = { enable = true },
}
-- vim.g.windsurf_floating_window = true
-- vim.g.windsurf_highlight_duration = 300
