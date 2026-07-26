-- CMake build helpers for C/C++.
-- Same shape as gotest.lua: a module table, vim.fn.jobstart for async work,
-- vim.notify for summaries. Compiler output is turned into quickfix entries by
-- vim.fn.getqflist({ lines = ..., efm = ... }), so there is no regex here.

local M = {}

local BUILD_DIR = "build"

-- gcc/clang diagnostics, plus the "In file included from" chain that C++ error
-- messages are usually buried in.
local ERRORFORMAT = table.concat({
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
    "%f:%l:%c: %m",
    "%f:%l: %trror: %m",
    "%f:%l: %tarning: %m",
    "%-GIn file included from %f:%l:%c:",
    "%-GIn file included from %f:%l:",
    "%-G%.%#",
}, ",")

local running = false

-- Root of the current project, found the same way clangd finds it.
local function project_root()
    return vim.fs.root(0, {
        "CMakeLists.txt",
        "compile_commands.json",
        ".clangd",
        ".git",
    }) or vim.fn.getcwd()
end

local function build_path(root)
    return root .. "/" .. BUILD_DIR
end

-- Run cmd asynchronously in root. on_done receives (exit_code, output_lines).
local function run(cmd, root, label, on_done)
    if running then
        vim.notify("cppbuild: a job is already running", vim.log.levels.WARN)
        return
    end
    running = true

    local output = {}
    local function collect(_, data)
        if not data then
            return
        end
        for _, line in ipairs(data) do
            if line ~= "" then
                table.insert(output, line)
            end
        end
    end

    vim.notify("cppbuild: " .. label .. "...", vim.log.levels.INFO)

    vim.fn.jobstart(cmd, {
        cwd = root,
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = collect,
        on_stderr = collect,
        on_exit = function(_, code)
            running = false
            on_done(code, output)
        end,
    })
end

-- Push compiler output into the quickfix list. Returns the number of entries.
local function to_quickfix(output, title)
    local items = vim.fn.getqflist({ lines = output, efm = ERRORFORMAT }).items
    local valid = {}
    for _, item in ipairs(items) do
        if item.valid == 1 then
            table.insert(valid, item)
        end
    end
    vim.fn.setqflist({}, " ", { title = title, items = valid })
    return #valid
end

-- cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=<type> -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
function M.configure()
    local root = project_root()

    if vim.fn.filereadable(root .. "/CMakeLists.txt") == 0 then
        vim.notify("cppbuild: no CMakeLists.txt in " .. root .. " (try :CInit or :CppInit)", vim.log.levels.ERROR)
        return
    end

    local build_type = vim.fn.input("Build type: ", "Debug")
    if build_type == "" then
        return
    end

    local cmd = {
        "cmake",
        "-S", ".",
        "-B", BUILD_DIR,
        "-G", "Ninja",
        "-DCMAKE_BUILD_TYPE=" .. build_type,
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
    }

    run(cmd, root, "configure (" .. build_type .. ")", function(code, output)
        if code == 0 then
            vim.notify("cppbuild: configured " .. build_type, vim.log.levels.INFO)
        else
            vim.notify("cppbuild: configure failed\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
        end
    end)
end

-- cmake --build build. on_success is called only when the build succeeded.
function M.build(on_success)
    local root = project_root()

    if vim.fn.isdirectory(build_path(root)) == 0 then
        vim.notify("cppbuild: no build directory, run configure first", vim.log.levels.ERROR)
        return
    end

    run({ "cmake", "--build", BUILD_DIR }, root, "build", function(code, output)
        local count = to_quickfix(output, "cppbuild")

        if code == 0 then
            if count > 0 then
                vim.notify("cppbuild: built with " .. count .. " warning(s)", vim.log.levels.WARN)
            else
                vim.notify("cppbuild: build ok", vim.log.levels.INFO)
            end
            if on_success then
                on_success(root)
            end
        else
            vim.notify("cppbuild: build failed (" .. count .. " entries)", vim.log.levels.ERROR)
            if count > 0 then
                vim.cmd("copen")
            else
                vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
            end
        end
    end)
end

-- Running the binary is deliberately not done here. Build in the editor so
-- errors land in quickfix, then run it from a normal terminal:
--   cmake --build build && ./build/<name>

-- ctest --test-dir build --output-on-failure
function M.test()
    local root = project_root()

    if vim.fn.isdirectory(build_path(root)) == 0 then
        vim.notify("cppbuild: no build directory, run configure first", vim.log.levels.ERROR)
        return
    end

    local cmd = { "ctest", "--test-dir", BUILD_DIR, "--output-on-failure" }

    run(cmd, root, "ctest", function(code, output)
        if code == 0 then
            vim.notify("cppbuild: tests passed", vim.log.levels.INFO)
            vim.fn.setqflist({}, " ", { title = "cppbuild tests", items = {} })
        else
            local count = to_quickfix(output, "cppbuild tests")
            vim.notify("cppbuild: tests failed", vim.log.levels.ERROR)
            if count > 0 then
                vim.cmd("copen")
            else
                vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
            end
        end
    end)
end

-- Copy any missing template files (.clang-format, .clang-tidy, .clangd,
-- CMakeLists.txt) from the config repo into the project root. lang picks the
-- template set: "c" or "cpp". They are separate because CMakeLists.txt and
-- .clang-tidy differ between the two languages.
function M.init_project(lang)
    local root = vim.fn.getcwd()
    local templates = vim.fn.stdpath("config") .. "/templates/" .. lang
    local copied, skipped = {}, {}

    for _, name in ipairs({ ".clang-format", ".clang-tidy", ".clangd", "CMakeLists.txt" }) do
        local dest = root .. "/" .. name
        if vim.fn.filereadable(dest) == 1 then
            table.insert(skipped, name)
        else
            local src = templates .. "/" .. name
            if vim.fn.filereadable(src) == 1 then
                vim.fn.writefile(vim.fn.readfile(src), dest)
                table.insert(copied, name)
            end
        end
    end

    local msg = {}
    if #copied > 0 then
        table.insert(msg, "created " .. table.concat(copied, ", "))
    end
    if #skipped > 0 then
        table.insert(msg, "kept existing " .. table.concat(skipped, ", "))
    end
    vim.notify("cppbuild: " .. table.concat(msg, "; "), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("CInit", function()
    M.init_project("c")
end, {
    desc = "Copy C project templates into the current directory",
})

vim.api.nvim_create_user_command("CppInit", function()
    M.init_project("cpp")
end, {
    desc = "Copy C++ project templates into the current directory",
})

vim.api.nvim_create_user_command("CppConfigure", M.configure, {
    desc = "Run cmake to configure the build directory",
})

vim.api.nvim_create_user_command("CppBuild", function()
    M.build()
end, {
    desc = "Build the CMake project, errors to quickfix",
})

vim.api.nvim_create_user_command("CppTest", M.test, {
    desc = "Run ctest for the CMake project",
})

return M
