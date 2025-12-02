-- Config nvim's status line

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

-- Colors
vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#ff9e64", bg = "#1f2335", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeSep", { fg = "#1f2335", bg = "#1f2335", bold = true })
vim.api.nvim_set_hl(0, "StatusLineEmptySpace", { fg = "#1E2430", bg = "#1E2430", bold = true })

vim.api.nvim_set_hl(0, "StatusLineGit", { fg = "#AAAAAA", bg = "#1E2430", bold = true })

vim.api.nvim_set_hl(0, "StatusLineFile", { fg = "#AAAAAA", bg = "#202020", bold = true })
vim.api.nvim_set_hl(0, "StatusLineFileSep", { bg = "#1E2430", fg = "#202020", bold = true })

vim.api.nvim_set_hl(0, "StatusLineCursor", { fg = "#A3BE8C", bg = "#1E2430", bold = true })
vim.api.nvim_set_hl(0, "StatusLineCursorSep", { fg = "#A3BE8C", bg = "#1E2430", bold = true })
vim.api.nvim_set_hl(0, "StatusLineCursorIcon", { fg = "#1E2430", bg = "#A3BE8C", bold = true })

vim.api.nvim_set_hl(0, "StatusLineCwd", { fg = "#AAAAAA", bg = "#1E2430", bold = true })
vim.api.nvim_set_hl(0, "StatusLineCwdSep", { fg = "#E06C75", bg = "#1E2430", bold = true })
vim.api.nvim_set_hl(0, "StatusLineCwdIcon", { fg = "#1E2430", bg = "#E06C75", bold = true })

vim.api.nvim_set_hl(0, "StatusLineNormalMode", { fg = "#1E2430", bg = "#81A1C1" })
vim.api.nvim_set_hl(0, "StatusLineInsertMode", { fg = "#1E2430", bg = "#B48EAD" })
vim.api.nvim_set_hl(0, "StatusLineVisualMode", { fg = "#1E2430", bg = "#D08770" })
vim.api.nvim_set_hl(0, "StatusLineTerminalMode", { fg = "#1E2430", bg = "#A3BE8C" })
vim.api.nvim_set_hl(0, "StatusLineNTerminalMode", { fg = "#1E2430", bg = "#EBCB8B" })
vim.api.nvim_set_hl(0, "StatusLineReplaceMode", { fg = "#1E2430", bg = "#88C0D0" })
vim.api.nvim_set_hl(0, "StatusLineConfirmMode", { fg = "#1E2430", bg = "#5E81AC" })
vim.api.nvim_set_hl(0, "StatusLineCommandMode", { fg = "#1E2430", bg = "#A3BE8C" })
vim.api.nvim_set_hl(0, "StatusLineSelectMode", { fg = "#1E2430", bg = "#5E81AC" })

vim.api.nvim_set_hl(0, "StatusLineNormalModeSep", { fg = "#81A1C1", bg = "#81A1C1" })
vim.api.nvim_set_hl(0, "StatusLineInsertModeSep", { fg = "#B48EAD", bg = "#B48EAD" })
vim.api.nvim_set_hl(0, "StatusLineVisualModeSep", { fg = "#D08770", bg = "#D08770" })
vim.api.nvim_set_hl(0, "StatusLineTerminalModeSep", { fg = "#A3BE8C", bg = "#A3BE8C" })
vim.api.nvim_set_hl(0, "StatusLineNTerminalModeSep", { fg = "#EBCB8B", bg = "#EBCB8B" })
vim.api.nvim_set_hl(0, "StatusLineReplaceModeSep", { fg = "#88C0D0", bg = "#88C0D0" })
vim.api.nvim_set_hl(0, "StatusLineConfirmModeSep", { fg = "#5E81AC", bg = "#5E81AC" })
vim.api.nvim_set_hl(0, "StatusLineCommandModeSep", { fg = "#A3BE8C", bg = "#A3BE8C" })
vim.api.nvim_set_hl(0, "StatusLineSelectModeSep", { fg = "#5E81AC", bg = "#5E81AC" })

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
