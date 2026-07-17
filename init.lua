require("user.options")
require("user.statusline")

vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua",                          version = "main" },
    { src = "https://github.com/hrsh7th/nvim-cmp",                          version = "main" },
    { src = "https://github.com/mason-org/mason.nvim",                      version = "main" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp",                      version = "main" },
    { src = "https://github.com/folke/which-key.nvim",                      version = "main" },
    { src = "https://github.com/utilyre/barbecue.nvim",                     version = "main" },
    { src = "https://github.com/lewis6991/gitsigns.nvim",                   version = "main" },
    { src = "https://github.com/akinsho/bufferline.nvim",                   version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",           version = "main" },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim', version = "main" },
    { src = "https://github.com/SmiteshP/nvim-navic",                       version = "master" },
    { src = "https://github.com/windwp/nvim-autopairs",                     version = "master" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua",                   version = "master" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons",               version = "master" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim",       version = "master" },
})

require("ibl").setup()
require("mason").setup()
require("barbecue").setup({ create_autocmd = true })
require("gitsigns").setup()
require("nvim-autopairs").setup()
require("which-key").setup({ triggers = { "<leader>" }, win = { border = "rounded" } })

require("user.fzf")
require("user.nvim-tree")
require("user.bufferline")
require("user.treesitter")

require("user.keymaps")
require("user.lspconfig")
