-- SQL in Neovim: vim-dadbod + UI + completion
-- Works great on the REMOTE (SageMaker) host to talk to Snowflake (or others).
-- DO NOT hardcode secrets in Git. Use env vars or .netrc/.aws, etc.

return {
  -- Core
  { "tpope/vim-dadbod", event = "VeryLazy" },

  -- UI browser
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-completion" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      -- Save UI files to a local dir (won't pollute your project)
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
      vim.g.db_ui_use_nerd_fonts = 1

      --------------------------------------------------------------------------
      -- Connection setup:
      -- Preferred: put a DSN in an ENV VAR on the SageMaker host, e.g.:
      --   export SNOWFLAKE_DSN="snowflake://USER:PASSWORD@ACCOUNT_NAME/DB/SCHEMA?warehouse=WAREHOUSE&role=ROLE"
      --
      -- Read it here safely:
      local snowflake_dsn = vim.fn.getenv("SNOWFLAKE_DSN")
      -- You can define multiple connections:
      vim.g.dbs = {
        -- Appears in DBUI as "snowflake"
        snowflake = snowflake_dsn ~= "" and snowflake_dsn or nil,
        -- Add others here, e.g. postgres = vim.fn.getenv("PG_DSN"),
      }
      --------------------------------------------------------------------------
    end,
    keys = {
      { "<leader>dq", "<cmd>DBUI<cr>",       desc = "DB: open UI" },
      { "<leader>dQ", "<cmd>DBUIToggle<cr>", desc = "DB: toggle UI" },
      { "<leader>dr", "<cmd>DBUIFindBuffer<cr>", desc = "DB: find query buffer" },
    },
  },

  -- Completion inside SQL buffers (tables/columns, etc.)
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    init = function()
      -- If you're using blink.cmp, add 'omni' source for SQL buffers:
      -- blink.cmp will pick up vim's omnifunc (provided by dadbod-completion).
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.bo.omnifunc = "vim_dadbod_completion#omni"
        end,
      })
    end,
  },
}

