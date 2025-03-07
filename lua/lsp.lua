local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
}


for server, config in pairs(servers) do
	config.capabilities = capabilities
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

--Test to add in live error checking with a debounce of 200ms
local diagnostic_timer = nil

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    pattern = "*.go",
    callback = function()
        if diagnostic_timer then
            vim.fn.timer_stop(diagnostic_timer)
        end

        diagnostic_timer = vim.fn.timer_start(200, function()
            vim.diagnostic.reset(nil, 0)
            vim.lsp.buf.hover()
        end)
    end,
})

-- Configure diagnostic settings
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",  -- Customize prefix; can be empty to avoid clutter
        source = "always",  -- Show diagnostic source (e.g., "gopls", "ts_ls")
    },
    signs = true,  -- Show signs in the gutter
    underline = true,  -- Underline diagnostic text
    update_in_insert = true,  -- diagnostics updates in insert mode
    severity_sort = true,  -- Sort diagnostics by severity
    float = {
        show_header = true,  -- Show header in floating diagnostics
        source = "always",  -- Show diagnostic source in floating windows
        border = "rounded",  -- Rounded borders for floating windows
    },
})
