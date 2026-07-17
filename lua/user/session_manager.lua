local M = {}
local cmd = ">"
local padding = 5
local padding_char = " "
local session_names = {}
local selected_index = 1
local session_dir = vim.fn.stdpath("data") .. "/sessions/"

vim.fn.mkdir(session_dir, "p")

if #cmd > padding * #padding_char then
	cmd = ">"
	padding = 3
	padding_char = " "
	vim.notify("command character is longer than padding, using default", vim.log.levels.WARN)
end

-- Utilities
local ns_id = vim.api.nvim_create_namespace("session_menu")
local function update_highlight(buf)
	vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
	vim.api.nvim_buf_add_highlight(buf, ns_id, "Visual", selected_index - 1, 0, -1)
end

local function pad_strings(tbl)
	local padded = {}
	for _, str in ipairs(tbl) do
		table.insert(padded, string.rep(padding_char, padding) .. str)
	end
	return padded
end

-- Modify selection
local move_down = function(buf, win)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_set_current_line(string.rep(padding_char, padding) .. session_names[selected_index])

	if selected_index < #session_names then
		selected_index = selected_index + 1
	else
		selected_index = 1
	end

	vim.api.nvim_win_set_cursor(win, { selected_index, 0 })
	vim.api.nvim_set_current_line(cmd .. string.rep(padding_char, padding - 1) .. session_names[selected_index])
	update_highlight(buf)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

local move_up = function(buf, win)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_set_current_line(string.rep(padding_char, padding) .. session_names[selected_index])

	if selected_index > 1 then
		selected_index = selected_index - 1
	else
		selected_index = #session_names
	end

	vim.api.nvim_win_set_cursor(win, { selected_index, 0 })
	vim.api.nvim_set_current_line(cmd .. string.rep(padding_char, padding - 1) .. session_names[selected_index])
	update_highlight(buf)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

-- Modify session
local function restore_session()
	local choice = session_names[selected_index]
	local session_file = session_dir .. choice .. ".vim"
	if vim.fn.filereadable(session_file) == 1 then
		vim.cmd("close")
		vim.cmd("source " .. session_file)
	else
		vim.notify("Session not found", vim.log.levels.ERROR)
	end
end

local function remove_session()
	local choice = session_names[selected_index]
	local session_file = session_dir .. choice .. ".vim"
	if vim.fn.delete(session_file) == 0 then
		vim.notify("Session deleted")
	else
		vim.notify("Session not found", vim.log.levels.ERROR)
	end

	vim.cmd("close")
	M.show_session_manager()
end

-- Pop-up window
local function create_popup_window(content, title)
	local width = math.ceil(vim.o.columns * 0.3)
	local height = math.min(20, #content + 1)

	local row = math.ceil((vim.o.lines - height) / 2 - 1)
	local col = math.ceil((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
	vim.api.nvim_buf_set_option(buf, "filetype", "session_menu")

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " " .. title .. " ",
		title_pos = "center",
	})

	selected_index = 1
	update_highlight(buf)

	local opts = { buffer = buf, noremap = true, silent = true }
	vim.keymap.set("n", "q", ":close<CR>", opts)
	vim.keymap.set("n", "dd", remove_session, opts)
	vim.keymap.set("n", "<Esc>", ":close<CR>", opts)
	vim.keymap.set("n", "<CR>", restore_session, opts)
	vim.keymap.set("n", "<Up>", function()
		move_up(buf, win)
	end, opts)
	vim.keymap.set("n", "<Down>", function()
		move_down(buf, win)
	end, opts)

	move_up(buf, win)
	return buf, win
end

function M.save_session()
	local name = vim.fn.input("Session name: ")
	local session_file = session_dir .. name .. ".vim"
	vim.cmd("mksession! " .. session_file)
	vim.notify("Session saved as " .. name)
end

function M.show_session_manager()
	session_names = vim.tbl_map(function(path)
		return vim.fn.fnamemodify(path, ":t:r")
	end, vim.fn.globpath(session_dir, "*.vim", false, true))

	if #session_names == 0 then
		vim.notify("No sessions found", vim.log.levels.WARN)
		return
	end

	local padded_sessions = pad_strings(session_names)
	create_popup_window(padded_sessions, "Session Manager")
end

return M
