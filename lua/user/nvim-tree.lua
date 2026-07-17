-- disable netrw (Vim's built-in file explorer and remote file access plugin)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local api = require('nvim-tree.api')

require('nvim-tree').setup {
    update_cwd = true,
    git = { enable = false },
    update_focused_file = { enable = true },
    renderer = {
        group_empty = true,
        highlight_git = true,
        root_folder_modifier = ":t",
    },
    on_attach = function(bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', 'v', api.node.open.vertical, opts)
    end,
}
