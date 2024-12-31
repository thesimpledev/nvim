local lspconfig = require('lspconfig')

local servers = {
    gopls = {
		gofumpt = true,
		staticcheck = true,
		analyses = {
			unusedparams = true
		},
		experimentalPostfixCompletions = true,
		experimentalWorkspaceModule = true,
    },                 -- Go
	rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    }, -- Rust
    ts_ls = {
        settings = {
			javascript = {
				inlayHints = { includeInlayParameterNameHints = 'all' },
			},
            completions = {
                completeFunctionCalls = true,
            },
        },
    }, -- JavaScript/TypeScript
    pylsp = {
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
    }, -- Python
    intelephense = {}, -- PHP
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp = require('cmp_nvim_lsp')
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

for server, config in pairs(servers) do
    lspconfig[server].setup(config)
end


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

-- Rust
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- TypeScript/JavaScript
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ts", "*.js" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Python
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- PHP
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.php",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
