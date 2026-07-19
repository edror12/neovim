-- Config nvim's status line
-- Use a global status line
vim.o.laststatus = 3
vim.o.statusline = "%!v:lua.require('user.statusline')()"

local separators = { left = "", right = "" }
local modes = {
    ["n"] = { "NORMAL", "Normal" },
    ["no"] = { "NORMAL (no)", "Normal" },
    ["nov"] = { "NORMAL (nov)", "Normal" },
    ["noV"] = { "NORMAL (noV)", "Normal" },
    ["noCTRL-V"] = { "NORMAL", "Normal" },
    ["niI"] = { "NORMAL i", "Normal" },
    ["niR"] = { "NORMAL r", "Normal" },
    ["niV"] = { "NORMAL v", "Normal" },
    ["nt"] = { "NTERMINAL", "NTerminal" },
    ["ntT"] = { "NTERMINAL (ntT)", "NTerminal" },

    ["v"] = { "VISUAL", "Visual" },
    ["vs"] = { "V-CHAR (Ctrl O)", "Visual" },
    ["V"] = { "V-LINE", "Visual" },
    ["Vs"] = { "V-LINE", "Visual" },
    [""] = { "V-BLOCK", "Visual" },

    ["i"] = { "INSERT", "Insert" },
    ["ic"] = { "INSERT (completion)", "Insert" },
    ["ix"] = { "INSERT completion", "Insert" },

    ["t"] = { "TERMINAL", "Terminal" },

    ["R"] = { "REPLACE", "Replace" },
    ["Rc"] = { "REPLACE (Rc)", "Replace" },
    ["Rx"] = { "REPLACEa (Rx)", "Replace" },
    ["Rv"] = { "V-REPLACE", "Replace" },
    ["Rvc"] = { "V-REPLACE (Rvc)", "Replace" },
    ["Rvx"] = { "V-REPLACE (Rvx)", "Replace" },

    ["s"] = { "SELECT", "Select" },
    ["S"] = { "S-LINE", "Select" },
    [""] = { "S-BLOCK", "Select" },
    ["c"] = { "COMMAND", "Command" },
    ["cv"] = { "COMMAND", "Command" },
    ["ce"] = { "COMMAND", "Command" },
    ["cr"] = { "COMMAND", "Command" },
    ["r"] = { "PROMPT", "Confirm" },
    ["rm"] = { "MORE", "Confirm" },
    ["r?"] = { "CONFIRM", "Confirm" },
    ["x"] = { "CONFIRM", "Confirm" },
    ["!"] = { "SHELL", "Terminal" },
}

local function construct_file()
    return "%#StatusLineGit#  󰈚 %y " .. " %#StatusLineEmptySpace#"
end

local function construct_git()
    return "%#StatusLineGit#   %{get(b:,'gitsigns_head','')}%#StatusLineEmptySpace# "
end

local function construct_cursor()
    return "%#StatusLineCursorSep#" ..
        separators.left .. "%#StatusLineCursorIcon#  %#StatusLineCursor# Line: %l/%L Column: %c "
end

local function construct_mode(m)
    local current_mode = "%#StatusLine" .. modes[m][2] .. "Mode#  " .. modes[m][1]
    local mode_sep = "%#StatusLine" .. modes[m][2] .. "ModeSep# " .. separators.right
    return current_mode .. mode_sep
end

local function construct_lsps(buffer)
    local lsps = ""
    local clients = vim.lsp.get_clients({ bufnr = buffer })
    local names = vim.tbl_map(function(c) return c.name end, clients)
    if #names > 0 then
        lsps = "   LSP (" .. table.concat(names, ", ") .. ")"
    else
        lsps = "   LSP "
    end
    return "%#StatusLineFile# " .. lsps .. " %#StatusLineFileSep#" .. separators.right .. "  %#StatusLineEmptySpace#"
end

-- All shared data

local cwd = ""
local git = construct_git()
local file = construct_file()
local mode = construct_mode("n")
local cursor = construct_cursor()
local servers = "%#StatusLineFile#    LSP  %#StatusLineFileSep#" .. separators.right .. "  %#StatusLineEmptySpace#"

-- Master

local function construct_statusline()
    return mode .. git .. "%=" .. "%=" .. file .. cwd .. cursor
end

local statusline = construct_statusline()

-- Autocommands

vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function(args)
        local _, new_mode = args.match:match("^(.+):(.+)$")
        mode = construct_mode(new_mode)
        statusline = construct_statusline()
    end,
})

-- vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
--     callback = function(args)
--         servers = construct_lsps(args.buf)
--         statusline = construct_statusline()
--     end,
-- })

vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
    callback = function()
        local name = vim.uv.cwd() or ""
        name = "%#StatusLineCwd#" .. " " .. (name:match "([^/\\]+)[/\\]*$" or name) .. "  "
        local icon = "%#StatusLineCwdIcon#" .. " 󰉋 "
        cwd = (vim.o.columns > 85 and ("%#StatusLineCwdSep#" .. separators.left .. icon .. name)) or ""
        statusline = construct_statusline()
    end,
})

-- Construct the statusline

return function()
    return statusline
end
