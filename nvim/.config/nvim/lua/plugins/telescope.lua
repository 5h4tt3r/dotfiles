-- ~/dotfiles/nvim/.config/nvim/lua/plugins/telescope.lua
-- Telescope: fuzzy finding, grep, pickers for everything
-- - Requires ripgrep (rg) and fd for best results (you already have them / will install)
-- - We use fzf-native for very fast sorting
-- - We add friendly keymaps that don't conflict with your Aerospace setup

return {
  -- Core telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",               -- required
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function()
          -- if user doesn't have make, silently skip; telescope still works
          return vim.fn.executable("make") == 1
        end
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },

    -- Load on command/key; we attach our own keys below
    cmd = { "Telescope" },
    keys = function()
      local tb = require("telescope.builtin")
      local themes = require("telescope.themes")

      -- Helper wrappers with nice dropdowns where it makes sense
      local function files()
        tb.find_files({
          hidden = true,                -- show dotfiles
          no_ignore = true,             -- but we also filter with ignore patterns below
        })
      end

      local function files_all()        -- include EVERYTHING (even ignored)
        tb.find_files({ hidden = true, no_ignore = true, follow = true })
      end

      local function grep_live()
        tb.live_grep()                  -- ripgrep across project
      end

      local function grep_word()
        tb.grep_string({ word_match = "-w" })
      end

      local function grep_cursor()
        tb.grep_string()                -- word under cursor
      end

      local function grep_py_md()
        -- DS-friendly: only search .py/.md (fast, focused)
        tb.live_grep({
          additional_args = { "--glob=**/*.py", "--glob=**/*.md" },
        })
      end

      local function buffers()
        tb.buffers()
      end

      local function recent()
        tb.oldfiles({ cwd_only = false })
      end

      local function help()
        tb.help_tags()
      end

      local function diagnostics()
        tb.diagnostics()                -- project diagnostics; empty until LSP set up
      end

      local function current_buffer_fuzzy()
        tb.current_buffer_fuzzy_find(themes.get_dropdown({
          winblend = 0, previewer = false,
        }))
      end

      -- Git pickers (work if you’re in a git repo)
      local function git_status() tb.git_status() end
      local function git_commits() tb.git_commits() end
      local function git_bcommits() tb.git_bcommits() end

      return {
        -- Files / search
        { "<leader>ff", files,           desc = "Files: find" },
        { "<leader>fF", files_all,       desc = "Files: find (ALL, incl. ignored)" },
        { "<leader>fg", grep_live,       desc = "Grep: live (ripgrep)" },
        { "<leader>fs", grep_cursor,     desc = "Grep: word under cursor" },
        { "<leader>fS", grep_word,       desc = "Grep: whole word" },
        { "<leader>fd", diagnostics,     desc = "Diagnostics (project)" },
        { "<leader>fb", buffers,         desc = "Buffers" },
        { "<leader>fr", recent,          desc = "Recent files" },
        { "<leader>f/", current_buffer_fuzzy, desc = "Search in current buffer" },

        -- DS-flavored: project-wide grep limited to .py/.md
        { "<leader>fp", grep_py_md,      desc = "Grep: only .py and .md" },

        -- Git
        { "<leader>gs", git_status,      desc = "Git: status (changed files)" },
        { "<leader>gc", git_commits,     desc = "Git: commits" },
        { "<leader>gC", git_bcommits,    desc = "Git: buffer commits" },

        -- Later, when LSP is configured (Step 5), these will be super handy:
        -- { "gr", tb.lsp_references,       desc = "LSP: references" },
        -- { "gd", tb.lsp_definitions,      desc = "LSP: definitions" },
        -- { "gi", tb.lsp_implementations,  desc = "LSP: implementations" },
        -- { "gy", tb.lsp_type_definitions, desc = "LSP: type definitions" },
      }
    end,

    opts = function()
      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")

      return {
        defaults = {
          -- Use ripgrep + sensible defaults
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case",
          },
          prompt_prefix = "   ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical   = { mirror = false },
            width      = 0.95,
            height     = 0.90,
            preview_cutoff = 15,
          },
          path_display = { "smart" },      -- compact paths
          file_ignore_patterns = {
            "%.git/", "node_modules/", "venv/", "%.venv/",
            "__pycache__/", "%.ipynb_checkpoints/",
          },
          dynamic_preview_title = true,

          mappings = {
            i = {
              ["<esc>"]  = actions.close,              -- quick exit from insert mode
              ["<C-j>"]  = actions.move_selection_next,
              ["<C-k>"]  = actions.move_selection_previous,
              ["<C-n>"]  = actions.cycle_history_next,
              ["<C-p>"]  = actions.cycle_history_prev,
              ["<C-q>"]  = actions.smart_send_to_qflist + actions.open_qflist, -- send results to quickfix
              ["<C-v>"]  = actions.select_vertical,    -- open in vsplit
              ["<C-x>"]  = actions.select_horizontal,  -- open in split
              ["<C-t>"]  = actions.select_tab,         -- open in tab
              ["<Tab>"]  = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"]= actions.toggle_selection + actions.move_selection_previous,
              ["<C-l>"]  = actions_layout.toggle_preview, -- switch layout
            },
            n = {
              ["q"]      = actions.close,
              ["<C-q>"]  = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-v>"]  = actions.select_vertical,
              ["<C-x>"]  = actions.select_horizontal,
              ["<C-t>"]  = actions.select_tab,
              ["<Tab>"]  = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"]= actions.toggle_selection + actions.move_selection_previous,
            },
          },
        },

        pickers = {
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            previewer = false,
            theme = "dropdown",
          },
          help_tags = { theme = "dropdown" },
        },

        extensions = {
          -- Make vim.ui.select dialogs pretty
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,

    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Load extensions if available
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}

