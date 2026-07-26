# HTML and CSS

Status: working.

Both servers come from Mason: `vscode-html-language-server` and
`vscode-css-language-server`. They are the servers extracted from VS Code.

## Language servers

Configured in `lua/lsp.lua` as `html` and `cssls`. Both get only
`capabilities`, no settings and no root markers, so they run on
nvim-lspconfig's defaults.

You get completion for tags, attributes, properties and values, plus hover
documentation. Neither server does much analysis beyond that.

## On save

`.html` and `.css` are formatted on `BufWritePre`, synchronously, by their
respective servers.

Note that this autocmd sits directly under the Angular block in `lua/lsp.lua`
rather than under the HTML and CSS blocks. It is easy to miss when reading the
file top to bottom.

## Emmet

`mattn/emmet-vim` is installed. It expands abbreviations into markup, so
`ul>li*3` becomes a list with three items.

The default trigger is `<C-y>,` (control-y then a comma). That trailing comma
is part of the mapping and is the thing everyone forgets.

Emmet is not configured beyond installing it, so it uses its own defaults and
its own filetype list.

## Auto-closing tags

`windwp/nvim-ts-autotag`, set up in `lua/setup.lua` with defaults. It closes
and renames tag pairs as you type, using treesitter rather than regex, so it
understands nesting.

This works in HTML and in JSX or TSX, with the caveat about the missing `tsx`
parser noted in [typescript.md](typescript.md).

## Colour previews

`norcalli/nvim-colorizer.lua`, set up in `lua/setup.lua` with defaults. Hex
codes, `rgb()` and named colours are shown in their actual colour inline. Most
useful in CSS.

It runs on all filetypes with default settings, so you will see colour previews
in other languages too wherever something looks like a colour code.

## Treesitter

Parsers installed: `html`, `css`.

Injections work without configuration, so a `<style>` block inside an HTML file
gets CSS highlighting and a `<script>` block gets JavaScript highlighting. That
is Neovim's own injection support, not a plugin.

## Not covered

- No Tailwind language server.
- No `emmet_ls`. Emmet here is the vimscript plugin, not a language server, so
  its completions do not appear in the `nvim-cmp` popup alongside LSP results.
  It is a separate keystroke.
- No linting. There is no stylelint, htmlhint or similar wired in.
- Angular is configured but `ngserver` is not installed. See
  [typescript.md](typescript.md).
