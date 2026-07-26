# C++

Status: working.

C and C++ share one language server, one build helper and one debugger here.
[c.md](c.md) covers the shared machinery in detail: clangd flags, why
`compile_commands.json` matters, the `cppbuild.lua` commands, quickfix
behaviour, and gdb. This file covers what is specific to C++.

## Quick reference

| Key | Command | Action |
|-----|---------|--------|
| `<Space>tc` | `:CppConfigure` | Configure the build directory |
| `<Space>tb` | `:CppBuild` | Build, errors to quickfix |
| `<Space>tt` | `:CppTest` | ctest |
| | `:CppInit` | Copy templates in |

## The templates are C++ by default

Unlike C, C++ needs no edits after `:CppInit`. `templates/cpp/CMakeLists.txt`
gives you:

- `project(myproject LANGUAGES CXX)`
- C++20, standard required, extensions off
- `CMAKE_EXPORT_COMPILE_COMMANDS ON` so clangd works from a bare
  `cmake -B build` as well as from `<Space>tc`
- Debug default, `-O0 -g`
- Release at `-O2 -march=native -DNDEBUG`
- `-Wall -Wextra -Wpedantic`
- A commented out `enable_testing()` block for when you want `<Space>tt`

`-march=native` tunes for this machine only. Drop it if the binary ever needs
to run somewhere else.

## Formatting

`.clang-format` is `BasedOnStyle: LLVM` with the C++ specific bits set:

| Setting | Value |
|---------|-------|
| `IndentWidth` / `TabWidth` | 4, matching `init.lua` |
| `ColumnLimit` | 100 |
| `AccessModifierOffset` | -4, so `public:` sits outdented |
| `NamespaceIndentation` | None |
| `PointerAlignment` / `ReferenceAlignment` | Left, so `int* p` and `int& r` |
| `SpaceAfterTemplateKeyword` | false |
| `IncludeBlocks` | Regroup, so includes get sorted into blocks |

Without this file clangd silently applies LLVM defaults with 2 space indents,
which fights `init.lua`.

## clang-tidy

`templates/cpp/.clang-tidy` enables:

| Group | Purpose |
|-------|---------|
| `bugprone-*` | Real defects |
| `performance-*` | Accidental copies and other silent slowdowns |
| `modernize-*` | Steers away from the C++98 patterns most tutorials still teach |
| `readability-*` | Naming and structure |

With these disabled:

- `modernize-use-trailing-return-type`
- `readability-magic-numbers`
- `readability-identifier-length`
- `readability-braces-around-statements`
- `bugprone-easily-swappable-parameters`

`modernize-*` is the group worth keeping for C++. It is also the group to
delete if you switch a project to C, where it means nothing.

Because `lua/lsp.lua` passes `--clang-tidy` to clangd, these run live as you
type. You do not need to build to see them.

## Debugging

Same as C: gdb 17.2 with `--interpreter=dap`, no adapter binary to install.
`<F5>` prompts for the executable under `build/`.

`dap.configurations.c` is an alias of `dap.configurations.cpp`, so both
languages get the same two entries: Launch, and Attach to process.

## Treesitter

Parsers: `cpp`, plus `c` and `cmake`. Function and class motions (`]f`, `]c`,
`af`, `ic`) work.

## Hardening

If you want warnings as errors, sanitizers, and clang-tidy as a build gate, the
tested CMake fragment in [c.md](c.md) applies almost unchanged. Swap
`CMAKE_C_*` for `CMAKE_CXX_*` and `CMAKE_C_CLANG_TIDY` for
`CMAKE_CXX_CLANG_TIDY`. The four traps listed there apply identically:
clang-tidy needs a `.clang-tidy` file to exist, UBSan needs
`-fno-sanitize-recover=all` to actually fail, sanitizers need to be on the link
line, and `-Wconversion` is the noisy one.
