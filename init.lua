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
    { src = "https://github.com/neoclide/coc.nvim",                         version = "master" },
    { src = "https://github.com/SmiteshP/nvim-navic",                       version = "master" },
    { src = "https://github.com/windwp/nvim-autopairs",                     version = "master" },
    { src = "https://github.com/stevearc/conform.nvim",                     version = "master" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua",                   version = "master" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons",               version = "master" },
})

require("barbecue").setup()
require("gitsigns").setup()
require("nvim-autopairs").setup()
require("which-key").setup({ triggers = { "<leader>" }, win = { border = "rounded" } })
require("conform").setup({
    formatters_by_ft = {
        javascript  = { "prettier" },
        typescript  = { "prettier" },
        jsx         = { "prettier" },
        tsx         = { "prettier" },
        css         = { "prettier" },
        html        = { "prettier" },
        json        = { "prettier" },
        yaml        = { "prettier" },
        markdown    = { "prettier" },
    },
})

require("user.nvim-tree")
require("user.bufferline")
require("user.keymaps")
require("user.treesitter")
require("user.fzf")
require("user.coc")
