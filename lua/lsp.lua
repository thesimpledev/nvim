local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Go Configuration
vim.lsp.config('gopls', {
    capabilities = capabilities,
    root_dir = vim.fs.root(0, {"go.mod", ".git"}),
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true },
            experimentalPostfixCompletions = true,
            buildFlags = {"-tags=exclude_tests"},
        },
    },
})

vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format({ async = false })
        vim.lsp.buf.code_action({
            filter = function(code_action)
                return code_action.kind == "source.organizeImports"
            end,
            apply = true,
        })
    end,
})

-- C# Configuration
vim.lsp.config('omnisharp', {
    capabilities = capabilities,
    cmd = { 
        "omnisharp", 
        "--languageserver",
        "--stdio"
    },
    root_dir = vim.fs.root(0, {"*.csproj", "*.sln", ".git"}),
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
        },
        RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
    end,
    flags = {
        debounce_text_changes = 150,
    },
})

vim.lsp.enable('omnisharp')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.cs",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Elixir Configuration
vim.lsp.config('elixirls', {
    capabilities = capabilities,
    cmd = { "elixir-ls" },
    root_dir = vim.fs.root(0, {"mix.exs", ".git"}),
    settings = {
        elixirLS = {
            dialyzerEnabled = true,
            fetchDeps = false,
            enableTestLenses = true,
            suggestSpecs = true,
        },
    },
})

vim.lsp.enable('elixirls')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.ex", "*.exs", "*.heex"},
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- JavaScript/TypeScript Configuration
vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    settings = {
        javascript = {
            inlayHints = { includeInlayParameterNameHints = 'all' },
            completions = { completeFunctionCalls = true },
        },
    },
})

vim.lsp.enable('ts_ls')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.js", "*.ts", "*.jsx", "*.tsx"},
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Python Configuration
vim.lsp.config('pylsp', {
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = true },
                pyflakes = { enabled = true },
                pylint = { enabled = false },
                pylsp_mypy = { enabled = true },
            },
        },
    },
})

vim.lsp.enable('pylsp')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- CSS Configuration
vim.lsp.config('cssls', {
    capabilities = capabilities
})

vim.lsp.enable('cssls')

-- HTML Configuration
vim.lsp.config('html', {
    capabilities = capabilities
})

vim.lsp.enable('html')

-- Angular Configuration
vim.lsp.config('angularls', {
    capabilities = capabilities,
    cmd = {
        "ngserver",
        "--stdio",
    },
    root_dir = vim.fs.root(0, {"angular.json", "project.json"}),
})

vim.lsp.enable('angularls')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.html", "*.css"},
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- C/C++ Configuration
vim.lsp.config('clangd', {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        -- clangd 22 rejects this as a bare flag: it needs the value, and
        -- without it clangd exits 1 and no C++ LSP starts at all.
        "--function-arg-placeholders=1",
    },
    init_options = {
        clangdFileStatus = true,
    },
    -- Resolved per buffer, unlike the root_dir = vim.fs.root(0, ...) used
    -- above, which is evaluated once against whatever buffer happens to be
    -- current while this file is being read.
    root_markers = { ".clangd", "compile_commands.json", "CMakeLists.txt", ".git" },
})

vim.lsp.enable('clangd')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.c", "*.h", "*.cpp", "*.hpp", "*.cc", "*.cxx", "*.hh", "*.hxx"},
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Zig Configuration
vim.lsp.config('zls', {
    capabilities = capabilities,
    root_dir = vim.fs.root(0, {"build.zig", "build.zig.zon", ".git"}),
    settings = {
        zls = {
            enable_autofix = true,
            enable_snippets = true,
            enable_inlay_hints = true,
            warn_style = true,
            highlight_global_var_declarations = true,
            enable_build_on_save = false,
            enable_semantic_tokens = true,
        },
    },
})

vim.lsp.enable('zls')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.zig",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- OCaml Configuration
-- vim.lsp.config('ocamllsp', {
--     capabilities = capabilities,
--     root_dir = vim.fs.root(0, {"dune-project", "dune-workspace", ".opam", ".git"}),
--     settings = {
--         codelens = { enable = true },
--     },
-- })
--
-- vim.lsp.enable('ocamllsp')
--
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = {"*.ml", "*.mli"},
--     callback = function()
--         vim.lsp.buf.format({ async = false })
--     end,
-- })

-- GDScript Configuration (Godot 4)
vim.lsp.config('gdscript', {
    capabilities = capabilities,
    cmd = { "ncat", "localhost", "6005" },
    root_dir = vim.fs.root(0, {"project.godot", ".git"}),
})

vim.lsp.enable('gdscript')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.gd",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Lua Configuration (LÖVE / Love2D + Neovim)
local function start_lua_ls()
    vim.lsp.start({
        name = "lua_ls",
        cmd = { "/home/thesimpledev/.local/share/nvim/mason/bin/lua-language-server" },
        root_dir = vim.fs.root(0, {".luarc.json", ".luarc.jsonc", ".git"}) or vim.fn.getcwd(),
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "love", "vim" },
                },
                workspace = {
                    checkThirdParty = true,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = start_lua_ls,
})

-- Start for any lua buffers already open at init time
if vim.bo.filetype == "lua" then
    start_lua_ls()
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.lua",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Diagnostic Configuration
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        source = "always",
    },
    signs = true,
    float = {
        border = "rounded",
        source = "always",
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Auto-run Go tests on save
local gotest = require('gotest')

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.go",
    callback = function()
        gotest.run_tests_for_file()
    end,
})
