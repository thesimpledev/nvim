# Language notes

One file per language, covering how it is wired up in this config: which
language server runs, what happens on save, how to build, test and debug, and
whatever is unusual enough to forget in six months.

| Language | File | Status on this machine |
|----------|------|------------------------|
| Go | [go.md](go.md) | Working |
| C | [c.md](c.md) | Working |
| C++ | [cpp.md](cpp.md) | Working |
| Zig | [zig.md](zig.md) | Editing works, debugging does not |
| Lua | [lua.md](lua.md) | Working |
| TypeScript / JavaScript | [typescript.md](typescript.md) | Editing works, debugging does not |
| HTML / CSS | [html-css.md](html-css.md) | Working |
| Python | [python.md](python.md) | Not usable, server not installed |
| Elixir | [elixir.md](elixir.md) | Not usable, language not installed |
| C# | [csharp.md](csharp.md) | Not usable, nothing installed |
| GDScript | [gdscript.md](gdscript.md) | Not usable, Godot and ncat missing |

Status was checked on 2026-07-25 by asking Neovim itself which binaries it can
resolve, not by reading the config. A language server being configured in
`lua/lsp.lua` does not mean it is installed.

## Things that apply to every language

### Leader key

Leader is `<Space>`. Set in `init.lua` before anything else loads, because
plugins capture it at load time.

### Language servers come from Mason, and are invisible to your shell

Mason installs servers into `~/.local/share/nvim/mason/bin/`, which is **not**
on the system PATH. Neovim prepends it at startup, so `gopls` resolves inside
Neovim and reports "command not found" in fish. That is expected, not a broken
install.

To check what Neovim can actually see:

```vim
:lua print(vim.fn.exepath('gopls'))
```

`:Mason` opens the installer UI. `lua/mason-setup.lua` lists what gets
installed automatically.

### Format on save

Every language sets its own `BufWritePre` autocmd in `lua/lsp.lua` that calls
`vim.lsp.buf.format({ async = false })`. It is synchronous on purpose, so the
file on disk is always the formatted version. If a save feels slow, the
language server is the reason.

Go additionally runs an organize-imports code action. It is the only language
that does.

### Treesitter

Parsers are built by the `tree-sitter` CLI and live in
`~/.local/share/nvim/site/parser/`. The language list is in
`lua/additional.lua`.

This config uses the **`main` branch** of nvim-treesitter, which behaves
differently from the `master` branch that most guides online still describe:

- `setup()` takes `install_dir` only. There is no `ensure_installed`.
- Parsers are installed with `install()`, or `:TSInstall <lang>`.
- Highlighting is opt-in. `lua/additional.lua` turns it on per buffer.
- The `tree-sitter` CLI is required to build parsers. It is at
  `~/.local/bin/tree-sitter`.

To add a language, put it in the `languages` list in `lua/additional.lua` and
restart, or run `:TSInstall <lang>` for a one-off. `:TSLog` shows what happened
when an install fails.

Treesitter gives you, in any language with a parser:

| Key | Action |
|-----|--------|
| `]f` / `[f` | Next / previous function start |
| `]F` / `[F` | Next / previous function end |
| `]c` / `[c` | Next / previous class or struct |
| `af` / `if` | Select around / inside function |
| `ac` / `ic` | Select around / inside class or struct |

### Debugging

All languages share one set of debug keys, defined in `lua/dap_setup.lua`.
Whether they do anything depends on that language having a debug adapter
configured and installed.

| Key | Action |
|-----|--------|
| `<F5>` / `<Space>dc` | Start or continue |
| `<F9>` / `<Space>db` | Toggle breakpoint |
| `<F10>` / `<Space>do` | Step over |
| `<F11>` / `<Space>di` | Step into |
| `<S-F11>` / `<Space>du` | Step out |
| `<Space>dB` | Conditional breakpoint |
| `<Space>dt` | Terminate |
| `<Space>dU` | Toggle the debug UI |

### Health checks

```vim
:checkhealth
:checkhealth nvim-treesitter
:checkhealth vim.lsp
:Mason
```

`:checkhealth vim.lsp` shows which servers are attached to the current buffer,
which is usually the fastest way to find out why completion is dead.
