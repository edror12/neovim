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

local function diag_next()
    vim.diagnostic.jump({ count = 1, float = true })
end

local function diag_prev()
    vim.diagnostic.jump({ count = -1, float = true })
end

vim.keymap.set("n", "]d", diag_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", diag_prev, { desc = "Prev diagnostic" })

--------------------------------------------------------------------------------
-- Navigation, Hover & Signature Help
--------------------------------------------------------------------------------

vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

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
-- Actions
--------------------------------------------------------------------------------

local function format_buffer()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local has_lsp_formatter = vim.iter(clients):any(function(c)
        return c.server_capabilities.documentFormattingProvider ~= nil
    end)

    if has_lsp_formatter then
        vim.lsp.buf.format({ async = false })
    else
        require("conform").format({ async = false })
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set({ "n", "x" }, "<leader>lf", format_buffer, { desc = "Format buffer" })

--------------------------------------------------------------------------------
-- LSP Management
--------------------------------------------------------------------------------

local function lsp_stop()
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        client:stop()
    end
end

local function lsp_start()
    vim.cmd("edit")
end

local function lsp_restart()
    lsp_stop()
    vim.defer_fn(lsp_start, 500)
end

vim.keymap.set("n", "<leader>lx", lsp_stop, { desc = "LSP stop" })
vim.keymap.set("n", "<leader>le", lsp_start, { desc = "LSP start" })
vim.keymap.set("n", "<leader>lR", lsp_restart, { desc = "LSP restart" })

--------------------------------------------------------------------------------
-- Servers
--------------------------------------------------------------------------------

local mason_tools = {}
local lsp_dir = vim.fn.stdpath("config") .. "/lua/user/lsp"

for _, path in ipairs(vim.fn.glob(lsp_dir .. "/*.lua", false, true)) do
    local server = path:match("([^/]+)%.lua$")
    local spec = require("user.lsp." .. server)
    vim.lsp.config(spec.name, spec.config)
    vim.lsp.enable(spec.name)
    table.insert(mason_tools, spec.mason)
end

require("mason-tool-installer").setup({ ensure_installed = mason_tools })

