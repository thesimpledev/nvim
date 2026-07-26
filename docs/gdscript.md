# GDScript (Godot 4)

Status: **not usable right now**. Neither Godot nor `ncat` is installed. The
wiring is complete and correct, so it should work once both are present.

This setup is unusual: the language server is Godot itself, not a separate
binary.

## How it works

Godot 4 runs an LSP server inside the editor on TCP port 6005. Neovim does not
speak TCP to language servers directly, so the config bridges through `ncat`:

```lua
cmd = { "ncat", "localhost", "6005" }
```

`ncat` pipes Neovim's stdin and stdout to the TCP port. Root markers are
`project.godot` and `.git`.

**This means Godot must be open, with your project loaded, before Neovim can
give you any GDScript completion.** Closing the Godot editor kills the language
server. This is expected behaviour, not a fault.

`ncat` comes from the `nmap` package on Arch. It is missing here.

## The other direction: Godot opening files in Neovim

`init.lua` starts a server socket before anything else loads:

```lua
local godot_pipe = "/tmp/godot.pipe"
vim.fn.delete(godot_pipe)
vim.fn.serverstart(godot_pipe)
```

This lets Godot use Neovim as its external script editor. In Godot, set the
external editor exec path to `nvim` and the flags to something that talks to
that pipe with `--server /tmp/godot.pipe --remote`.

Two things to know:

- The `vim.fn.delete` on the line before is deliberate. A stale socket file
  from a crashed session would stop `serverstart` from binding.
- This runs at the very top of `init.lua`, on **every** Neovim start, whether
  or not you are doing Godot work. It is cheap, but it means every Neovim
  instance you open tries to claim `/tmp/godot.pipe`, and only the first one
  gets it. The rest fail silently.

## Plugin

`Mathijs-Bakker/godotdev.nvim`, set up in `lua/setup.lua` with empty options,
so entirely defaults.

## On save

`.gd` files format on save via `BufWritePre`. That request goes to Godot over
the `ncat` bridge, so with Godot closed, saving does nothing and reports
nothing.

## Treesitter

Three parsers are installed and all work regardless of whether Godot is
running:

| Parser | Covers |
|--------|--------|
| `gdscript` | `.gd` script files |
| `godot_resource` | `.tres`, `.tscn` scene and resource files |
| `gdshader` | `.gdshader` shader files |

So you get highlighting, folding and function motions in GDScript today, even
with nothing else working.

Having `godot_resource` matters more than it sounds. Godot scene files are
large, structured text, and reading a `.tscn` diff without highlighting is
unpleasant.

## To make it work

1. Install Godot 4.
2. Install `nmap` for `ncat`.
3. Open the project in Godot before opening Neovim.
4. In Godot: Editor Settings, Text Editor, External, enable Use External
   Editor, set the exec path to `nvim`.

## Debugging

Nothing configured. Godot's own debugger is in the Godot editor.

## Gotchas

- Godot must be running. There is no offline GDScript language server.
- Port 6005 is Godot 4. Godot 3 used a different port and a different protocol.
- Only one Neovim instance can hold `/tmp/godot.pipe`.
