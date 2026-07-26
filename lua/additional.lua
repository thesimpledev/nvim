
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


-- Treesitter configuration.
--
-- nvim-treesitter is on its `main` branch, which works differently from the
-- old `master` branch most guides still describe:
--   * setup() takes install_dir only. There is no ensure_installed.
--   * Parsers are installed with install(), which is asynchronous.
--   * Highlighting is opt-in per buffer via vim.treesitter.start().
local ts = require('nvim-treesitter')

ts.setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
})

local languages = {
    "c", "cpp", "cmake",
    "go", "lua", "python", "javascript", "typescript",
    "html", "css", "zig", "elixir", "heex", "ocaml",
    "gdscript", "godot_resource", "gdshader",
}

-- install() re-downloads whatever it is given, so only ask for what is
-- actually missing. On a warm config this is a no-op.
local installed = ts.get_installed('parsers')
local missing = vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
end, languages)

if #missing > 0 then
    ts.install(missing)
end

-- Turn on highlighting, indentation and folding for any buffer whose language
-- has a parser. vim.treesitter.start() asserts on a missing parser, so the
-- pcall is what keeps filetypes we have no parser for from erroring on open.
local function start_treesitter(buf)
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if not lang then
        return
    end
    if not pcall(vim.treesitter.start, buf, lang) then
        return
    end
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
    callback = function(args)
        start_treesitter(args.buf)
    end,
})

-- require('plugins') fires FileType for the buffer nvim opened with, and this
-- file is required after it, so the autocmd above misses that first buffer.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
        start_treesitter(buf)
    end
end
-- vim.g.windsurf_floating_window = true
-- vim.g.windsurf_highlight_duration = 300
