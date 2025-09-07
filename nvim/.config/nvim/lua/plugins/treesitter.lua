-- ~/dotfiles/nvim/.config/nvim/lua/plugins/treesitter.lua
-- Tree-sitter: precise highlighting, structural motions, and text objects.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",                          -- auto-update parsers
    event = { "BufReadPre", "BufNewFile" },      -- load when opening files
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      -- Install parsers you care about (add/remove freely)
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "bash", "json", "yaml", "toml", "regex", "markdown", "markdown_inline",
        "python", "go", "rust", "c", "cpp", "zig",
        -- "typst", -- enable if available in your nvim-treesitter snapshot
      },

      highlight = { enable = true },
      indent    = { enable = true },

      -- Incremental selection = grow/shrink selection by syntax node.
      -- NOTE: These defaults use <CR> and <BS> in NORMAL mode.
      -- If you don't like that, change to your own keys (examples below).
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection    = "<CR>",   -- start selection at cursor
          node_incremental  = "<CR>",   -- expand to the next node
          scope_incremental = "<S-CR>", -- expand by scope
          node_decremental  = "<BS>",   -- shrink
        },
      },

      -- Textobjects: select, move, and swap *by syntax* (functions, classes, args).
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- jump forward automatically to textobj
          keymaps = {
            -- Functions
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- Classes
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            -- Parameters/arguments
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- add to jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {  ["]a"] = "@parameter.inner" }, -- swap arg with next
          swap_previous = { ["[a"] = "@parameter.inner" }, -- swap arg with prev
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      --------------------------------------------------------------------------
      -- OPTIONAL: If <CR>/<BS> for incremental selection feels disruptive,
      --           comment out the incremental_selection keymaps above and use:
      --           vim.keymap.set("n", "<leader>v", function()
      --             require("nvim-treesitter.incremental_selection").init_selection()
      --           end, { desc = "TS: start selection" })
      --           vim.keymap.set("n", "<leader>=", function()
      --             require("nvim-treesitter.incremental_selection").node_incremental()
      --           end, { desc = "TS: grow node" })
      --           vim.keymap.set("n", "<leader>-", function()
      --             require("nvim-treesitter.incremental_selection").node_decremental()
      --           end, { desc = "TS: shrink node" })
      --           vim.keymap.set("n", "<leader>V", function()
      --             require("nvim-treesitter.incremental_selection").scope_incremental()
      --           end, { desc = "TS: grow scope" })
      --------------------------------------------------------------------------
    end,
  },
}
