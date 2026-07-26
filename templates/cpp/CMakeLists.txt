# Minimal CMake starter. Roughly the job go.mod and go build do together,
# except you write it yourself.
#
# Configure once with <leader>tc, then build with <leader>tb.
# That writes build/compile_commands.json, which is the file clangd needs in
# order to give you working completion and error checking.

cmake_minimum_required(VERSION 3.20)

project(myproject LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# The file clangd reads. <leader>tc passes this too, this line just means a
# plain `cmake -B build` also produces it.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Default to Debug so a bare `cmake -B build` is debuggable.
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Debug keeps optimisation off so the debugger maps cleanly back to source.
# Release is what any performance number should be taken from: unoptimised C++
# can run ten to fifty times slower, worst in exactly the tight loops a physics
# solver is made of. -march=native tunes for this machine only, so drop it if
# you ever ship the binary elsewhere.
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -march=native -DNDEBUG")

add_executable(myproject
    src/main.cpp
)

target_include_directories(myproject PRIVATE src)

target_compile_options(myproject PRIVATE
    -Wall
    -Wextra
    -Wpedantic
)

# Tests, driven by <leader>tt. Delete this block if you are not using it yet.
# enable_testing()
# add_executable(tests tests/test_main.cpp)
# add_test(NAME tests COMMAND tests)
