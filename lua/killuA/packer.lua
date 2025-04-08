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

    use {
        'nvim-flutter/flutter-tools.nvim',
        requires = {
            -- 'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
    }
    use({
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground')
    -- use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use { 'EmranMR/tree-sitter-blade' }
    -- use('tpope/vim-fugitive')
    -- use {
    --     'tpope/vim-surround'
    -- }
    -- use { 'codota/tabnine-nvim', run = "./dl_binaries.sh" }
    -- use {'EmranMR/tree-sitter-blade'}
    use({
        "Exafunction/codeium.vim"
    })
    use({
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup()
        end,
    })
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment the two plugins below if you want to manage the language servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }
    -- use "~/config/nvim/pack/ai_plugin/start/nvim-ai-autocomplete"
end)
