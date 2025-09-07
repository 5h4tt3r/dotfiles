-- ======================================================================
-- General editor options (sane defaults)
-- ======================================================================
local o = vim.opt

-- UI
o.termguicolors = true          -- enable 24-bit colors
o.number = true                 -- absolute line numbers
o.relativenumber = true         -- relative line numbers (nice with j/k)
o.signcolumn = "yes"            -- avoid text shifting when diagnostics appear
o.cursorline = true

-- Editing
o.expandtab = true              -- spaces instead of tabs
o.shiftwidth = 2                -- indent size
o.tabstop = 2
o.smartindent = true

-- Behavior
o.clipboard = "unnamedplus"     -- use macOS system clipboard
o.updatetime = 200              -- faster CursorHold/diagnostic updates
o.timeoutlen = 400              -- which-key/timings feel snappy
o.scrolloff = 5                 -- keep context around cursor

