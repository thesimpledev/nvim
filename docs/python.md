# Python

Status: **not usable**. The configuration is complete, the language server is
not installed.

`python3` is present at `/usr/bin/python3`. `pylsp` is not, and Neovim cannot
resolve it either.

## What is configured

`pylsp` in `lua/lsp.lua`:

| Plugin | Enabled | Purpose |
|--------|---------|---------|
| `pycodestyle` | yes | PEP 8 style checking |
| `pyflakes` | yes | Unused imports, undefined names |
| `pylint` | **no** | Deliberately off, it overlaps with pyflakes and is slow |
| `pylsp_mypy` | yes | Static type checking |

No `root_dir` or `root_markers`, so root detection uses nvim-lspconfig's
defaults for `pylsp`.

`.py` files are set to format on save via `BufWritePre`.

## Why it does not work

`pylsp` is not in the `ensure_installed` list in `lua/mason-setup.lua`, and it
is not installed by hand either. `vim.lsp.enable('pylsp')` is called, but with
no binary to launch there is no server.

Neovim 0.12 does not complain loudly about this. It logs to
`~/.local/state/nvim/lsp.log` and otherwise stays quiet, so Python files simply
open with no completion and no diagnostics.

## To make it work

Add `pylsp` to `ensure_installed` in `lua/mason-setup.lua`, or install it once
through `:Mason`.

Two of the enabled plugins are separate pip packages that Mason's base `pylsp`
install does not include:

- `pylsp-mypy` for the `pylsp_mypy` setting
- `python-lsp-server[all]` covers `pycodestyle` and `pyflakes`

Without those the settings are silently ignored rather than erroring, so a
partial install looks like it worked.

An alternative worth considering is `basedpyright` or `pyright`, which is
faster and does type checking without the plugin stack. That would mean
rewriting the config block, since the settings shape is completely different.

## Debugging

`mfussenegger/nvim-dap-python` is installed as a plugin in `lua/plugins.lua`.

**It is never set up.** `lua/dap_setup.lua` configures Go, JavaScript,
TypeScript, Zig, C and C++, but has no `require('dap-python').setup(...)` call
and no `dap.configurations.python`. So `<F5>` does nothing in a Python file
even though the plugin is loaded.

To fix, `dap-python` needs a setup call pointing at a Python with `debugpy`
installed, conventionally:

```lua
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
```

## Treesitter

Parser: `python`, installed and working. So syntax highlighting, folding, and
the function motions (`]f`, `[f`, `af`, `if`) all work today, even with no
language server.

## Summary

Editing Python here gives you treesitter highlighting and motions, and nothing
else. No completion, no diagnostics, no formatting despite the save hook, no
debugging.
