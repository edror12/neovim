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

vim.keymap.set(
    'n', '<leader>e', ':NvimTreeToggle<CR>',
    { desc = "Toggle Tree", noremap = true, silent = true }
)
