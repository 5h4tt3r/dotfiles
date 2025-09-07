-- ======================================================================
-- Neovim entrypoint
-- - Sets leader BEFORE loading anything
-- - Pulls in options & keymaps
-- - Bootstraps lazy.nvim (plugin manager)
-- - Loads plugins from lua/plugins/*
-- ======================================================================

-- Leader keys (must be early!)
-- Leader: main prefix for your custom shortcuts (e.g. <leader>ff)
-- LocalLeader: for filetype-local mappings (e.g. in markdown, typst)
vim.g.mapleader = "'"          -- Use Space as leader (safe, ergonomic)
vim.g.maplocalleader = " "     -- Secondary leader
vim.keymap.set("n", "'", "<Nop>", { noremap = true }) -- disable mark motion



--use homebrew python force 
-- Set Python host to Homebrew Python
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"


-- Load core config
require("config.options")
require("config.keymaps")

-- ----------------------------------------------------------------------
-- lazy.nvim bootstrap (official pattern)
-- ----------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ----------------------------------------------------------------------
-- Load plugin specs from lua/plugins/*.lua
-- ----------------------------------------------------------------------
require("lazy").setup({ import = "plugins" }, {
  ui = { border = "rounded" },
  change_detection = { notify = false },
})


require("image").setup {
  backend = "kitty",  -- force kitty graphics
}

