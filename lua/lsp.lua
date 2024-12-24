local lspconfig = require('lspconfig')

local servers = {
    gopls = {
	gofumpt = true,
	staticcheck = true,
	analyses = {
		unusedparams = true
	},
	experimentalPostfixCompletions = true,
    },                 -- Go
    rust_analyzer = {},         -- Rust
    ts_ls = {},                 -- JavaScript/TypeScript
    pylsp = {},                 -- Python
    solargraph = {},            -- Ruby
}

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

