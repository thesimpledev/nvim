local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Go Configuration
lspconfig.gopls.setup {
    capabilities = capabilities,
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true },
            experimentalPostfixCompletions = true,
        },
    },
}

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

-- JavaScript/TypeScript Configuration
lspconfig.ts_ls.setup {
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
}

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.js", "*.ts", "*.jsx", "*.tsx"},
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Python Configuration
lspconfig.pylsp.setup {
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
}

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- CSS, HTML, Angular Configuration
lspconfig.cssls.setup { capabilities = capabilities }
lspconfig.html.setup { capabilities = capabilities }
lspconfig.angularls.setup {
    capabilities = capabilities,
    cmd = {
        "ngserver",
        "--stdio",
    },
    root_dir = lspconfig.util.root_pattern("angular.json", "project.json"),
}

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.html", "*.css"},
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
    update_in_insert = false,  -- Changed from true to false
    severity_sort = true,
})
