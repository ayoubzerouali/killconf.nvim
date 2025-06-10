-- -- Aggressive memory management settings
-- vim.g.loaded_python3_provider = 0
-- vim.g.loaded_ruby_provider = 0
-- vim.g.loaded_perl_provider = 0
-- vim.g.loaded_node_provider = 0
--
-- -- Limit LSP memory usage
-- vim.lsp.set_log_level("ERROR") -- Reduce logging
--
-- -- Optimize diagnostics for memory
-- vim.diagnostic.config({
--     virtual_text = false, -- Disable virtual text completely
--     signs = false,      -- Disable signs
--     underline = false,  -- Disable underline
--     update_in_insert = false,
--     severity_sort = true,
--     float = {
--         focusable = false,
--         style = "minimal",
--         border = "rounded",
--         source = "if_many",
--         header = "",
--         prefix = "",
--         max_width = 80,
--         max_height = 20,
--     },
-- })
--
-- -- Reduce Neovim's own memory usage
-- vim.opt.updatetime = 1000 -- Increase update time
-- vim.opt.timeoutlen = 500
-- vim.opt.ttimeoutlen = 10
-- vim.opt.lazyredraw = true -- Don't redraw during macros
-- vim.opt.ttyfast = true
-- vim.opt.hidden = true
-- vim.opt.backup = false
-- vim.opt.writebackup = false
-- vim.opt.swapfile = false
-- vim.opt.undofile = false -- Disable undo file to save memory
--
-- -- Limit completion and other memory-intensive features
-- vim.opt.completeopt = { 'menu', 'noselect' } -- Remove 'menuone' and 'preview'
-- vim.opt.pumheight = 10                     -- Limit popup menu height
--
-- -- Memory cleanup autocmd
-- vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
--     callback = function()
--         if vim.fn.mode() == 'i' then
--             return
--         end
--         -- Force garbage collection
--         collectgarbage("collect")
--     end,
-- })
--
-- -- Periodic memory cleanup
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         collectgarbage("collect")
--     end,
-- })
--
-- -- LSP restart command for memory cleanup
-- vim.api.nvim_create_user_command('LspRestart', function()
--     vim.cmd('LspStop')
--     vim.defer_fn(function()
--         vim.cmd('LspStart')
--     end, 1000)
-- end, {})
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        severity = vim.diagnostic.severity.ERROR, -- Only show errors in virtual text
    },
    signs = {
        active = signs,
    },
    update_in_insert = false, -- Don't update diagnostics in insert mode
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "if_many", -- Show source only when there are multiple
        header = "",
        prefix = "",
        max_width = 80,  -- Limit popup width
        max_height = 15, -- Limit popup height
    },
})
-- ADD these memory management settings:
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Set reasonable LSP log level:
vim.lsp.set_log_level("WARN") -- Show warnings but not debug info

-- ADD LSP restart command:
vim.api.nvim_create_user_command('LspRestart', function()
    vim.cmd('LspStop')
    vim.defer_fn(function() vim.cmd('LspStart') end, 1000)
end, {})

-- MEMORY CLEANUP (less aggressive):
vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
        collectgarbage("collect") -- Only cleanup after saving files
    end,
})
