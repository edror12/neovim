return {
    name   = "pyright",
    mason  = "pyright",
    config = {
        cmd      = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
    },
}
