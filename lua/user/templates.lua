
-- Define groups for auto-commands
local guard_group = vim.api.nvim_create_augroup("HeaderGuard", { clear = true })
local format_group = vim.api.nvim_create_augroup("AutoFormat", { clear = true })
local template_group = vim.api.nvim_create_augroup("FileTemplates", { clear = true })

-- Auto format commands
local function enable_auto_format()
    local files = "*.h,*.hpp,*.c,*.cpp"
    local function run_clang()
        vim.cmd("silent! !clang-format -i %")
        vim.cmd("edit!")
    end

    local opts = { group = format_group, pattern = files, callback = run_clang }
    vim.api.nvim_create_autocmd("BufWritePost", opts)
end

local function disable_auto_format()
    vim.api.nvim_clear_autocmds({ group = format_group })
end

vim.api.nvim_create_user_command("EnableAutoFormat", enable_auto_format, {})
vim.api.nvim_create_user_command("DisableAutoFormat", disable_auto_format, {})


-- C files
local opts = {
    pattern = "*.c",
    group = template_group,
    callback = function()
        local content = {
            [[#include <stdio.h>]],
            [[]],
            [[int main(int argc, char *argv[])]],
            [[{]],
            [[    printf("Hello, world!\n");]],
            [[    return 0;]],
            [[}]],
        }
        vim.api.nvim_buf_set_lines( 0, 0, -1, false, content)
    end
}
vim.api.nvim_create_autocmd("BufNewFile", opts)

local opts = {
    pattern = "*.h,*.hpp",
    group = template_group,
    callback = function()
        local filename = vim.fn.expand("%:t")
        local guard_name = filename:gsub("%.", "_"):upper()

        local content = {
            "#ifndef " .. guard_name,
            "#define " .. guard_name,
            "",
            "",
            "",
            "#endif // " .. guard_name
        }
        vim.api.nvim_buf_set_lines( 0, 0, -1, false, content)
        vim.api.nvim_win_set_cursor(0, { 4, 1 })
    end
}
vim.api.nvim_create_autocmd("BufNewFile", opts)

-- Cpp files
local opts = {
    pattern = "*.cpp",
    group = template_group,
    callback = function()
        local content = {
            [[#include <iostream>]],
            [[]],
            [[int main (int argc, char *argv[]) {]],
            [[    std::cout << "Hello, world!" << std::endl;]],
            [[    return 0;]],
            [[}]],
        }
        vim.api.nvim_buf_set_lines( 0, 0, -1, false, content)
    end
}
vim.api.nvim_create_autocmd("BufNewFile", opts)

-- Python files
local opts = {
    pattern = "*.py",
    group = template_group,
    callback = function()
        local content = {
            [[#!/usr/bin/env python3]],
            [[# pylint: disable=all]],
            [[]],
            [[def main():]],
            [[    pass]],
            [[]],
            [[if __name__ == "__main__":]],
            [[    main()]],
        }
        vim.api.nvim_buf_set_lines( 0, 0, -1, false, content)
    end
}
vim.api.nvim_create_autocmd("BufNewFile", opts)

-- Makefile files
local opts = {
    pattern = "Makefile",
    group = template_group,
    callback = function()
        local content = {
            [[COMPILER := clang]],
            [[COMPILER_FLAGS := -std=c99 -Wextra -Wpedantic]],
            [[SRCS := main.c]],
            [[OBJS=$(subst .c,.o,$(SRCS))]],
            [[HDRS := main.h]],
            [[BIN := main]],
            [[ZIP := sub]],
            [[]],
            [[$(BIN): $(OBJS)]],
            [[	$(COMPILER) $(COMPILER_FLAGS) $^ -o $@]],
            [[]],
            [[$(OBJS): %.o: %.c]],
            [[	$(COMPILER) $(COMPILER_FLAGS) -c $^]],
            [[]],
            [[zip: $(SRCS) $(HDRS)]],
            [[	zip $(ZIP).zip $^ Makefile]],
            [[]],
            [[clean:]],
            [[	rm -rf $(BIN) $(OBJS)]],
            [[	rm -rf $(ZIP).zip]],
        }
        vim.api.nvim_buf_set_lines( 0, 0, -1, false, content)
    end
}
vim.api.nvim_create_autocmd("BufNewFile", opts)

-- clang-format files
local opts = {
    pattern = ".clang-format",
    group = template_group,
    callback = function()
        local content = {
            [[---]],
            [[BasedOnStyle:  Google]],
            [[AccessModifierOffset: -4]],
            [[AlignConsecutiveAssignments: true]],
            [[AllowShortCaseLabelsOnASingleLine: true]],
            [[AllowShortFunctionsOnASingleLine: Inline]],
            [[BraceWrapping:]],
            [[  AfterClass:      true]],
            [[  AfterControlStatement: false]],
            [[  AfterEnum:       true]],
            [[  AfterFunction:   true]],
            [[  AfterNamespace:  false]],
            [[  AfterObjCDeclaration: false]],
            [[  AfterStruct:     true]],
            [[  AfterUnion:      true]],
            [[  BeforeCatch:     false]],
            [[  BeforeElse:      false]],
            [[  IndentBraces:    false]],
            [[BreakBeforeBraces: Custom]],
            [[BreakBeforeBinaryOperators: All]],
            [[BreakConstructorInitializersBeforeComma: true]],
            [[BreakInheritanceList: BeforeComma]],
            [[ConstructorInitializerAllOnOneLineOrOnePerLine: false]],
            [[DerivePointerAlignment: false]],
            [[IndentWidth:     4]],
            [[IncludeCategories:]],
            [[  - Regex:           '^".*"']],
            [[    Priority:        1]],
            [[  - Regex:           '^<.*\.h>']],
            [[    Priority:        2]],
            [[  - Regex:           '^<.*']],
            [[    Priority:        3]],
            [[  - Regex:           '.*']],
            [[    Priority:        4]],
            [[PointerAlignment: Right]],
            [[SpacesInCStyleCastParentheses: false]],
            [[ObjCBlockIndentWidth: 4]],
            [[ColumnLimit: 100]],
            [[---]],
            [[Language:        Cpp]],
            [[---]],
            [[Language:        ObjC]],
        }
        vim.api.nvim_buf_set_lines( 0, 0, -1, false, content)
    end
}
vim.api.nvim_create_autocmd("BufNewFile", opts)

