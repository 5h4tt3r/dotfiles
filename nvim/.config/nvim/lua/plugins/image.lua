-- image.nvim: show images (incl. matplotlib/plotly PNGs) inline in the terminal.
-- We use the Kitty graphics protocol so Ghostty can render in-tmux (with passthrough).
-- Prereqs:
--   - Ghostty or Kitty locally
--   - tmux passthrough enabled (in your tmux.conf): set -ga allow-passthrough on
--   - Remote/local terminal must support kitty graphics
return {
  {
    "3rd/image.nvim",
    lazy = false,
    priority = 900,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = { enabled = false },
        neorg = { enabled = false },
      },
      max_width = 0,
      max_height = 0,
      max_width_window_percentage = 100,
      max_height_window_percentage = 100,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
    },
  },
}

