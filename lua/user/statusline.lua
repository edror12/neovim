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

local statusline_modules = {}

statusline_modules["%="] = "%="

statusline_modules.mode = function()
    local m = vim.api.nvim_get_mode().mode

    local current_mode = "%#StatusLine" .. modes[m][2] .. "Mode#  " .. modes[m][1]
    local mode_sep = "%#StatusLine" .. modes[m][2] .. "ModeSep# " .. separators.right
    return current_mode .. mode_sep
end

statusline_modules.diagnostics = function()
    local clients = {}
    if #clients == 0 then
        return "%#StatusLineFile#   LSP %#StatusLineFileSep#"
            .. separators.right .. " %#StatusLineEmptySpace# "
    end

    local names = {}
    for _, obj in ipairs(clients) do
        if obj.name then
            table.insert(names, obj.name)
        end
    end

    return "%#StatusLineFile#   LSP (" .. table.concat(names, ", ") .. ")%#StatusLineFileSep#"
        .. separators.right .. " %#StatusLineEmptySpace# "
end


statusline_modules.file = function()
    return "%#StatusLineFile#  󰈚 %f " .. "%#StatusLineFileSep#"
        .. separators.right .. "  %#StatusLineEmptySpace#"
end

local git_branch = require("user.utils").git_branch()
statusline_modules.git = function()
    if git_branch then
        return "%#StatusLineGit#   " .. git_branch .. "%#StatusLineEmptySpace# "
    end
    return "%#StatusLineEmptySpace#"
end

statusline_modules.cwd = function()
    local name = vim.uv.cwd()
    name = "%#StatusLineCwd#" .. " " .. (name:match "([^/\\]+)[/\\]*$" or name) .. "  "
    local icon = "%#StatusLineCwdIcon#" .. " 󰉋 "
    return (vim.o.columns > 85 and ("%#StatusLineCwdSep#" .. separators.left .. icon .. name)) or ""
end

statusline_modules.cursor = function()
    return "%#StatusLineCursorSep#" .. separators.left ..
        "%#StatusLineCursorIcon#  %#StatusLineCursor# Line: %l/%L Column: %c "
end


-- Construct the statusline
return function()
    local statusline = {}
    local order = {
        "mode", "git", "%=", "%=", "cwd", "cursor"
    }

    for _, component in ipairs(order) do
        local module = statusline_modules[component]
        module = type(module) == "string" and module or module()
        table.insert(statusline, module)
    end

    return table.concat(statusline)
end



