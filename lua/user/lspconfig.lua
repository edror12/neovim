-- Give hover windows a border
vim.o.winborder = "rounded"

--------------------------------------------------------------------------------
-- Diagnostics
--------------------------------------------------------------------------------

vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	severity_sort = true,
	update_in_insert = false,
	float = {
		border = "rounded",
		source = "if_many",
	},
})

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)

--------------------------------------------------------------------------------
-- Navigation
--------------------------------------------------------------------------------

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)

--------------------------------------------------------------------------------
-- Hover
--------------------------------------------------------------------------------

vim.keymap.set("n", "K", vim.lsp.buf.hover)

--------------------------------------------------------------------------------
-- Signature Help
--------------------------------------------------------------------------------

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)

--------------------------------------------------------------------------------
-- Highlight references
--------------------------------------------------------------------------------

local group = vim.api.nvim_create_augroup("LspDocumentHighlight", {})

vim.api.nvim_create_autocmd("CursorHold", {
	group = group,
	callback = vim.lsp.buf.document_highlight,
})

vim.api.nvim_create_autocmd("CursorMoved", {
	group = group,
	callback = vim.lsp.buf.clear_references,
})

--------------------------------------------------------------------------------
-- Rename
--------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename)

--------------------------------------------------------------------------------
-- Code Actions
--------------------------------------------------------------------------------

vim.keymap.set({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action)

--------------------------------------------------------------------------------
-- Formatting
--------------------------------------------------------------------------------

vim.keymap.set({ "n", "x" }, "<leader>lf", function()
	vim.lsp.buf.format({ async = false })
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end)

--------------------------------------------------------------------------------
-- Code Completion
--------------------------------------------------------------------------------

local cmp = require("cmp")

cmp.setup({
	completion = {
		autocomplete = {
			cmp.TriggerEvent.TextChanged,
		},
		completeopt = "menu,menuone,noinsert",
	},

	window = {
		completion = {
			max_height = 10,
		},
	},

	preselect = cmp.PreselectMode.Item,
	mapping = cmp.mapping.preset.insert({
		["<Down>"] = cmp.mapping.select_next_item(),
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<C-e>"] = cmp.mapping.complete(),
		["<Esc>"] = cmp.mapping(function(fallback)
			cmp.mapping.abort()
			fallback()
		end),
		["<Tab>"] = cmp.mapping(function(fallback)
			if vim.snippet.active({ direction = 1 }) then
				vim.snippet.jump(1)
			elseif cmp.visible() then
				cmp.confirm({ select = false })
			else
				fallback()
			end
		end, { "i", "s" }),
		["<CR>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = false })
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	sources = {
		{ name = "nvim_lsp" },
	},

	formatting = {
		fields = { "abbr", "kind", "menu" },

		format = function(entry, item)
			local max = 20
			if vim.fn.strdisplaywidth(item.abbr) > max then
				item.abbr = vim.fn.strcharpart(item.abbr, 0, max - 1) .. "…"
			end

			local max = 40
			if vim.fn.strdisplaywidth(item.menu) > max then
				item.menu = vim.fn.strcharpart(item.menu, 0, max - 1) .. "…"
			end

			return item
		end,
	},
})

-- C/C++
vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--function-arg-placeholders",
		"--pch-storage=memory",
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
})

vim.lsp.enable("clangd")

-- Python
vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
})

vim.lsp.enable("pyright")

-- Lua
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.lsp.enable("lua_ls")

-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },

	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},

	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	},

	settings = {
		javascript = {
			updateImportsOnFileMove = {
				enabled = "always",
			},
		},

		typescript = {
			updateImportsOnFileMove = {
				enabled = "always",
			},
		},

		completions = {
			completeFunctionCalls = true,
		},
	},
})

vim.lsp.enable("ts_ls")

vim.keymap.set("n", "<leader>ch", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	for _, client in ipairs(clients) do
		if client.name == "clangd" then
			client.request("textDocument/switchSourceHeader", {
				uri = vim.uri_from_bufnr(0),
			}, function(err, result)
				if err then
					vim.notify(err.message, vim.log.levels.ERROR)
					return
				end

				if result then
					vim.cmd("edit " .. vim.uri_to_fname(result))
				end
			end, 0)

			return
		end
	end
end, { desc = "Switch header/source" })

local function goto_function(direction)
	local node = vim.treesitter.get_node()

	while node do
		if node:type() == "function_definition" then
			local start_row, _, end_row, _ = node:range()

			if direction == "start" then
				vim.api.nvim_win_set_cursor(0, { start_row + 1, 0 })
			elseif direction == "end" then
				vim.api.nvim_win_set_cursor(0, { end_row, 0 })
			end

			return
		end

		node = node:parent()
	end
end

vim.keymap.set("n", "]]", function()
	-- next function
	local parser = vim.treesitter.get_parser()
	local tree = parser:parse()[1]
	local root = tree:root()

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1

	for node in root:iter_children() do
		-- handled below
	end

	local functions = {}

	local function collect(node)
		if node:type() == "function_definition" then
			table.insert(functions, node)
		end

		for child in node:iter_children() do
			collect(child)
		end
	end

	collect(root)

	table.sort(functions, function(a, b)
		return a:start() < b:start()
	end)

	for _, fn in ipairs(functions) do
		if fn:start() > row then
			vim.api.nvim_win_set_cursor(0, { fn:start() + 1, 0 })
			return
		end
	end
end, { desc = "Next function" })


vim.keymap.set("n", "[[", function()
	-- previous function
	local parser = vim.treesitter.get_parser()
	local tree = parser:parse()[1]
	local root = tree:root()

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1

	local functions = {}

	local function collect(node)
		if node:type() == "function_definition" then
			table.insert(functions, node)
		end

		for child in node:iter_children() do
			collect(child)
		end
	end

	collect(root)

	table.sort(functions, function(a, b)
		return a:start() < b:start()
	end)

	for i = #functions, 1, -1 do
		if functions[i]:start() < row then
			vim.api.nvim_win_set_cursor(0, { functions[i]:start() + 1, 0 })
			return
		end
	end
end, { desc = "Previous function" })
