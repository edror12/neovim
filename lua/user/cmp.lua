-- Give hover windows a border
vim.o.winborder = "rounded"

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

        format = function(_, item)
            local max = 20
            if vim.fn.strdisplaywidth(item.abbr) > max then
                item.abbr = vim.fn.strcharpart(item.abbr, 0, max - 1) .. "…"
            end

            max = 40
            if vim.fn.strdisplaywidth(item.menu) > max then
                item.menu = vim.fn.strcharpart(item.menu, 0, max - 1) .. "…"
            end

            return item
        end,
    },
})
