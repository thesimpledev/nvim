# C

Status: working. C and C++ share one language server, one build helper and one
debugger here, so most of this file applies to both. The differences that
matter for C are called out.

Toolchain, all system packages, none from Mason:

| Tool | Version |
|------|---------|
| clang | 22.1.6 |
| gcc | present, CMake picks it by default |
| clangd | 22.1.6 |
| clang-tidy, clang-format | 22.1.6 |
| cmake | 4.3.3 |
| ninja | present |
| gdb | 17.2 |
| scan-build | present |

`clang -std=c23` works, so C23 is available: `constexpr`, `nullptr`,
`[[nodiscard]]` and friends.

Not installed: `cppcheck`, `valgrind`, `include-what-you-use`. None are needed
for the setup below. `bear` is not needed either, because CMake writes
`compile_commands.json` directly.

## Language server

`clangd`, the system binary at `/usr/bin/clangd`. Not from Mason.

Flags set in `lua/lsp.lua`:

```
--background-index
--clang-tidy
--header-insertion=iwyu
--completion-style=detailed
--function-arg-placeholders=1
```

Root is found via `root_markers`: `.clangd`, `compile_commands.json`,
`CMakeLists.txt`, `.git`.

`--clang-tidy` means clang-tidy runs live as you type, using whatever
`.clang-tidy` file is in the project. You get analyzer findings inline without
building.

### The flag that used to break everything

`--function-arg-placeholders` must have a value. clangd 22 rejects it as a bare
flag, exits 1, and Neovim reports only "Client clangd quit with exit code 1".
The result is no C or C++ language server at all, silently. It is written as
`=1` now. If clangd ever dies on startup, check the argv list in
`~/.local/state/nvim/lsp.log` first.

## clangd needs compile_commands.json

Without it clangd guesses, and the guesses are wrong: missing include paths,
wrong standard, invented errors. CMake writes it when configured with
`-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, which `<Space>tc` always passes.

`:CInit` writes a `.clangd` file containing:

```yaml
CompileFlags:
  CompilationDatabase: build
```

which points clangd at `build/compile_commands.json` explicitly rather than
letting it search.

## Build and test

`lua/cppbuild.lua`. All CMake driven, all asynchronous, all language neutral,
so these work identically for C and C++.

| Key | Command | Action |
|-----|---------|--------|
| `<Space>tc` | `:CppConfigure` | `cmake -S . -B build -G Ninja`, prompts for build type (default Debug) |
| `<Space>tb` | `:CppBuild` | `cmake --build build`, errors to quickfix |
| `<Space>tt` | `:CppTest` | `ctest --test-dir build --output-on-failure` |
| | `:CInit` | Copy the C templates in, then configure `build/` |

`:CInit` configures for you, so a fresh project builds immediately and
`<Space>tc` is not part of starting one. It only configures when `build/` is
absent, so running it again in an existing project will not disturb a build
directory you already have.

Running the program is not done from inside Neovim. Build here so errors land
in quickfix, then run it from a normal terminal:

```
just build
```

That is the `justfile` the templates bring in. It compiles, and on success runs
the binary with nothing else on screen. On failure it prints the compiler output
and does not run, so what you are looking at is never the last version that
happened to compile. The long form is:

```
cmake --build build && ./build/<folder-name>
```

The binary is named after the project folder, so in `~/.../c/p1` it is
`./build/p1`. The justfile works this out with
`file_name(justfile_directory())`, so nothing in it needs editing per project.

Notes:

- Only one job runs at a time. Starting a second gives
  "cppbuild: a job is already running" rather than two competing builds.
- Compiler errors are parsed into quickfix by errorformat, so `:cc`, `:cn` and
  `:cp` navigate them. clang-tidy and clang-analyzer findings come through the
  same path, including the analyzer's note chain, which is what makes an
  analyzer trace followable.

## Templates

`:CInit` copies these from `templates/c/` into the current directory, skipping
any that already exist. Nothing needs editing afterwards.

| File | Purpose |
|------|---------|
| `CMakeLists.txt` | `LANGUAGES C`, C23, every `.c` under `src/` |
| `.clangd` | Points clangd at `build/` |
| `.clang-format` | 4 space indent, 100 column, matching `init.lua` |
| `.clang-tidy` | C check set: `bugprone-*`, `cert-*`, `clang-analyzer-*`, `portability-*`, `performance-*`, `misc-*` |
| `justfile` | `just build`: compile, then run the binary |
| `src/main.c` | Hello World starter, so the project builds straight away |

`templates/cpp/` has no `justfile`, because its `CMakeLists.txt` still hardcodes
`project(myproject)` rather than taking the folder name, so the same recipe
would look for the wrong binary.

`:CppInit` is the C++ equivalent and copies from `templates/cpp/`. The two sets
are separate because `CMakeLists.txt` and `.clang-tidy` genuinely differ:
`modernize-*` rewrites toward C++ idioms and means nothing in C.

The C `CMakeLists.txt` picks up sources with:

```cmake
get_filename_component(PROJECT_DIR_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
project(${PROJECT_DIR_NAME} LANGUAGES C)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/*.c)
add_executable(${PROJECT_NAME} ${SOURCES})
```

The project takes its name from the folder it sits in, so there is nothing to
rename after `:CInit`.

so a project with a hundred files needs no more typing than one.
`CONFIGURE_DEPENDS` makes the build re-check for new files each time, so
adding a `.c` file needs nothing beyond a build. Since `:CInit` does the first
configure, `<Space>tc` is left for when you change `CMakeLists.txt` itself, or
want a build type other than the Debug that `:CInit` picks.

### Just learning, one file

None of this is required. A single file compiles and runs with:

```
clang hello.c -o hello
./hello
```

CMake starts earning its keep when a project has several files and settings
worth writing down once.

## Hardened C setup

If you want warnings as errors, sanitizers and a mandatory static analysis
gate, this CMakeLists was tested end to end on this machine and works:

```cmake
cmake_minimum_required(VERSION 3.20)
project(physics LANGUAGES C)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_C_FLAGS_DEBUG "-O0 -g -fno-omit-frame-pointer")
set(CMAKE_C_FLAGS_RELEASE "-O2 -march=native -DNDEBUG")

# Static analysis as a build gate, the way staticcheck is a gate in Go CI.
set(CMAKE_C_CLANG_TIDY clang-tidy --warnings-as-errors=*)

add_executable(physics src/main.c)

target_compile_options(physics PRIVATE
    -Wall -Wextra -Wpedantic -Werror
    -Wshadow -Wconversion -Wstrict-prototypes
)

# Sanitizers in Debug only, and they must be on the link line too.
target_compile_options(physics PRIVATE
    $<$<CONFIG:Debug>:-fsanitize=address,undefined -fno-sanitize-recover=all>
)
target_link_options(physics PRIVATE
    $<$<CONFIG:Debug>:-fsanitize=address,undefined>
)
```

Configure with clang rather than the default gcc:

```
CC=clang cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
```

Neither `<Space>tc` nor the configure inside `:CInit` sets `CC`, so both give
you the default gcc. Either export `CC` or delete `build/` and configure once
from the shell.

### Four things that will cost you an evening

1. **`CMAKE_C_CLANG_TIDY` with `--warnings-as-errors=*` fails with
   "no checks enabled"** unless a `.clang-tidy` file exists in the tree. The
   error message does not mention the missing file.

2. **UBSan prints and keeps going by default.** It is not a gate without
   `-fno-sanitize-recover=all`. With that flag a signed overflow aborts with
   exit 1. Without it your build script sees success.

3. **Sanitizers must be on the link line as well as the compile line.** Compile
   flags alone produce link errors about missing `__asan_*` symbols.

4. **`-Wconversion` is the noisy one.** Physics code converts between `int` and
   `double` constantly and this will flag a lot of it. Defensible, but it is
   the flag most likely to make you want to back off, and dropping it later
   touches nothing else.

### What this catches

Verified on this machine:

- `-Werror` blocks the build on an unused static function
- clang-analyzer catches out of bounds access statically: `arr[9]` on
  `int arr[4]` fails the build before it ever runs
- those findings reach quickfix through `<Space>tb`, with the analyzer note
  chain intact so you can follow the path
- UBSan traps signed overflow at runtime with file and line
- ASan reports heap overflow with a source level stack trace
- clangd handles C23 with no false diagnostics, and `<F5>` debugs a sanitized
  binary without complaint

## Debugging

gdb 17.2 speaks DAP natively, so there is no separate adapter binary. No
`lldb-dap`, no `codelldb`.

`<F5>` prompts for the executable, defaulting to `<cwd>/build/`. There is also
an attach-to-process configuration.

Debug builds only. An optimised binary has its variables folded away and its
line table reordered, so stepping through one is misleading rather than
broken. `<Space>tc` defaults to Debug for this reason.

ASan and gdb coexist. Debugging a sanitized binary works.

## Treesitter

Parsers: `c`, `cpp`, `cmake`. All installed, so `CMakeLists.txt` gets proper
highlighting too.

## Gotchas

- `.clangd`, `.clang-format` and `.clang-tidy` are per project. A project
  without them gets clangd's defaults: LLVM style with 2 space indents, which
  fights the 4 space settings in `init.lua`.
- clangd logs its normal chatter to stderr, and Neovim records anything on
  stderr at error level. `[ERROR] "rpc" "clangd" "stderr"` lines full of
  `I[...]` are informational, not failures.
- nvim-lspconfig sends a deprecated `offsetEncoding` capability. clangd 22 warns
  about it and will drop support in clangd 23. The fix belongs upstream in
  nvim-lspconfig, so update that plugin nearer the time.
