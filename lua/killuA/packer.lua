-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        -- or                            , branch = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    -- use {
    --     'nvim-flutter/flutter-tools.nvim',
    --     requires = {
    --         -- 'nvim-lua/plenary.nvim',
    --         'stevearc/dressing.nvim', -- optional for vim.ui.select
    --     },
    -- }
    use({
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    -- use('nvim-treesitter/playground')
    -- use('theprimeagen/harpoon')
    use('mbbill/undotree')
    -- use('tpope/vim-fugitive')
    -- use {
    --     'tpope/vim-surround'
    -- }
    -- use {'EmranMR/tree-sitter-blade'}
    use({
        "Exafunction/codeium.vim"
    })
    -- use({
    --     "stevearc/conform.nvim",
    --     config = function()
    --         require("conform").setup()
    --     end,
    -- })
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment the two plugins below if you want to manage the language servers from neovim
            { 'mason-org/mason.nvim' },
            { 'mason-org/mason-lspconfig.nvim' },

            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }
    -- use "~/config/nvim/pack/ai_plugin/start/nvim-ai-autocomplete"
    use({
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require('render-markdown').setup({})
        end,
    })
end)
