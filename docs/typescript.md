# TypeScript and JavaScript

Status: working.

One language server handles both languages, which is why they share a file.
Angular is covered here too, since `angularls` is TypeScript tooling.

`typescript-language-server` from Mason. Node 24.13.0 via nvm at
`~/.local/share/nvm/v24.13.0/bin/node`.

## Language server

`ts_ls`, configured in `lua/lsp.lua`. Note the name: the server was renamed
from `tsserver` to `ts_ls` upstream, so older guides referencing `tsserver`
will not match this config.

| Setting | Effect |
|---------|--------|
| `javascript.inlayHints.includeInlayParameterNameHints = 'all'` | Parameter names shown inline at call sites |
| `javascript.completions.completeFunctionCalls = true` | Completing a function inserts its parentheses and parameter placeholders |

Both settings are under the `javascript` key only. TypeScript files use the
same server but do not get these two settings, since there is no matching
`typescript` block. If inlay hints appear in `.js` and not `.ts`, that is why,
and adding a `typescript = { ... }` block with the same contents fixes it.

No `root_dir` or `root_markers` are set, so root detection falls back to
whatever nvim-lspconfig ships for `ts_ls`, which looks for `tsconfig.json`,
`jsconfig.json`, `package.json` and `.git`.

## On save

`.js`, `.ts`, `.jsx` and `.tsx` are formatted by the language server on
`BufWritePre`, synchronously.

This uses the server's built-in formatter, not Prettier. There is no Prettier,
ESLint or `none-ls` integration in this config. If a project expects Prettier
formatting, saving here will fight it. Run Prettier from a terminal or add a
formatter integration if that becomes a real problem.

## Debugging

Adapter is `pwa-node`, from the `js-debug-adapter` Mason package, launched
through Node:

```
node ~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js
```

**That package is not installed.** The Mason packages directory contains only
`css-lsp`, `elixir-ls`, `gopls`, `html-lsp`, `lua-language-server`,
`typescript-language-server` and `zls`. `js-debug-adapter` is not in the
`ensure_installed` list in `lua/mason-setup.lua` either, so `<F5>` in a
JavaScript or TypeScript file fails today. Install it through `:Mason` to fix.

Two configurations:

| Language | Name | Notes |
|----------|------|-------|
| JavaScript | Launch file | Runs the current file |
| TypeScript | Launch TS (built) | Runs the current file, with `outFiles` pointing at `${workspaceFolder}/dist/**/*.js` |

The TypeScript entry debugs **compiled output**. It expects your build to emit
to `dist/` with source maps. It does not compile for you and it does not run
`ts-node`. Build first, then debug.

## Angular

`angularls` is configured in `lua/lsp.lua` with `cmd = { "ngserver", "--stdio" }`
and root markers `angular.json`, `project.json`.

**`ngserver` is not installed on this machine**, so this does nothing today.
It normally comes from the `@angular/language-server` npm package, or from
Mason as `angular-language-server`. It is not in the `ensure_installed` list.

## Plugins that apply

- `nvim-ts-autotag` closes JSX and TSX tags automatically, driven by
  treesitter.
- `nvim-autopairs` with `check_ts = true`, so bracket pairing is treesitter
  aware rather than naive.
- `emmet-vim` is loaded but its use is mainly HTML. See
  [html-css.md](html-css.md).

## Treesitter

Parsers installed: `javascript`, `typescript`.

**`tsx` is not installed.** `.tsx` files fall back to the `typescript` parser,
which does not understand JSX syntax, so highlighting inside JSX blocks will be
wrong and `nvim-ts-autotag` will not work properly there. Add `tsx` to the
`languages` list in `lua/additional.lua` if you write React.

## Gotchas

- Formatting is the language server's, not Prettier's.
- The two `javascript` settings do not apply to TypeScript files.
- `tsx` has no parser, which matters for React work.
- `ngserver` is configured but absent.
- The js-debug-adapter Mason package is not in `ensure_installed`, so `<F5>`
  may fail on a fresh machine even though the config looks complete.
