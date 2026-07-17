local opts = function(description, sil, buf)
	buf = buf or false
	return { desc = description, noremap = true, silent = sil, buffer = buf }
end

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("", "<Space>", "<Nop>", opts("Space"))

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
vim.keymap.set("n", "<BS>", '"_dd', opts("Delete text without copying"))

vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<S-C-Up>", ":resize -2<CR>", opts("Resize window up", true))
vim.keymap.set("n", "<S-C-Down>", ":resize +2<CR>", opts("Resize window down", true))
vim.keymap.set("n", "<S-C-Left>", ":vertical resize +2<CR>", opts("Resize window left", true))
vim.keymap.set("n", "<S-C-Right>", ":vertical resize -2<CR>", opts("Resize window right", true))
vim.keymap.set("n", "\\", function()
	require("user.nvim-window").pick()
end, opts("Pick window"))

vim.keymap.set("n", "<leader>r", ":%s///g<Left><Left>", opts("Replace", false))
vim.keymap.set("v", "<leader>r", ":s///g<Left><Left>", opts("Replace", false))

-- Visual --
vim.keymap.set("v", "<", "<gv", opts("Stay in indent mode"))
vim.keymap.set("v", ">", ">gv", opts("Stay in indent mode"))
vim.keymap.set("v", "p", '"_dP', opts("Paste on top of text"))
vim.keymap.set("v", "<BS>", '"_d', opts("Delete text without copying"))
vim.keymap.set("v", "<S-Up>", ":m .-2<CR>==", opts("Move text up", true))
vim.keymap.set("v", "<S-Down>", ":m .+1<CR>==", opts("Move text down", true))

-- Visual Block --
vim.keymap.set("x", "<S-Up>", ":move '<-2<CR>gv-gv", opts("Move text up", true))
vim.keymap.set("x", "<S-Down>", ":move '>+1<CR>gv-gv", opts("Move text down", true))

-- Utilities
local utils = require("user.utils")
vim.keymap.set("n", "<leader>a", utils.emily, { desc = "Appa, yip yip!!" })

vim.keymap.set("n", "<leader>x", utils.bclose, { desc = "Buffer close" })
vim.keymap.set("n", "<leader>q", ":%bd|e#<CR>", { desc = "Close all buffers", silent = true })
vim.keymap.set("n", "<leader>d", "90|Bi<CR><Esc>", { desc = "Break Line at 90", silent = true })
vim.keymap.set("n", "<tab>", utils.bnext, { desc = "Buffer goto next" })
vim.keymap.set("n", "<S-tab>", utils.bprevious, { desc = "Buffer goto prev" })

vim.keymap.set("n", "<leader>cn", utils.copy_filename, { desc = "Copy filename" })
vim.keymap.set("n", "<leader>cp", utils.copy_full_path, { desc = "Copy file full path" })
vim.keymap.set("n", "<leader>cr", utils.copy_relative_path, { desc = "Copy file relative path" })

-- QuickList
vim.keymap.set("n", "]q", "<cmd>cn<CR>", { desc = "Next quicklist match" })
vim.keymap.set("n", "[q", "<cmd>cp<CR>", { desc = "Previous quicklist match" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "<BS>", utils.qf_del_entry, opts("", true, 0))
	end,
})

-- Git
local gitsigns = require("gitsigns")
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		gitsigns.nav_hunk("next")
	end
end, { desc = "Toggle Deleted" })
vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		gitsigns.nav_hunk("prev")
	end
end, { desc = "Toggle Deleted" })
vim.keymap.set("n", "<leader>gd", utils.git_diff, { desc = "Git diff current file" })
vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
vim.keymap.set("v", "<leader>gs", function()
	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage Hunk" })
vim.keymap.set("v", "<leader>gr", function()
	gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Buffer" })
vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })
vim.keymap.set("n", "<leader>gP", gitsigns.preview_hunk, { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>gb", function()
	gitsigns.blame_line({ full = true })
end, { desc = "Blame Line" })
vim.keymap.set("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
vim.keymap.set("n", "<leader>gD", gitsigns.toggle_deleted, { desc = "Toggle Deleted" })
vim.keymap.set("n", "<leader>gq", function()
	gitsigns.setqflist("all")
end, { desc = "QF List Of All Changes" })
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })

-- Session Manager
local manager = require("user.session_manager")
vim.keymap.set("n", "<leader>ss", manager.save_session, opts("Save Session"))
vim.keymap.set("n", "<leader>sw", manager.show_session_manager, opts("Show Session Manager"))

local leaba = require("user.leaba")
vim.keymap.set("n", "<leader>m", leaba.show_guides, opts("Show Guides"))

vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<CR>", { desc = "find marks" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "help page" })
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>", { desc = "live grep" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua resume<CR>", { desc = "resume search" })
vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers<CR>", { desc = "find buffers" })
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "find files" })
vim.keymap.set("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>", { desc = "find oldfiles" })

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Tree", noremap = true, silent = true })
