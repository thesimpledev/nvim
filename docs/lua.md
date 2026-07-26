# Lua

Status: working. Two distinct uses here: editing this Neovim config, and
writing LÖVE games.

`lua-language-server` from Mason. `luajit` and `love` 11.5 are system packages.

## The language server is started differently from every other one

Every other language in `lua/lsp.lua` uses the `vim.lsp.config()` plus
`vim.lsp.enable()` pair. Lua does not. It calls `vim.lsp.start()` from a
`FileType` autocmd instead:

```lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = start_lua_ls,
})
```

The config-and-enable pipeline did not work for `lua_ls` and the reason was
never pinned down, most likely a merge conflict with the defaults
nvim-lspconfig ships. This is a deliberate workaround, not an oversight. Leave
it alone unless you are prepared to debug it.

Two consequences:

- The path to the server is **hardcoded**:
  `/home/thesimpledev/.local/share/nvim/mason/bin/lua-language-server`. If
  Mason's layout changes or the username changes, this breaks.
- Because `require('plugins')` fires `FileType` for the buffer Neovim opened
  with, and `lua/lsp.lua` loads afterwards, the autocmd would miss that very
  first buffer. So the file also checks `vim.bo.filetype` directly and calls
  the handler immediately. If you ever add another `FileType` autocmd in
  `lsp.lua` or later, it needs the same treatment.

## Settings

| Setting | Value | Why |
|---------|-------|-----|
| `runtime.version` | `LuaJIT` | What both Neovim and LÖVE use |
| `diagnostics.globals` | `love`, `vim` | Otherwise every `vim.` and `love.` call is an undefined-global warning |
| `workspace.library` | `$VIMRUNTIME` | Gives completion for the whole Neovim API |
| `workspace.checkThirdParty` | `true` | LÖVE autodetection, see below |
| `telemetry.enable` | `false` | |

Root markers: `.luarc.json`, `.luarc.jsonc`, `.git`, falling back to the
current directory.

## LÖVE

With `checkThirdParty = true`, opening a Lua file in a directory that looks
like a LÖVE project makes lua_ls offer to download LÖVE type annotations. Say
yes. It writes a `.luarc.json` into the project directory, and after that you
get completion and signatures for the whole `love.*` API.

That `.luarc.json` is per project and belongs in the project's own repository,
not here.

Run a game with `love .` from the project directory. There is no keybinding or
command wired up for this, and no debug adapter for Lua, so LÖVE debugging is
print based.

## Editing this config

`$VIMRUNTIME` in the library path means you get completion for `vim.api`,
`vim.fn`, `vim.lsp` and the rest while editing files under `~/.config/nvim`.

The `vim` global is whitelisted in `diagnostics.globals`, so it will not be
flagged as undefined.

## On save

`.lua` files are formatted by lua_ls on `BufWritePre`, synchronously.

There is no `.editorconfig` or `.luarc.json` at the root of this config, so
formatting uses lua_ls defaults, which do not match the 4 space setting in
`init.lua`. The existing files are hand formatted and inconsistent in places.
Worth knowing before you blame yourself for a diff full of whitespace.

## Treesitter

Parser: `lua`. Neovim ships one as well, but the nvim-treesitter version takes
priority because `install_dir` is prepended to the runtimepath.

Function motions work. `]f` and `[f` jump between functions, which is useful in
`lsp.lua` given its length.

## Gotchas

- The hardcoded server path is the fragile part of this setup.
- If Lua completion dies after a Mason update, check that path first:
  `:lua print(vim.fn.exepath('lua-language-server'))` will still find it on
  Neovim's PATH even when the hardcoded absolute path is stale, which makes the
  failure look stranger than it is.
- `require` paths in this config are relative to `lua/`, so
  `require('cppbuild')` loads `lua/cppbuild.lua`. Load order is set explicitly
  in `init.lua` and it matters: `require('plugins')` must come first because
  `plug#end()` is what puts the plugins on the runtimepath.
