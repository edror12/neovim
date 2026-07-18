return {
    name   = "ts_ls",
    mason  = "typescript-language-server",
    config = {
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
    },
}
