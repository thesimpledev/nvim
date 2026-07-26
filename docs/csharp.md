# C#

Status: **not usable**. Nothing is installed: no `omnisharp`, no `dotnet`
runtime, and no treesitter parser.

This is the least functional language entry in the config.

## What is configured

`omnisharp` in `lua/lsp.lua`:

```lua
cmd = { "omnisharp", "--languageserver", "--stdio" }
root_dir = vim.fs.root(0, {"*.csproj", "*.sln", ".git"})
```

| Setting | Effect |
|---------|--------|
| `FormattingOptions.EnableEditorConfigSupport` | Honours `.editorconfig` |
| `FormattingOptions.OrganizeImports` | Sorts usings |
| `RoslynExtensionsOptions.EnableAnalyzersSupport` | Roslyn analyzers |
| `RoslynExtensionsOptions.EnableImportCompletion` | Completes types not yet imported and adds the using |
| `flags.debounce_text_changes = 150` | |

There is also an `on_attach` that sets
`client.server_capabilities.semanticTokensProvider = nil`, which disables
semantic token highlighting. OmniSharp's semantic tokens were historically
buggy and fought treesitter, so this turns them off and lets treesitter own
highlighting.

`.cs` files format on save.

## Three separate problems

1. **`omnisharp` is not installed** and is not in `ensure_installed` in
   `lua/mason-setup.lua`.

2. **There is no .NET SDK.** `dotnet` is missing, so even with the server
   installed there would be nothing to build against.

3. **There is no `c_sharp` treesitter parser.** It is not in the `languages`
   list in `lua/additional.lua`. So `.cs` files get no treesitter highlighting,
   no folding, and none of the function or class motions. They fall back to
   Vim's regex syntax file.

Point 3 is worth noting because every other configured language here at least
has a working parser. C# does not.

### The `root_dir` glob does not work either

```lua
root_dir = vim.fs.root(0, {"*.csproj", "*.sln", ".git"})
```

`vim.fs.root()` matches literal filenames, not globs. It will not find
`MyApp.csproj` from the pattern `*.csproj`. Only the `.git` entry actually
does anything.

This is a latent bug shared with several other blocks in `lua/lsp.lua`. There
is a second problem with the same line: `vim.fs.root(0, ...)` is evaluated
**once**, while `lsp.lua` is being read, against whatever buffer happens to be
current at that moment. It is not resolved per buffer.

The C and C++ block was converted to `root_markers` for exactly this reason,
which is resolved per buffer by Neovim itself. Any block still using
`root_dir = vim.fs.root(0, ...)` has the same latent problem.

## OmniSharp is on its way out

OmniSharp is effectively superseded by the Roslyn language server that ships
with the official C# VS Code extension. `roslyn.nvim` is the usual way to run
it in Neovim.

If C# ever becomes real work here, prefer Roslyn over reviving this block.

## To make it work

1. Install the .NET SDK.
2. Install a language server, ideally Roslyn rather than OmniSharp.
3. Add `c_sharp` to the `languages` list in `lua/additional.lua`.
4. Fix the `root_dir` glob, or switch to `root_markers`.

## Debugging

Nothing configured. No adapter, no `dap.configurations.cs`.
