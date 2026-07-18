return {
    name   = "clangd",
    mason  = "clangd",
    config = {
        cmd = {
            "clangd",
            "-j=2",
            "--background-index=false",
            "--limit-results=500",
            "--clang-tidy",
            "--clang-tidy-checks=-*,bugprone-*,performance-*",
            "--header-insertion=never",
            "--log=error",
            "--completion-style=detailed",
            "--fallback-style=Google",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        on_attach = function(client)
            client.server_capabilities.semanticTokensProvider = nil
        end,
    },
}
