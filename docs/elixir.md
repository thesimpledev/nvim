# Elixir

Status: **not usable**. The language server is installed, the language is not.

`elixir-ls` is present at `~/.local/share/nvim/mason/bin/elixir-ls`, installed
by Mason from the `ensure_installed` list. But `elixir`, `iex` and `mix` are
all missing from the machine.

elixir-ls is itself written in Elixir and runs on the BEAM, so with no Elixir
runtime it cannot start.

## What is configured

`elixirls` in `lua/lsp.lua`, with `cmd = { "elixir-ls" }` and root markers
`mix.exs`, `.git`.

| Setting | Value | Effect |
|---------|-------|--------|
| `dialyzerEnabled` | true | Dialyzer type analysis. Builds a PLT on first run, which takes minutes. |
| `fetchDeps` | **false** | Will not run `mix deps.get` behind your back |
| `enableTestLenses` | true | Inline "run test" lenses above test blocks |
| `suggestSpecs` | true | Suggests `@spec` annotations from inferred types |

Format on save covers `.ex`, `.exs` and `.heex`.

## To make it work

Install Elixir, which brings Erlang/OTP with it. On Arch that is the `elixir`
package. Then elixir-ls should start on its own, since it is already installed.

Note that Erlang support was removed from this config on 2026-07-25. The
`erlangls` block was configured but `erlang_ls` was never installed, and it
logged an error into `~/.local/state/nvim/lsp.log` on every single startup. If
you install Elixir you get an Erlang runtime, but there is no Erlang language
server configured any more. Add one back only if you actually write Erlang.

## Dialyzer is slow the first time

`dialyzerEnabled = true` means the first run on a project builds a persistent
lookup table covering the whole standard library and all dependencies. It takes
minutes and pins a core. It is cached afterwards. Do not assume the server has
hung.

## Debugging

`elixir-ls-debugger` is installed by Mason alongside the language server.

**Nothing in `lua/dap_setup.lua` references it.** There is no adapter and no
`dap.configurations.elixir`, so `<F5>` does nothing in an Elixir file.

## Treesitter

Parsers installed: `elixir`, `heex`.

Both work today, so `.ex` and `.heex` files get correct highlighting, folding
and function motions even with no language server running.

`heex` is the HTML-like template syntax used by Phoenix. Having its own parser
means template files highlight properly rather than being treated as plain
HTML.

## Summary

Treesitter works. Everything else waits on installing Elixir.
