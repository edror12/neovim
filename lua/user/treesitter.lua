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
