-- ~/dotfiles/nvim/.config/nvim/lua/plugins/ui_cmdline.lua
-- Pretty popup for ":" (like Spotlight), improved prompts, and notifications.
-- Safe, UI-only plugins: folke/noice.nvim, nui.nvim, rcarriga/nvim-notify, dressing.nvim.

return {
  -- Noice: routes Neovim messages + cmdline to pretty popups
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",   -- UI primitives (windows, layouts)
      "rcarriga/nvim-notify",   -- nice toast notifications (optional but great)
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup", -- show a centered popup when pressing :
        format = {
          cmdline = { icon = "" },
          search  = { icon = "" },
        },
      },
      messages = { enabled = true }, -- route :messages etc.
      lsp = {
        progress  = { enabled = true }, -- show “indexing… / analyzing…” nicely
        hover     = { enabled = false }, -- keep native K for LSP hover
        signature = { enabled = false }, -- keep native/signature plugin
      },
      presets = {
        command_palette       = true,  -- nicer ":" input
        long_message_to_split = true,  -- long outputs go to a split
      },
      views = {
        cmdline_popup = {
          border = { style = "rounded" },
          position = { row = "40%", col = "50%" },
          size = { width = 80, height = "auto" },
          win_options = { winblend = 0 }, -- plays well with your transparent theme
        },
      },
    },
    config = function(_, opts)
      vim.o.cmdheight = 0     -- recommended so cmdline lives in the popup
      require("noice").setup(opts)
      -- Use nvim-notify for vim.notify()
      local ok, notify = pcall(require, "notify")
      if ok then vim.notify = notify end
    end,
  },

  -- Dressing: upgrades vim.ui.input / vim.ui.select (used by Telescope/others)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input  = { border = "rounded" },
      select = { backend = { "telescope", "builtin" } },
    },
  },
}

