require("nvim-treesitter.install").install({
	"c",
	"cpp",
	"lua",
	"python",
	"zsh",
	"bash",
	"json",
	"vim",
	"vimdoc",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
		vim.schedule(function()
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt_local.foldenable = true
			vim.opt_local.foldlevel = 99
		end)
	end,
})

local function get_curr_or_prev_func_start()
	-- Treesitter:    rows and cols are both 0-indexed
	-- Neovim cursor: rows are 1-indexed, cols are 0-indexed
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1

	while row >= 0 do
		local node = vim.treesitter.get_node({ pos = { row, 0 } })

		while node ~= nil do
			if node:type() == "function_definition" then
				local start_row, start_col, _, _ = node:field("body")[1]:range()
				if start_row >= row then
					-- Look for function bodies up the current line
					row = node:start() - 1
					break
				end

				return vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
			end

			node = node:parent()
		end

		row = row - 1
	end
end

local function get_prev_func_end()
	-- Treesitter:    rows and cols are both 0-indexed
	-- Neovim cursor: rows are 1-indexed, cols are 0-indexed
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1

	-- Exit the current function if in one
	local node = vim.treesitter.get_node({ pos = { row, 0 } })
	while node ~= nil do
		if node:type() == "function_definition" then
			row = node:start() - 1
		end

		node = node:parent()
	end

	-- Find the first funcion and return end to that
	while row >= 0 do
		node = vim.treesitter.get_node({ pos = { row, 0 } })
		while node ~= nil do
			if node:type() == "function_definition" then
				local _, _, end_row, end_col = node:range()
				return vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
			end

			node = node:parent()
		end

		row = row - 1
	end
end

local function get_next_or_current_func_start()
	-- Treesitter:    rows and cols are both 0-indexed
	-- Neovim cursor: rows are 1-indexed, cols are 0-indexed
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local row_end = vim.api.nvim_buf_line_count(0)

	while row < row_end do
		local node = vim.treesitter.get_node({ pos = { row, 0 } })

		while node ~= nil do
			if node:type() == "function_definition" then
				local start_row, start_col, _, _ = node:field("body")[1]:range()
				if start_row <= row then
					-- Look for function bodies down the current line
					row = node:end_() + 1
					break
				end

				return vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
			end

			node = node:parent()
		end

		row = row + 1
	end
end

local function get_next_or_current_func_end()
	-- Treesitter:    rows and cols are both 0-indexed
	-- Neovim cursor: rows are 1-indexed, cols are 0-indexed
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local row_end = vim.api.nvim_buf_line_count(0)

	while row < row_end do
		local node = vim.treesitter.get_node({ pos = { row, 0 } })

		while node ~= nil do
			if node:type() == "function_definition" then
				local _, _, end_row, end_col = node:field("body")[1]:range()
				if end_row <= row then
					-- Look for function bodies down the current line
					row = end_row + 1
					break
				end

				return vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
			end

			node = node:parent()
		end

		row = row + 1
	end
end

vim.keymap.set("n", "[]", get_prev_func_end, { desc = "Previous function" })
vim.keymap.set("n", "[[", get_curr_or_prev_func_start, { desc = "Previous function" })
vim.keymap.set("n", "][", get_next_or_current_func_end, { desc = "Previous function" })
vim.keymap.set("n", "]]", get_next_or_current_func_start, { desc = "Previous function" })
