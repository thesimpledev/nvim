# Complete Neovim Cheat Sheet
## Leader Key = `<Space>`

## File Navigation
| Key | Action |
|-----|--------|
| `<Space>e` | Open file explorer (Ex) |
| `<Space>v` | Open file explorer in vertical split (Vex) |
| `<Space>b` | Switch to alternate buffer |
| `<C-p>` | Telescope find files |
| `<C-f>` | Telescope live grep (search in files) |
| `<C-b>` | Telescope list open buffers |

## Window Navigation
| Key | Action |
|-----|--------|
| `<Space>h` | Move to left window |
| `<Space>l` | Move to right window |
| `<Space>k` | Move to window above |
| `<Space>j` | Move to window below |
| `<Space>w` | Close all floating windows |

## LSP Commands
| Key | Action |
|-----|--------|
| `gd` / `<Space>f` | Go to definition |
| `gr` / `<Space>r` | Find references |
| `<F2>` / `<Space>R` | Rename symbol |
| `<C-k>` | Show signature help |
| `<Space>ca` | Code action |
| `<Space>ds` | Telescope document symbols |
| `<Space>ws` | Telescope workspace symbols |

## Diagnostics
| Key | Action |
|-----|--------|
| `<Space>dd` | Show diagnostic in floating window |
| `<Space>q` | Show diagnostics in location list |

## Clipboard
| Key | Action |
|-----|--------|
| `<Space>y` | Copy to system clipboard (normal/visual) |
| `<Space>Y` | Copy entire file to system clipboard |
| `<Space>p` | Paste from system clipboard |

## Text Manipulation
| Key | Action |
|-----|--------|
| `J` (visual) | Move selected block down |
| `K` (visual) | Move selected block up |
| `<Space><CR>` | Clear search highlighting |

## Git (Fugitive)
| Key | Action |
|-----|--------|
| `<Space>gd` | Git diff |

## Debugging (DAP)
| Key | Action |
|-----|--------|
| `<F5>` / `<Space>dc` | Continue |
| `<F9>` / `<Space>db` | Toggle breakpoint |
| `<F10>` / `<Space>do` | Step over |
| `<F11>` / `<Space>di` | Step into |
| `<S-F11>` / `<Space>du` | Step out |
| `<Space>dB` | Conditional breakpoint |
| `<Space>dr` | Open REPL |
| `<Space>dl` | Run last debug config |
| `<Space>dt` | Terminate debug session |
| `<Space>dU` | Toggle DAP UI |
| `<Space>dT` | Toggle virtual text |

## Completion (CMP)
| Key | Action |
|-----|--------|
| `<Tab>` | Confirm completion / snippet jump / tabout / indent |
| `<C-n>` | Select next completion item |
| `<C-p>` | Select previous completion item |
| `<C-y>` | Confirm selection |
| `<C-Space>` | Trigger completion |

## Flash (Navigation)
| Key | Action |
|-----|--------|
| `<Space>s` | Flash jump |
| `<Space>S` | Flash Treesitter (select syntax nodes) |
| `r` (operator) | Remote flash (after d/c/y) |
| `R` (operator/visual) | Treesitter search |
| `<C-s>` (in search) | Toggle flash during / or ? search |

## Mini.Surround
| Key | Action |
|-----|--------|
| `sa{motion}{char}` | Add surrounding (e.g., `saiw"` = surround word with ") |
| `sd{char}` | Delete surrounding (e.g., `sd"` = delete surrounding ") |
| `sr{old}{new}` | Replace surrounding (e.g., `sr"'` = change " to ') |
| `sf{char}` | Find surrounding (right) |
| `sF{char}` | Find surrounding (left) |
| `sh{char}` | Highlight surrounding |

## Comment.nvim
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc{motion}` | Comment with motion (e.g., `gcip` = comment paragraph) |
| `gb{motion}` | Block comment with motion |
| `gc` (visual) | Toggle line comment on selection |
| `gb` (visual) | Toggle block comment on selection |
| `gco` | Add comment below, enter insert mode |
| `gcO` | Add comment above, enter insert mode |
| `gcA` | Add comment at end of line |

## Automatic (No Keys)
| Plugin | Function |
|--------|----------|
| fidget.nvim | Shows LSP progress in bottom-right corner |
| colorizer | Inline color previews for hex/rgb values |
| autopairs | Auto-closes brackets, quotes, etc. |
| autotag | Auto-closes HTML/XML tags |
