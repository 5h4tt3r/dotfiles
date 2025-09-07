
-- ============================================================================
-- File: lua/plugins/filetree.lua
-- Purpose:
--   1) A RIGHT-SIDEBAR file tree using neo-tree (full CRUD, Git status, splits)
--   2) A super fast "directory-as-buffer" view using oil.nvim in a FLOATING window
--
-- Your leader key: backtick (`)  → so <leader>e means: press ` then e
--
-- Why both?
--   • neo-tree  = persistent sidebar tree (great for overview + Git status)
--   • oil.nvim  = pop-up/floating directory editor (fast, modal: open → do → q)
--
-- Lazy-loading:
--   • Plugins load only when you run commands/keys below (saves startup time)
--
-- Quick keys:
--   • Toggle neo-tree (right):      <leader>e
--   • Reveal current file in tree:  <leader>E
--   • Open Oil float (parent dir):  -    (dash)
--   • Quit Oil float:               q  or <esc>
--
-- Pro tip:
--   • Use neo-tree to watch a repo (git signs) and Oil for quick CRUD jumps.
-- ============================================================================

return {
  -- --------------------------------------------------------------------------
  -- Icons for both neo-tree and oil
  -- --------------------------------------------------------------------------
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- --------------------------------------------------------------------------
  -- 1) Neo-tree: Right-side file tree with full CRUD & Git status
  --    :Neotree command is provided; we also bind <leader>e / <leader>E
  -- --------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",          -- Lua utils for many plugins
      "nvim-tree/nvim-web-devicons",    -- file icons
      "MunifTanjim/nui.nvim",           -- UI components neo-tree uses
    },

    -- Lazy-load triggers:
    cmd = { "Neotree" },                -- typing :Neotree loads it
    keys = {
      -- <leader>e → Toggle the right-side tree (open if closed, close if open)
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            toggle = true,              -- flips open/closed
            position = "right",         -- keep it on the right
          })
        end,
        desc = "File tree: toggle (right)",
      },

      -- <leader>E → Reveal current file in the tree (also focuses the tree)
      -- Useful when you're deep inside buffers and want to see where you are
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({
            reveal = true,              -- jump the tree cursor to current file
            position = "right",
          })
        end,
        desc = "File tree: reveal current file",
      },
    },

    -- Core settings for neo-tree
    opts = {
      -- If the tree is the last window left, close it automatically
      close_if_last_window = true,

      -- Show diagnostics & git state in the tree
      enable_git_status = true,
      enable_diagnostics = true,

      -- Fine-tune default visuals & symbols
      default_component_configs = {
        indent = { with_markers = true, indent_size = 2 },
        icon = {
          folder_closed = "",
          folder_open   = "",
          folder_empty  = "",
        },
        git_status = {
          symbols = {
            added    = "",
            modified = "",
            deleted  = "",
            renamed  = "",
          },
        },
      },

      -- Window behavior for the tree itself
      window = {
        position = "right",             -- always dock the tree to the RIGHT
        width = 36,                     -- adjust to taste
        mappings = {
          -- ----------------------------
          -- Navigation / open
          -- ----------------------------
          ["<cr>"] = "open",            -- open file / expand dir (Enter)
          ["o"]    = "open",            -- classic tree-style "o" to open
          ["q"]    = "close_window",    -- close the tree
          ["<esc>"]= "close_window",
          ["<"]    = "prev_source",     -- cycle sources (filesystem/buffers/git)
          [">"]    = "next_source",

          -- ----------------------------
          -- CRUD (Create / Rename / Delete / Copy-cut-paste / Move)
          -- ----------------------------
          -- add file (relative path prompt)
          ["a"] = { "add", config = { show_path = "relative" } },
          -- add directory (relative path prompt)
          ["A"] = { "add_directory", config = { show_path = "relative" } },

          ["r"] = "rename",
          ["d"] = "delete",

          -- These 3 (y, x, p) mimic a clipboard for files within neo-tree:
          ["y"] = "copy_to_clipboard",  -- mark to copy
          ["x"] = "cut_to_clipboard",   -- mark to move
          ["p"] = "paste_from_clipboard",

          -- "m" prompts for a destination to move/rename
          ["m"] = "move",

          -- ----------------------------
          -- Open in splits / tabs
          -- ----------------------------
          ["s"] = "open_split",         -- open file in horizontal split
          ["v"] = "open_vsplit",        -- open file in vertical split
          ["t"] = "open_tabnew",        -- open file in new tab
        },
      },

      -- Filesystem behavior inside neo-tree
      filesystem = {
        -- Show dotfiles & gitignored files (but they’re dimmed)
        filtered_items = {
          visible = true,               -- show everything
          hide_dotfiles = false,        -- but don't hide dotfiles
          hide_gitignored = false,
        },

        -- When you switch buffers, keep the tree following the current file
        follow_current_file = { enabled = true },

        -- Useful: collapses nested empty dirs into a single line
        group_empty_dirs = true,

        -- OS-level file watching for auto-refresh (good perf on macOS)
        use_libuv_file_watcher = true,
      },

      -- Extra sources (e.g., show open buffers as a tree)
      buffers = {
        follow_current_file = true,
        group_empty_dirs = true,
      },

      -- Git status view appears as a float (you can cycle with < and >)
      git_status = {
        window = { position = "float" },
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- 2) Oil.nvim: Edit directories like buffers (FAST) in a floating window
  --    Default launch key: "-" (dash) opens parent of current file in a FLOAT
  --    Actions:
  --      • <CR> open  • - go parent  • H toggle hidden
  --      • a add  • d delete  • r rename  • y copy  • x move  • p paste
  --      • <C-v>/<C-s>/<C-t> open in vsplit/split/tab
  --      • q or <esc> to close the float
  -- --------------------------------------------------------------------------
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    -- Lazy-load triggers:
    cmd = { "Oil" },                    -- :Oil loads it
    keys = {
      -- Open Oil float on the parent directory of the current file
      -- (or current working dir if no file is open)
      { "-", "<cmd>Oil --float<cr>",       desc = "Oil (float): parent directory" },
      { "<leader>-", "<cmd>Oil --float<cr>", desc = "Oil (float): parent directory" },
    },

    opts = {
      -- Keep neo-tree as the main sidebar. Oil is a quick modal tool.
      default_file_explorer = false,

      -- Add icons column to make it visual
      columns = { "icon" },

      -- Show dotfiles; keep .git hidden to reduce noise
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == ".git"
        end,
      },

      -- Oil buffer keymaps (only active inside an Oil window)
      keymaps = {
        -- Navigation / open
        ["<CR>"] = "actions.select",        -- open file / enter dir
        ["-"]     = "actions.parent",       -- go to parent dir
        ["H"]     = "actions.toggle_hidden",

        -- Close the float
        ["q"]     = "actions.close",
        ["<esc>"] = "actions.close",

        -- CRUD operations
        ["a"] = "actions.create",           -- new file/dir (Oil asks)
        ["d"] = "actions.delete",
        ["r"] = "actions.rename",
        ["y"] = "actions.copy",             -- copy (staged)
        ["x"] = "actions.move",             -- move (staged)
        ["p"] = "actions.paste",            -- paste (to current dir)

        -- Open targets in splits / tab
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
      },

      -- Float window look & feel
      float = {
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
      },

      -- Make the float respect your transparent theme look (no extra blending)
      win_options = { winblend = 0 },
    },
  },
}
