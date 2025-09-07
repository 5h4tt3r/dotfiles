-- ======================================================================
-- Keymaps (vanilla, plugins add their own later)
-- ======================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Save / quit
map("n", "<leader>w", "<cmd>write<cr>", opts)       -- <Space>w to save
map("n", "<leader>q", "<cmd>quit<cr>", opts)        -- <Space>q to quit

-- Better wrapped-line nav (gj/gk move visual lines)
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- Clear search highlights
map("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

