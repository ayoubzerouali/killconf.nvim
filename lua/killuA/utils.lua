-- Helper command for find and replace
vim.api.nvim_create_user_command('Rp', function()
    local find = vim.fn.input("Find: ")
    local replace = vim.fn.input("Replace with: ")
    if find ~= "" and replace ~= "" then
        vim.cmd(string.format("%%s/%s/%s/gc", vim.pesc(find), replace))
    end
end, {})

vim.api.nvim_create_user_command('Vimreg', function()
    vim.cmd('help regmap')
end, {})

-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'tsx',
--     callback = function()
--         -- JSX/TSX uses block comments
--         vim.bo.commentstring = '{/* %s */}'
--     end
-- })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'vue',
    callback = function()
        -- Vue single-file components use HTML-style comments
        vim.bo.commentstring = '<!-- %s -->'
    end
})
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.dart",
    callback = function()
        -- Run tmux command to get FP value
        local target = vim.fn.system("tmux showenv | grep ^FP= | cut -d= -f2")

        -- Trim the output to remove leading/trailing whitespace or newlines
        target = target:gsub("^%s*(.-)%s*$", "%1")

        -- print("Target pane: " .. target)

        -- Send the 'r' key to the tmux target
        vim.fn.system("tmux send-keys -t " .. target .. " r")
    end
})
vim.api.nvim_create_user_command('Koko', function()
    local target = vim.fn.system("tmux showenv | grep ^FP= | cut -d= -f2")

    -- Trim the output to remove leading/trailing whitespace or newlines
    target = target:gsub("^%s*(.-)%s*$", "%1")
    vim.fn.system("tmux send-keys -t 1 R")
end, {})
