# Minimal CMake starter for a C project.
#
# Configure once with <leader>tc, then build with <leader>tb.
# That writes build/compile_commands.json, which is the file clangd needs in
# order to give you working completion and error checking.

cmake_minimum_required(VERSION 3.20)

# Name the project after the folder it sits in, so build/<folder> is the
# binary and there is nothing to rename after :CInit.
get_filename_component(PROJECT_DIR_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

project(${PROJECT_DIR_NAME} LANGUAGES C)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# The file clangd reads. <leader>tc passes this too, this line just means a
# plain `cmake -B build` also produces it.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Default to Debug so a bare `cmake -B build` is debuggable.
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Debug keeps optimisation off so the debugger maps cleanly back to source.
# Release is what any performance number should be taken from. -march=native
# tunes for this machine only, so drop it if you ever ship the binary
# elsewhere.
set(CMAKE_C_FLAGS_DEBUG "-O0 -g")
set(CMAKE_C_FLAGS_RELEASE "-O2 -march=native -DNDEBUG")

# Every .c file under src/. CONFIGURE_DEPENDS makes the build re-check for new
# files each time, so adding a .c file needs nothing beyond a build. To list
# files by hand instead, replace this with an explicit list in add_executable.
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/*.c)

add_executable(${PROJECT_NAME} ${SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE src)

target_compile_options(${PROJECT_NAME} PRIVATE
    -Wall
    -Wextra
    -Wpedantic
    -Wshadow
    -Wstrict-prototypes
)

# Tests, driven by <leader>tt. Delete this block if you are not using it yet.
# enable_testing()
# add_executable(tests tests/test_main.c)
# add_test(NAME tests COMMAND tests)
