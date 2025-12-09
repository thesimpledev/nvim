require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'gopls',           -- Go
        'ts_ls',           -- JavaScript/TypeScript
        'cssls',           -- CSS
        'html',            -- HTML
        'zls',             -- Zig
    },
    automatic_installation = true,
	automatic_setup = false,
})
