local lsp_zero = require('lsp-zero')
require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { 'eslint', 'jsonls', 'html', 'intelephense', 'tailwindcss' },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        intelephense = function()
            require('lspconfig').intelephense.setup({
                filetypes = { 'php', 'blade', 'blade.php' }
            })
        end,
    }
})
--
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
lsp_zero.defaults.cmp_mappings({
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
})
lsp_zero.set_preferences({
    sign_icons = {}
})
-- local cmp_action = require('lsp-zero').cmp_action()
--
-- cmp.setup({
--   mapping = cmp.mapping.preset.insert({
--     -- `Enter` key to confirm completion
--     ['<C-y>'] = cmp.mapping.confirm({select = true}),
--
--     -- Ctrl+Space to trigger completion menu
--     ['<C-Space>'] = cmp.mapping.complete(),
--
--     -- Navigate between snippet placeholder
--     -- ['<C-n>'] = cmp_action.luasnip_jump_forward(),
--     -- ['<C-p>'] = cmp_action.luasnip_jump_backward(),
--
--     -- Scroll up and down in the completion documentation
--     -- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--     -- ['<C-d>'] = cmp.mapping.scroll_docs(4),
--   }),
--   snippet = {
--     expand = function(args)
--       require('luasnip').lsp_expand(args.body)
--     end,
--   },
-- })
--
lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.lsp.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)
lsp_zero.setup()
