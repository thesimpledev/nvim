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
    elseif vim.fn['vsnip#jumpable'](1) == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-next)', true, true, true), '')
    else
        local tabout = require('tabout')
        if not tabout.tabout() then
            fallback()
        end
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
