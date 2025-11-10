require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'gopls',           -- Go
        'ts_ls',           -- JavaScript/TypeScript
        'pylsp',           -- Python
        'cssls',           -- CSS
        'html',            -- HTML
        'angularls',       -- Angular
        'omnisharp',       -- C#
        'erlangls',        -- Erlang
    },
    automatic_installation = true,
	automatic_setup = false,
})
