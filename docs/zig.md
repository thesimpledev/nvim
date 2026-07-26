# Zig

Status: editing works, debugging does not.

`zig` is a system package at `/usr/bin/zig`. `zls` comes from Mason.

## Language server

`zls`, configured in `lua/lsp.lua`. Root markers: `build.zig`,
`build.zig.zon`, `.git`.

| Setting | Value | Effect |
|---------|-------|--------|
| `enable_autofix` | true | |
| `enable_snippets` | true | |
| `enable_inlay_hints` | true | Inline parameter and type hints |
| `warn_style` | true | Style warnings as diagnostics |
| `highlight_global_var_declarations` | true | |
| `enable_build_on_save` | **false** | See below |
| `enable_semantic_tokens` | true | |

`enable_build_on_save` is off. zls will not compile your project in the
background, so you will not see errors that only the real compiler catches
until you build yourself. That is a deliberate tradeoff against zls running
`zig build` on every keystroke pause.

Note that this is the opposite of the Go setup here, where saving runs the full
package test suite automatically. Zig gets nothing on save beyond formatting.

## On save

`.zig` files are formatted by zls on `BufWritePre`, synchronously. That is
`zig fmt` behaviour, which is not configurable by design.

## Building

There is no build helper for Zig. No commands, no keybindings. Use a terminal:

```
zig build
zig build run
zig test src/main.zig
```

C and C++ have `lua/cppbuild.lua` and the `<Space>t*` keys. Go has automatic
tests on save. Zig has neither. If Zig becomes a main language here, that gap
is the thing to fill.

## Debugging is broken

`lua/dap_setup.lua` defines an `lldb` adapter:

```lua
dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-vscode',
    name = 'lldb'
}
```

**`lldb-vscode` is not installed on this machine, and neither is `lldb-dap`.**
Pressing `<F5>` in a Zig file will fail.

Three configurations are defined and none of them can run:

- Launch Zig executable, which looks for the newest binary in `zig-out/bin/`
- Launch Zig test, which prompts for a path under `zig-cache/`
- Attach to process

### How to fix it

Two options:

1. Install LLDB. On Arch that is the `lldb` package, which provides
   `lldb-dap`. Then change `command = 'lldb-vscode'` to `command = 'lldb-dap'`,
   since the binary was renamed in newer LLDB releases.

2. Use gdb instead, which is already installed at 17.2 and already working for
   C and C++. gdb speaks DAP natively and handles Zig binaries. This needs no
   installs at all:

   ```lua
   dap.configurations.zig = dap.configurations.c
   ```

   The `gdb` adapter is already defined in `lua/dap_setup.lua` for C and C++.
   Option 2 is the smaller change and the one to reach for first.

Neither has been done, because Zig is not currently in use here.

## Treesitter

Parser: `zig`, installed. Function motions work.

## Gotchas

- `zls` is a Mason binary. Your shell cannot see it, Neovim can.
- zls version and zig version need to match reasonably closely. zls tracks the
  Zig release cycle and a mismatch produces confusing parse errors rather than
  a clear complaint. If diagnostics look nonsensical after a `zig` upgrade,
  update zls through `:Mason`.
- `enable_build_on_save = false` means the language server is not a substitute
  for building. Compile before trusting that it works.
