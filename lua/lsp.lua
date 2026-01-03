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

-- Erlang Configuration
vim.lsp.config('erlangls', {
    capabilities = capabilities,
    cmd = { "erlang_ls" },
    root_dir = vim.fs.root(0, {"rebar.config", "erlang.mk", ".git"}),
    settings = {
        erlangls = {}
    }
})

vim.lsp.enable('erlangls')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.erl", "*.hrl"},
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
    on_attach = function(client, bufnr)
        require('nvim-lsp-ts-utils').setup {}
        require('nvim-lsp-ts-utils').setup_client(client)
    end,
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
        "--function-arg-placeholders",
    },
    init_options = {
        clangdFileStatus = true,
    },
})

vim.lsp.enable('clangd')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.c", "*.h", "*.cpp", "*.hpp"},
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
