local fzf = require("fzf-lua")

fzf.setup({
	"max-perf",
	keymap = {
		fzf = {
			["ctrl-z"] = "abort",
			["ctrl-f"] = "half-page-down",
			["ctrl-b"] = "half-page-up",
			["ctrl-a"] = "beginning-of-line",
			["ctrl-e"] = "end-of-line",
			["alt-a"] = "toggle-all",
			["f3"] = "toggle-preview-wrap",
			["f4"] = "toggle-preview",
			["ctrl-d"] = "preview-page-down",
			["ctrl-u"] = "preview-page-up",
			["ctrl-q"] = "select-all+accept",
		},
	},

	buffers = {
		fzf_opts = {
			["--no-preview"] = "", -- disable preview window
		},
	},

	winopts = {
		preview = {
			layout = "horizontal", -- 'vertical' (default) or 'horizontal'
			horizontal = "up:50%", -- adjust split size (e.g., 50% height)
		},
	},
})
