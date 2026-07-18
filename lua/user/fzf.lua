local fzf = require("fzf-lua")

fzf.setup({
	keymap = {
		builtin = {
			["<Esc>"] = "hide", -- hide fzf-lua, `:FzfLua resume` to continue
			["<F16>"] = "toggle-fullscreen",
			["<F17>"] = "toggle-preview",
			["<S-Left>"] = "preview-reset",
			["<S-down>"] = "preview-down",
			["<S-up>"] = "preview-up",
		},
		fzf = {
			["ctrl-z"] = "abort",
			["ctrl-u"] = "unix-line-discard",
			["ctrl-f"] = "half-page-down",
			["ctrl-b"] = "half-page-up",
			["ctrl-a"] = "beginning-of-line",
			["ctrl-e"] = "end-of-line",
			["alt-a"] = "toggle-all",
			["alt-g"] = "first",
			["alt-G"] = "last",
            ["ctrl-q"] = "select-all+accept",
		},
	},

	winopts = {
		height = 0.95, -- window height
		width = 0.95, -- window width
		row = 0.35, -- window row position (0=top, 1=bottom)
		col = 0.50, -- window col position (0=left, 1=right)
		border = "rounded",
		backdrop = 60,
		treesitter = {
			enabled = true,
		},
		preview = {
			-- default     = 'bat',           -- override the default previewer?
			-- default uses the 'builtin' previewer
			border = "rounded", -- preview border: accepts both `nvim_open_win`
			wrap = false, -- preview line wrap (fzf's 'wrap|nowrap')
			hidden = false, -- start preview hidden
			vertical = "up:60%", -- up|down:size
			horizontal = "right:60%", -- right|left:size
			layout = "vertical", -- horizontal|vertical|flex
			flip_columns = 100, -- #cols to switch to horizontal on flex
			-- Only used with the builtin previewer:
			title = true, -- preview border title (file/buf)?
			title_pos = "center", -- left|center|right, title alignment
			scrollbar = "float", -- `false` or string:'float|border'
			-- float:  in-window floating border
			-- border: in-border "block" marker
			scrolloff = -1, -- float scrollbar offset from right
			-- applies only when scrollbar = 'float'
			delay = 20, -- delay(ms) displaying the preview
			-- prevents lag on fast scrolling
			winopts = { -- builtin previewer window options
				number = true,
				relativenumber = false,
				cursorline = true,
				cursorlineopt = "both",
				cursorcolumn = false,
				signcolumn = "no",
				list = false,
				foldenable = false,
				foldmethod = "manual",
			},
		},
	},
})
