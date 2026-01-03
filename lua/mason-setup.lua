require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'gopls',           -- Go
        'ts_ls',           -- JavaScript/TypeScript
        'cssls',           -- CSS
        'html',            -- HTML
        'zls',             -- Zig
        'elixirls',        -- Elixir
        'ocamllsp',        -- OCaml
    },
    automatic_installation = true,
	automatic_setup = false,
})
