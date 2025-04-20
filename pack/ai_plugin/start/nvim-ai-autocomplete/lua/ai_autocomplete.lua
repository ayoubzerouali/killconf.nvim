local M = {}

-- Configuration
local config = {
    url = "http://localhost:8081/ai-suggest",
    debounce_ms = 200,
    suggestion_ns_id = vim.api.nvim_create_namespace("ai_suggestion_namespace"),
    enabled = true
}

-- Utility to escape JSON string
local function escape_json(s)
    local escaped = string.gsub(s, '(["\\\n\r\t])', function(c)
        if c == '"' then
            return '\\"'
        elseif c == '\\' then
            return '\\\\'
        elseif c == '\n' then
            return '\\n'
        elseif c == '\r' then
            return '\\r'
        elseif c == '\t' then
            return '\\t'
        end
    end)
    return escaped
end

-- Get current buffer text
local function get_current_buffer_text()
    return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
end

-- Get text up to current cursor position
local function get_text_up_to_cursor()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line_num, col_num = cursor[1], cursor[2]

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_num, false)
    local text = table.concat(lines, "\n")

    -- Truncate last line to cursor position
    local last_line = lines[#lines]
    text = string.sub(text, 1, #text - #last_line + col_num)

    return text
end

-- Fetch AI suggestion from API
local function fetch_ai_suggestion(callback)
    local curl = require("plenary.curl")
    local current_text = get_current_buffer_text()
    local cursor_text = get_text_up_to_cursor()

    local request_body = string.format(
        '{"code": "%s", "prefix": "%s"}',
        escape_json(current_text),
        escape_json(cursor_text)
    )

    curl.post(config.url, {
        body = request_body,
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#request_body)
        },
        callback = function(response)
            if response.status == 200 and response.body then
                callback(response.body)
            else
                callback(nil)
            end
        end
    })
end

-- Clear existing suggestion
local function clear_suggestion()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, config.suggestion_ns_id, 0, -1)
end

-- Display suggestion in light gray next to cursor
local function display_suggestion(suggestion)
    if not suggestion or suggestion == "" then
        clear_suggestion()
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1] - 1, cursor[2]

    -- Clear previous suggestions
    clear_suggestion()

    -- Add the suggestion as virtual text
    vim.api.nvim_buf_set_extmark(
        bufnr,
        config.suggestion_ns_id,
        row,
        col,
        {
            virt_text = { { suggestion, "Comment" } },
            virt_text_pos = "inline"
        }
    )
end

-- Accept the current suggestion
function M.accept_suggestion()
    local bufnr = vim.api.nvim_get_current_buf()
    local marks = vim.api.nvim_buf_get_extmarks(bufnr, config.suggestion_ns_id, 0, -1, {})

    for _, mark in ipairs(marks) do
        local mark_id, row, col = unpack(mark)
        local details = vim.api.nvim_buf_get_extmark_by_id(bufnr, config.suggestion_ns_id, mark_id, { details = true })

        if details and details.virt_text then
            local suggestion = details.virt_text[1][1]

            -- Get current line
            local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]

            -- Insert suggestion at cursor position
            local new_line = string.sub(line, 1, col) .. suggestion
            vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { new_line })

            -- Move cursor to end of inserted text
            vim.api.nvim_win_set_cursor(0, { row + 1, col + #suggestion })

            -- Clear suggestion after accepting it
            clear_suggestion()
            break
        end
    end
end

-- Debounce utility function
local debounce_timer = nil
local function debounced(func, delay)
    return function(...)
        local args = { ... }
        if debounce_timer then
            vim.fn.timer_stop(debounce_timer)
        end
        debounce_timer = vim.fn.timer_start(delay, function()
            func(unpack(args))
        end)
    end
end

-- Main function to request and display suggestions
local function request_suggestion()
    if not config.enabled then return end

    -- Don't request suggestions in certain modes
    local mode = vim.api.nvim_get_mode().mode
    if mode ~= "i" and mode ~= "n" then
        clear_suggestion()
        return
    end

    fetch_ai_suggestion(function(suggestion)
        -- Only show suggestion in insert mode
        if vim.api.nvim_get_mode().mode == "i" then
            display_suggestion(suggestion)
        else
            clear_suggestion()
        end
    end)
end

-- Debounced version of request_suggestion
local request_suggestion_debounced = debounced(request_suggestion, config.debounce_ms)

-- Setup function
function M.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})

    -- Register autocmds
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function()
            -- Initial scan when opening a file
            request_suggestion()
        end
    })

    vim.api.nvim_create_autocmd({ "TextChangedI", "CursorMovedI" }, {
        callback = function()
            -- Request suggestions when typing or moving cursor in insert mode
            request_suggestion_debounced()
        end
    })

    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        callback = function()
            -- Clear suggestions when leaving insert mode
            clear_suggestion()
        end
    })

    -- Set up keybindings
    vim.keymap.set("i", "<Tab>", function()
        -- Check if there's a suggestion to accept
        local bufnr = vim.api.nvim_get_current_buf()
        local marks = vim.api.nvim_buf_get_extmarks(bufnr, config.suggestion_ns_id, 0, -1, {})

        if #marks > 0 then
            M.accept_suggestion()
        else
            -- If no suggestion, pass through to normal Tab behavior
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
        end
    end, { noremap = true, silent = true })

    -- Toggle function
    function M.toggle()
        config.enabled = not config.enabled
        if not config.enabled then
            clear_suggestion()
            print("AI suggestions disabled")
        else
            print("AI suggestions enabled")
            request_suggestion()
        end
    end

    -- Command to toggle suggestions
    vim.api.nvim_create_user_command("AISuggestToggle", function()
        M.toggle()
    end, {})
end

return M

