-- ======================================================================
-- Minimal plugin set to prove lazy.nvim works
-- Also installs two themes: catppuccin + tokyonight
-- ======================================================================
return {
  -- Which-key: popup that shows available keymaps
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- Theme: Catppuccin (Mocha)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      integrations = { which_key = true },
      transparent_background = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Theme: Tokyo Night (installed as an option you can switch to)
  {
    "folke/tokyonight.nvim",
    lazy = true, -- not default; switch to it via :colorscheme tokyonight
    opts = {
      style = "moon", -- 'storm', 'night', 'moon', 'day'
      transparent = true,
    },
  },
}

