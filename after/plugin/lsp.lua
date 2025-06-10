local lsp_zero = require('lsp-zero')
require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { 'jsonls', 'ts_ls', 'eslint', 'lua_ls', 'html', 'tailwindcss',
        'intelephense' },
    -- automatic_enable=true,
    automatic_enable = {
        "ts_ls",
        "lua_ls",
        "eslint",
        "tailwindcss",
        "jsonls",
        "intelephense"
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        ts_ls = function()
            require('lspconfig').ts_ls.setup({

                -- BALANCED MEMORY SETTINGS:
                init_options = {
                    maxTsServerMemory = 2048,                         -- Balanced limit for 8GB RAM
                    preferences = {
                        disableSuggestions = false,                   -- KEEP enabled for autocomplete
                        includeCompletionsForModuleExports = true,    -- KEEP for auto-imports
                        includeCompletionsForImportStatements = true, -- ENABLE auto-imports
                        includeAutomaticOptionalChainCompletions = true,
                    },
                },

                -- BALANCED SETTINGS - Keep essential features:
                settings = {
                    typescript = {
                        -- DISABLE heavy inlay hints but keep some useful ones:
                        inlayHints = {
                            includeInlayParameterNameHints = 'none',          -- Disable parameter hints
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = false,   -- Disable to save memory
                            includeInlayVariableTypeHints = false,            -- Disable to save memory
                            includeInlayPropertyDeclarationTypeHints = false, -- Disable to save memory
                            includeInlayFunctionLikeReturnTypeHints = false,  -- Disable to save memory
                            includeInlayEnumMemberValueHints = true,          -- KEEP this one - it's useful and lightweight
                        },
                        preferences = {
                            disableSuggestions = false,                   -- KEEP enabled for autocomplete
                            includeCompletionsWithSnippetText = true,     -- KEEP for better completions
                            includeCompletionsForImportStatements = true, -- ESSENTIAL for auto-imports
                        },
                        suggest = {
                            includeCompletionsForModuleExports = true, -- ESSENTIAL for auto-imports
                            includeAutomaticOptionalChainCompletions = true,
                            includeCompletionsWithInsertText = true,
                            autoImports = true, -- ESSENTIAL for auto-imports
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'none',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = false,
                            includeInlayVariableTypeHints = false,
                            includeInlayPropertyDeclarationTypeHints = false,
                            includeInlayFunctionLikeReturnTypeHints = false,
                            includeInlayEnumMemberValueHints = true, -- Keep this lightweight feature
                        },
                        suggest = {
                            autoImports = true, -- ESSENTIAL for auto-imports
                        },
                    },
                },

                -- MODERATE debounce time:
                flags = {
                    debounce_text_changes = 750, -- Balanced - not too slow, not too fast
                },

                -- BALANCED on_attach:
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    -- Keep semantic tokens for better highlighting (but disable if still too slow)
                    -- client.server_capabilities.semanticTokensProvider = nil
                    client.server_capabilities.documentHighlightProvider = false -- Disable this heavy feature
                end,
            })
        end,
        -- Optimized ESLint configuration
        eslint = function()
            require('lspconfig').eslint.setup({
                -- ... your existing config ...

                settings = {
                    -- BALANCED settings:
                    format = false, -- Keep disabled to save memory
                    quiet = false,  -- KEEP enabled to see warnings (they're useful)
                    run = "onSave", -- Run on save instead of onType for better performance

                    -- KEEP useful code actions:
                    codeAction = {
                        disableRuleComment = {
                            enable = true,
                            location = "separateLine"
                        },
                        showDocumentation = {
                            enable = true -- KEEP enabled - it's useful and not memory-heavy
                        }
                    },
                    codeActionOnSave = {
                        enable = true,    -- ENABLE for auto-fixing on save
                        mode = "problems" -- Only fix actual problems, not style issues
                    },
                    -- ... rest of your settings unchanged ...
                },

                -- MODERATE debounce time:
                flags = {
                    debounce_text_changes = 1500, -- Balanced - not too slow for feedback
                },
            })
        end,
        -- Tailwind CSS configuration
        tailwindcss = function()
            require('lspconfig').tailwindcss.setup({
                -- ... your existing config ...

                settings = {
                    tailwindCSS = {
                        classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
                        lint = {
                            -- DISABLE heavy linting but keep critical errors:
                            cssConflict = "ignore",             -- Disable - not critical
                            invalidApply = "error",             -- KEEP - this is important
                            invalidConfigPath = "error",        -- KEEP - this is important
                            invalidScreen = "ignore",           -- Disable - not critical
                            invalidTailwindDirective = "error", -- KEEP - this is important
                            invalidVariant = "ignore",          -- Disable - not critical
                            recommendedVariantOrder = "ignore"  -- Disable - just style preference
                        },
                        validate = true,                        -- KEEP enabled for completions and basic validation
                        completions = {
                            includeConfig = true,               -- KEEP for custom config completions
                            includeVariants = true,             -- KEEP for variant completions
                        }
                    }
                },

                -- MODERATE debounce time:
                flags = {
                    debounce_text_changes = 800, -- Balanced for CSS completions
                },
            })
        end,
        -- Lua language server configuration
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME,
                            }
                        }
                    }
                },
                flags = {
                    debounce_text_changes = 500,
                },
            })
        end,

    },

    flags = {
        debounce_text_changes = 500, -- wait 500 ms between change events
    },
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
lsp_zero.defaults.cmp_mappings({
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
})

cmp.setup({
    performance = {
        fetching_timeout = 500, -- Reduce timeout for faster response
        max_view_entries = 8,   -- Limit displayed entries
    },
})
lsp_zero.set_preferences({
    sign_icons = {}
})

lsp_zero.on_attach(function(_, bufnr)
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
