local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users
        end,
    },

mapping = cmp.mapping.preset.insert({
['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
		cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
    else
        fallback()
    end
end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
}),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    })
}

-- Integrate autopairs with cmp
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
