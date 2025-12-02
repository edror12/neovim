local function write_popup(content, title, width)
    title = title or ""
    width = width or 80
    local height = math.floor(vim.o.lines / 2) + 1
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal',
        border = 'rounded',
        title = " " .. title .. " ",
        title_pos = "center",
    }

    -- Create the buffer and the window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Optionally, set the buffer to be unmodifiable
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.keymap.set('n', 'q', ":close<CR>", { buffer = buf, noremap = true, silent = true })
    vim.keymap.set('n', '<Esc>', ":close<CR>", { buffer = buf, noremap = true, silent = true })
end

local M = {}
M.emily = function()
    local ascii_art = {
        "   ⠀⠀⠀⠀⠀⠀⣶⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⡄⠀⠀⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⠀⢀⣿⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣤⣤⣄⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⡇⠀⠀⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⠀⣸⡿⢸⣿⠀⠀⠀⠀⠀⢀⣠⣤⣶⡿⠿⠛⣿⣿⣿⣿⣿⣿⣿⠛⠛⠿⠿⣶⣤⣄⡀⠀⠀⠀⠀⠀⢸⡟⢹⣷⠀⠀⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⢰⣿⠃⣼⡏⠀⠀⢀⣠⣶⠿⠛⠉⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠉⠛⠿⣷⣤⡀⠀⠀⢸⣿⠀⢿⣆⠀⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⢠⣿⠃⠀⣿⠇⢀⣴⡿⠋⠁⠀⠀⠀⠀⢀⣀⣠⣿⣿⣿⣿⣿⣿⣿⣄⣀⡀⠀⠀⠀⠀⠀⠈⠙⢿⣦⡀⠘⣿⡄⠈⢿⣆⠀⠀⠀⠀   ",
        "   ⠀⠀⢠⣿⠃⠀⢸⣿⣠⣿⠋⠀⠀⠀⠀⠠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡶⠄⠀⠀⠀⠀⠀⠙⣿⣄⢿⡇⠀⠈⣿⣆⠀⠀⠀   ",
        "   ⠀⠀⣾⡇⠀⠀⢸⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡿⠀⠀⠘⣿⡀⠀⠀   ",
        "   ⠀⠀⣿⡇⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⠁⠀⠀⢀⣿⠃⠀⠀   ",
        "   ⠀⠀⠘⠿⣶⣤⣼⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣦⣤⣶⠿⠋⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡉⠀⠀⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⣀⣾⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⣄⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷⣄⠀⠀⠀⠀⠀   ",
        "   ⠀⣀⣴⣾⠟⢻⣿⠀⢠⡄⠀⣿⣦⡀⠀⠀⢸⡿⣦⣀⣶⣤⡀⣿⣷⡀⣤⠀⣠⣿⡇⠀⠀⠀⠀⠀⣴⡆⢀⡀⠀⠀⠀⢸⡏⠻⢿⣦⣄⡀⠀   ",
        "   ⣾⡟⠋⠀⠀⢈⣿⢠⣿⣷⣸⣯⡈⠛⢷⣤⣸⡇⠈⠉⠁⠈⠻⠟⠈⠻⠿⠷⠟⠀⢿⣀⣴⣿⣠⡾⢻⣧⣿⡇⢠⣿⣆⢸⣇⠀⠀⠈⠻⣷⡄   ",
        "   ⠛⢿⣶⣿⣍⣉⣙⣛⣿⡈⣩⠟⠁⠀⠀⠈⠁⢀⣤⣴⣦⣤⣤⣤⣤⣤⣤⣶⣶⣦⣌⠉⠁⠙⠋⠐⠛⢯⡈⢷⡿⣿⣿⣾⣋⣉⣽⣷⡾⠟⠁   ",
        "   ⠀⠀⢨⣿⢉⡿⠉⠉⠹⣿⠃⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠹⡆⣰⡟⠉⠉⢹⡏⢿⡇⠀⠀⠀   ",
        "   ⠀⠀⣼⡟⢸⡇⠀⠀⠀⠙⣦⡀⠀⠀⠀⠀⠀⠈⠙⠻⠿⢿⣿⣿⣿⣿⡿⠿⠟⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⣿⠟⠀⠀⠀⠸⣧⠸⣿⠀⠀⠀   ",
        "   ⠀⠀⣿⡇⢸⡇⠀⠀⠀⠀⠀⠙⠶⣤⣀⣀⣀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡴⠞⠁⠀⠀⠀⠀⠀⣿⠀⣿⡄⠀⠀   ",
        "   ⠀⢸⣿⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⣏⠉⠉⠉⠛⣿⠉⠉⠉⡏⠉⠉⠉⢙⡿⠛⠛⠛⢻⡟⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣿⡇⠀⠀   ",
        "   ⠀⠸⣿⡀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠉⠒⠢⠤⣽⣦⠀⠀⠃⠀⢀⣤⣟⣁⣠⡤⠤⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡟⠀⣿⡇⠀⠀   ",
        "   ⠀⠀⣿⡇⠘⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣧⣄⡀⠀⠀⠈⠛⠶⠶⠞⠛⠉⠀⠀⠀⢀⣸⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⢠⣿⠁⠀⠀   ",
        "   ⠀⠀⢹⣷⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣦⡉⠛⠒⠦⠤⠤⠤⠤⠤⠤⠶⠒⢊⣽⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⣸⡟⠀⠀⠀   ",
        "   ⠀⠀⠈⢿⣇⠈⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢷⣤⣀⣀⡀⠀⠀⣀⣀⣤⣶⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠃⢰⣿⠃⠀⠀⠀   ",
        "   ⠀⠀⠀⠈⢿⣆⠘⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⠛⠛⠛⠛⠛⠛⣹⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠏⣠⣿⠃⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⠈⢻⣧⡈⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣷⡄⠀⠀⢀⣴⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⢋⣴⡿⠁⠀⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⠀⠀⠙⢿⣾⠻⢷⣄⣠⣄⡀⢀⣤⣄⣠⣶⣦⣤⣽⣿⣄⢀⣾⣿⣤⣤⣶⣆⣀⣤⣄⢀⣠⣤⣀⣴⠟⢻⣿⠟⠀⠀⠀⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣤⣝⣏⠈⠙⠛⠉⢻⠉⠀⠈⢧⠀⢈⣿⣿⡇⠀⢰⠋⠀⠉⢹⠉⠛⠛⠉⣨⣏⣡⣴⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀   ",
        "   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠻⢶⣶⣶⣾⣶⣤⣶⡿⠿⠟⠋⠘⠻⠿⠿⣦⣤⣴⣾⣶⣦⣶⠾⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   "
    }
    write_popup(ascii_art, "Appa, yip yip!!", 57)
end


-- Relative Numbering
M.relative_numbering = function()
    vim.cmd("set relativenumber!")
end

-- Show alpha screen
M.toggle_alpha = function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    if string.find(buf_name, "Alpha") then
        vim.cmd("bdelete!")
    else
        vim.cmd("Alpha")
    end
end

-- Buffer Navigation
M.bnext = function()
    vim.cmd("bnext")
end

M.bprevious = function()
    vim.cmd("bprevious")
end

M.bclose = function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd("bprevious")
    vim.api.nvim_buf_delete(current_buf, { force = false })
end

-- Quickfix list
M.qf_del_entry = function()
    vim.cmd([[
        let curqfidx = line('.') - 1
        let qfl = getqflist()
        call remove(qfl, curqfidx)
        call setqflist(qfl)
        let new_idx = curqfidx
        if new_idx >= len(qfl)
            let new_idx = len(qfl)
        endif
        if new_idx >= 0
            exec new_idx + 1
        endif
    ]])
end

-- File Operations
M.copy_filename = function()
    -- "+" is the register for the system clipboard
    local file_name = vim.fn.expand("%"):match "([^/\\]+)[/\\]*$"
    vim.fn.setreg("+", file_name)
    print("Copied relative path to clipboard: " .. file_name)
end

M.copy_full_path = function()
    -- "+" is the register for the system clipboard
    local file_name = vim.fn.expand("%:p")
    vim.fn.setreg("+", file_name)
    print("Copied full path to clipboard: " .. file_name)
end

M.copy_relative_path = function()
    -- "+" is the register for the system clipboard
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
    local file_name = (path == "" and "Empty ") or path:match "([^\\]+)[/\\]*$"

    vim.fn.setreg("+", file_name)
    print("Copied relative path to clipboard: " .. file_name)
end


-- Git diff
M.git_diff = function()
    local file_path = vim.fn.expand("%")
    local buf = vim.api.nvim_create_buf(false, true)

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor((vim.o.lines -  math.floor(vim.o.lines * 0.8)) / 2),
        col = math.floor((vim.o.columns -  math.floor(vim.o.columns * 0.8)) / 2),
        style = "minimal",
        border = "rounded",
    })

    -- Run the Git command asynchronously and capture the output
    local cmd = string.format("git diff HEAD^ -- %s", file_path)
    local output = vim.fn.systemlist(cmd)

    -- Set the output to the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'diff')
    vim.api.nvim_buf_set_keymap(
        buf,
        'n',
        '<Esc>',
        ':lua vim.api.nvim_win_close('..win..', true)<CR>',
        { noremap = true, silent = true }
    )
end

-- Git blame current line
M.git_blame = function()
    local file_path = vim.fn.expand("%")
    local line_number = vim.fn.line(".")

    local cmd = string.format("git --no-pager blame -L %d,+1 -- %s 2> /dev/null", line_number, file_path)
    local handle = io.popen(cmd)
    if handle == nil then
        print("Failed to run git blame command.")
        return
    end

    local hash, author, date = handle:read("*a"):match("(%x+) %((.-) (%d+%-%d+%-%d+)")
    handle:close()

    local cmd = string.format("git --no-pager log -n 1 --pretty=format:%%s %s 2> /dev/null", hash)
    local handle = io.popen(cmd)
    if handle == nil then
        print("Failed to run git blame command.")
        return
    end

    local title = handle:read("*a")
    handle:close()

    local msg = string.format("%s (%s %s) ... copy hash to clipboard? [y/N] ", title, author, date)
    local input = vim.fn.input(msg)

    if input == "y" then
        vim.fn.setreg("+", hash)
        print("Hash copied to clipboard!")
    end
end


M.git_branch = function()
    local handle = io.popen("git symbolic-ref --short -q HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null")
    local result = handle:read("*a")
    handle:close()

    -- Trim any trailing whitespace or newlines
    result = result:gsub("%s+", "")

    if string.match(result, "^%a") then
        -- It's a branch name (starts with a letter)
        return result
    end

    if string.match(result, "^%x+") then
        -- It's a commit hash (starts with a hexadecimal character)
        return result
    end

    return nil
end

-- Highlight and trim whitespaces

M.match_id = nil
M.highlight_enabled = true

M.toggle_ws = function()
    M.highlight_enabled = not M.highlight_enabled
    if M.highlight_enabled then
        if M.match_id ~= nil then
            vim.fn.matchdelete(M.match_id)
            M.match_id = nil
        end
    else
        M.match_id = vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
    end
end


M.remove_wl = function()
    vim.cmd([[%s/\(\n\)\+$/\r/]])
    vim.cmd("noh")
    vim.cmd("w")
end

-- Cheatsheets

M.reg_help = function()
    local content = {
        "",
        "\"\" - Unnamed Register: Holds the last yanked or deleted text.",
        "\"0 - Yank Register: Holds the last yanked text.",
        "\"1 - Last Delete Register: Stores the most recent deleted text.",
        "\"2-9 - Previous Delete Registers: Store a history of previous deletions.",
        "\"a-z - Named Registers: Manually store text with '\"aY', paste with '\"ap'.",
        "\"+ - System Clipboard: Yank to and paste from the system clipboard.",
        "\". - Last Insert Register: Holds the last inserted text.",
        "\"% - Current File Name: Contains the name of the current file.",
        "\": - Last Command Register: Holds the last command-line command.",
        "\"= - Expression Register: Evaluate expressions and paste the result.",
        "\"_ - Black Hole Register: Discard text without saving it to any register."
    }
    write_popup(content, "Vim Registers")
end

M.mark_help = function()
    local content = {
        "",
        "Local Marks (a-z):",
        "  m{a-z} - Set a mark in the current file.",
        "  'a     - Jump to the line of mark 'a'.",
        "  `a     - Jump to the exact position of mark 'a'.",
        "",
        "Global Marks (A-Z):",
        "  m{A-Z} - Set a global mark across files.",
        "  'A     - Jump to the line of global mark 'A'.",
        "  `A     - Jump to the exact position of global mark 'A'.",
        "",
        "Special Marks:",
        "  '      - Jump to the line of the last jump.",
        "  `      - Jump to the exact position of the last jump.",
        "  `[     - Jump to the start of the previously changed or yanked text.",
        "  `]     - Jump to the end of the previously changed or yanked text.",
        "",
        "Numbered Marks (0-9):",
        "  Vim automatically sets these marks when switching buffers,",
        "  allowing you to return to previous files.",
    }
    write_popup(content, "Vim Marks")
end

M.macro_help = function()
    local content = {
        "",
        "Recording a Macro:",
        "  q{register} - Start recording a macro into a register (e.g., 'qa').",
        "  q           - Stop recording the macro.",
        "",
        "Appending to a Macro:",
        "  qA          - Append to an existing macro in register 'a' (e.g., 'qA').",
        "",
        "Playing Back a Macro:",
        "  @{register} - Play the macro stored in the specified register (e.g., '@a').",
        "  @@          - Replay the last played macro.",
        "",
        "Repeating a Macro:",
        "  {count}@{register} - Play the macro {count} times (e.g., '5@a').",
        "",
        "Macros are stored in the following registers:",
        "  a-z - Named registers to store macros.",
        "  @   - Register that holds the last played macro.",
    }
    write_popup(content, "Vim Macros")
end

M.markdown_help = function()
    local content = {
        "",
        "## Headers",
        "",
        "# This is a Heading h1",
        "## This is a Heading h2",
        "###### This is a Heading h6",
        "",
        "## Emphasis",
        "",
        "*This text will be italic*  ",
        "_This will also be italic_",
        "",
        "**This text will be bold**  ",
        "__This will also be bold__",
        "",
        "_You **can** combine them_",
        "",
        "## Lists",
        "",
        "### Unordered",
        "",
        "* Item 1",
        "* Item 2",
        "* Item 2a",
        "* Item 2b",
        "",
        "### Ordered",
        "",
        "1. Item 1",
        "2. Item 2",
        "3. Item 3",
            "1. Item 3a",
            "2. Item 3b",
        "",
        "## Images",
        "",
        "![This is an alt text.](/image/sample.webp \"This is a sample image.\")",
        "",
        "## Links",
        "",
        "You may be using [Markdown Live Preview](https://markdownlivepreview.com/).",
        "",
        "## Blockquotes",
        "",
        "> Markdown is a lightweight markup language with plain-text-formatting syntax, created in 2004 by John Gruber with Aaron Swartz.",
        ">",
        ">> Markdown is often used to format readme files, for writing messages in online discussion forums, and to create rich text using a plain text editor.",
        "",
        "## Tables",
        "",
        "| Left columns  | Right columns |",
        "| ------------- |:-------------:|",
        "| left foo      | right foo     |",
        "| left bar      | right bar     |",
        "| left baz      | right baz     |",
        "",
        "## Blocks of code",
        "",
        "```",
        "let message = 'Hello world';",
        "alert(message);",
        "```",
        "",
        "## Inline code",
        "",
        "This web site is using `markedjs/marked`.",
    }
    write_popup(content, "Markdown syntax guide")
end

M.wrap_selection = function(lpar, rpar)
    if not vim.fn.mode():match('[vV\22]') then
        print("Not in visual mode!")
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")

    local start_row = start_pos[2] - 1
    local start_col = start_pos[3] - 1
    local end_row = end_pos[2] - 1
    local end_col = end_pos[3]

    if start_col > vim.fn.col('$') - 1 then
        start_col = vim.fn.col('$') - 1
    end

    if end_col > vim.fn.col('$') - 1 then
        end_col = vim.fn.col('$') - 1
    end

    if vim.fn.mode() == 'V' then
       start_col = 0
       end_col = vim.fn.col('$') - 1
    end

    local rp = vim.api.nvim_buf_get_text(bufnr, end_row, end_col - 1, end_row, end_col, {})
    local lp = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, start_row, start_col + 1, {})

    if vim.inspect(lp) == string.format('{ "%s" }', lpar)
        and vim.inspect(rp) == string.format('{ "%s" }', rpar) then
        vim.api.nvim_buf_set_text(bufnr, end_row, end_col - 1, end_row, end_col, {})
        vim.api.nvim_buf_set_text(bufnr, start_row, start_col, start_row, start_col + 1, {})
    else
        vim.api.nvim_buf_set_text(bufnr, end_row, end_col, end_row, end_col, { rpar })
        vim.api.nvim_buf_set_text(bufnr, start_row, start_col, start_row, start_col, { lpar })
    end
end

return M
