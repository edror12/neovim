require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.treesitter"
require "user.nvim-tree"
require "user.templates"
require "user.nvim-window"
require "user.coc"
require "user.session_manager"
require "user.leaba"

local status_ok, bufferline = pcall(require, "bufferline")
 if not status_ok then
     return
 end

 bufferline.setup {
     options = {
         close_command = "bdelete! %d",
         right_mouse_command = "bdelete! %d",
         left_mouse_command = "buffer %d",
         middle_mouse_command = nil,
         buffer_close_icon = '',
         modified_icon = "●",
         close_icon = "",
         left_trunc_marker = "",
         right_trunc_marker = "",
         max_name_length = 18,
         max_prefix_length = 15,
         tab_size = 20,
         diagnostics = false,
         diagnostics_update_in_insert = false,
         offsets = {{ filetype = "NvimTree", text = "EXPLORER", text_align = "center" }},
         show_buffer_icons = true,
         show_buffer_close_icons = true,
         show_close_icon = true,
         show_tab_indicators = true,
         persist_buffer_sort = true,
         separator_style = "slant",
         enforce_regular_tabs = true,
         always_show_bufferline = true,
     },
 }

vim.cmd [[
    hi Normal guibg=#000000
    hi NormalNC guibg=#000000
    hi EndOfBuffer guibg=#000000
    hi SignColumn guibg=#000000
    hi VertSplit guibg=#000000

    hi BufferLineFill guibg=#000000
    hi BufferLineBackground guibg=#000000
    hi BufferLineSeparator guibg=#000000 guifg=#000000
    hi BufferLineTabSelected guibg=#000000
    hi BufferLineBufferSelected guibg=#000000
    hi BufferLineSeparatorSelected guibg=#000000 guifg=#000000
    hi BufferLineCloseButton guibg=#000000
    hi BufferLineCloseButtonVisible guibg=#000000
    hi BufferLineCloseButtonSelected guibg=#000000

    hi BufferLineBufferVisible guibg=#000000
    hi BufferLineBufferSelected guibg=#000000

    hi BufferLineIndicatorSelected guibg=#000000
    hi BufferLineModified guibg=#000000
    hi BufferLineModifiedVisible guibg=#000000
    hi BufferLineModifiedSelected guibg=#000000

    hi BufferLineDevIconLua guibg=#000000
]]

