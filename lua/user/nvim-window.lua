local M = {}

local float_height = 3
local float_width = 6
local escape = 27

local config = {
    chars = {
        '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
        'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    },
    render = 'float',
    hint_hl = 'Bold',
    border = 'single',
    normal_hl = 'Normal',
}

local hints = {}
local function window_keys(windows)
    local nrs = {}
    local ids = {}
    local mapping = {}
    local chars = config.chars
    local current = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())

    for _, win in ipairs(windows) do
        local nr = vim.api.nvim_win_get_number(win)
        table.insert(nrs, nr)
        ids[nr] = win
    end

    table.sort(nrs)
    local index = 1
    for _, nr in ipairs(nrs) do
        if nr ~= current then
            local key = chars[index]
            if mapping[key] then
                key = key .. (index == #chars and chars[1] or chars[index + 1])
            end
            mapping[key] = ids[nr]
        end
        index = index == #chars and 1 or index + 1
    end
    return mapping
end

-- Opens all the floating windows in (roughly) the middle of every window.
local function open_floats(mapping)
    local floats = {}
    for key, window in pairs(mapping) do
        local bufnr = vim.api.nvim_create_buf(false, true)
        if bufnr > 0 then
            local win_width = vim.api.nvim_win_get_width(window)
            local win_height = vim.api.nvim_win_get_height(window)
            local row = math.max(0, math.floor((win_height / 2) - 1))
            local col = math.max(0, math.floor((win_width / 2) - float_width))
            vim.api.nvim_buf_set_lines( bufnr, 0, -1, true, { '', '  ' .. key .. '  ', '' })
            vim.api.nvim_buf_add_highlight(bufnr, 0, config.hint_hl, 1, 0, -1)
            local float_window = vim.api.nvim_open_win(bufnr, false, {
                relative = 'win',
                win = window,
                row = row,
                col = col,
                width = #key == 1 and float_width - 1 or float_width,
                height = float_height,
                focusable = false,
                style = 'minimal',
                border = config.border,
                noautocmd = true,
            })

            vim.api.nvim_set_option_value( 'winhl', 'Normal:' .. config.normal_hl, { win = float_window })
            vim.api.nvim_set_option_value('diff', false, { win = float_window })
            floats[float_window] = bufnr
        end
    end
    vim.cmd('redraw')
    return floats
end

local function close_floats(floats)
    for window, bufnr in pairs(floats) do
        vim.api.nvim_win_close(window, true)
        vim.api.nvim_buf_delete(bufnr, { force = true })
    end
end

local function get_char()
    local ok, char = pcall(vim.fn.getchar)
    return ok and vim.fn.nr2char(char) or nil
end

local function show_hints(keys, redraw)
    if config.render == 'status' then
        for key, win in pairs(keys) do
            hints[win] = key
        end
        if redraw then
            vim.cmd('redrawstatus!')
        end
    else
        return open_floats(keys)
    end
end

local function hide_hints(state, redraw)
    if config.render == 'status' then
        hints = {}
        if redraw then
            vim.cmd('redrawstatus!')
        end
    else
        close_floats(state)
    end
end

function M.hint(window)
    return hints[window]
end

function M.setup(user_config)
    config = vim.tbl_extend('force', config, user_config)
end

function M.pick()
    local windows = vim.tbl_filter(function(id)
        return vim.api.nvim_win_get_config(id).relative == ''
    end, vim.api.nvim_tabpage_list_wins(0))

    local window_keys = window_keys(windows)
    local hints_state = show_hints(window_keys, true)
    local key = get_char()
    local window = nil
    if not key or key == escape then
        hide_hints(hints_state, true)
        return
    end

    local window = window_keys[key]
    local extra = {}
    local choices = 0
    for hint, win in pairs(window_keys) do
        if vim.startswith(hint, key) then
            extra[hint] = win
            choices = choices + 1
        end
    end

    if choices > 1 then
        hide_hints(hints_state, false)
        hints_state = show_hints(extra, true)
        local second = get_char()
        if second then
            local combined = key .. second
            window = window_keys[combined] or window_keys[key]
        else
            window = nil
        end
    end

    hide_hints(hints_state, true)
    if window then
        vim.api.nvim_set_current_win(window)
    end
end

return M
