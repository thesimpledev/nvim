# Go

Status: working. This is the most developed language setup here, which makes
sense since it is the day job.

Go 1.26.5 at `/usr/local/go/bin/go`.

## Language server

`gopls`, installed by Mason. Configured in `lua/lsp.lua`.

Settings worth knowing about:

| Setting | Effect |
|---------|--------|
| `gofumpt = true` | Stricter than `gofmt`. gopls has gofumpt built in, so there is no separate binary to install. |
| `staticcheck = true` | staticcheck diagnostics appear inline as you type, not only in CI. |
| `analyses.unusedparams` | Flags parameters nothing reads. |
| `experimentalPostfixCompletions` | `xs.for<tab>` style completions. |
| `buildFlags = {"-tags=exclude_tests"}` | See below. This one is easy to forget and confusing when it bites. |

### The `exclude_tests` build tag

Both gopls and the auto-test runner pass `-tags=exclude_tests`. Any file
guarded by `//go:build exclude_tests` is invisible to the language server and
to the test runner.

If a file seems to have no symbols, no completion, and no errors while looking
perfectly fine, check its build tags first.

## On save

Two things happen on every `.go` write, in order:

1. `vim.lsp.buf.format()` runs gofumpt.
2. An `source.organizeImports` code action runs. Go is the only language here
   that gets this, so imports sort and unused ones disappear automatically.

Both are synchronous, so the file on disk is always formatted.

## Tests run automatically on every save

This is the unusual part of this setup and it is worth understanding, because
it is aggressive.

`lua/gotest.lua` runs on `BufWritePost` for every `.go` file. It runs:

```
go test -tags=exclude_tests -v .
```

in the directory of the file you just saved, so the **whole package**, not just
the file. Results come back as diagnostics attached to the failing lines, plus
a notification:

- Pass: `✓ Tests passed`
- Fail: `✗ Tests failed (N errors)` and diagnostics land on the failing lines
- Build broken: `✗ Build failed (N errors)`
- No tests: `⚠ No test files in package`

A save that was already running a test job cancels the old job first, so
hammering `:w` will not pile up processes.

Two consequences to be aware of:

- Saving a file in a package with slow tests will keep a `go test` process
  running in the background. It is asynchronous, so the editor stays
  responsive, but the machine is doing work.
- Test failures show as diagnostics in the **source** file, alongside gopls
  diagnostics. The `[TestName]` prefix in the message is how you tell them
  apart.

There is no keybinding to run this. It is save-driven only. To run tests
without the automatic path, use a terminal.

## Debugging

Adapter is `dlv` (Delve) at `~/go/bin/dlv`, in DAP server mode.

Configurations available from `<F5>`:

| Name | What it does |
|------|--------------|
| Debug file | Current file only |
| Debug test (pkg) | Tests for the current file's package |
| Debug package | The package as a program |
| Debug specific test | Prompts for a test name, passes `-test.run` |
| Attach remote | Attaches to `127.0.0.1:2345` |

There is one Go-specific debug key:

| Key | Action |
|-----|--------|
| `<Space>dT` | Debug the test under the cursor |

`<Space>dT` reads the word under the cursor. If it does not start with `Test`
it prompts you, then runs that single test anchored with `^...$`.

Note: `CustomCommands.md` describes `<Space>dT` as "Toggle virtual text". That
is wrong. It is debug-test-under-cursor.

## Plugins

`ray-x/go.nvim` and `ray-x/guihua.lua` are installed and loaded. They are not
configured beyond defaults in this setup, so most of what you use day to day is
gopls plus the custom test runner.

## Treesitter

Parser: `go`. Function motions (`]f`, `[f`) work, which is what they were added
for in commit 98be062.

Only the `go` parser is installed. `gomod`, `gowork` and `gosum` are not, so
`go.mod` gets no treesitter highlighting. Add them to the `languages` list in
`lua/additional.lua` if that ever matters.

## Gotchas

- `gopls` is a Mason binary. Your shell cannot see it, Neovim can.
- The `exclude_tests` tag silently hides files from the language server.
- Every save runs the package test suite. In a large package this is real work.
