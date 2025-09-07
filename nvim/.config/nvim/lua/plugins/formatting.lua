-- ~/dotfiles/nvim/.config/nvim/lua/plugins/formatting.lua
--
-- Code formatting (and optional linting) via none-ls.nvim (formerly null-ls)
-- - Plays nicely with your LSPs: for each filetype we decide whether to
--   format with none-ls or the language server's own formatter (e.g. gopls).
-- - Python: use ruff format (fast) by default; black optional.
-- - JS/TS/JSON/MD: use prettierd if available (or prettier).
-- - Lua: stylua
-- - Shell: shfmt
-- - C/C++: clang-format (if you want LSP clangd to format instead, remove it)
-- - Rust/Go: we generally prefer the LSP formatter (rust-analyzer, gopls)
--
-- Notes:
-- • none-ls is a *bridge* to external CLIs. It won’t “auto-install” them.
-- • Use your project manager (uv) to install ruff/black/etc per-project, OR
--   use :Mason to install global copies for quick setup.
-- • We wire an on-save autoformat that prefers the best formatter per language.

return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      -- Optional bridge to install tools via Mason (nice, not required):
      "jay-babu/mason-null-ls.nvim",
      -- If you want prettierd installed easily:
      "williamboman/mason.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },

    opts = function()
      local null_ls = require("null-ls")
      local builtins = null_ls.builtins

      --------------------------------------------------------------------------
      -- Choose the formatters / linters (sources) you want none-ls to expose
      --------------------------------------------------------------------------
      local sources = {
        ----------------------------------------------------------------------
        -- PYTHON
        ----------------------------------------------------------------------
        -- Formatter (default): ruff format
        --   CLI priority:
        --   - Uses the "ruff" binary found on PATH (project venv via uv is ideal)
        builtins.formatting.ruff, -- ruff >= 0.4.0 supports `ruff format`

        -- Optional alternative: black (comment in if you prefer Black)
        -- builtins.formatting.black.with({
        --   extra_args = { "--fast" },
        -- }),

        -- Optional import sorter: isort (only if you want it)
        -- builtins.formatting.isort,

        -- Diagnostics (linting) via ruff CLI (separate from ruff-lsp):
        -- If you prefer ruff *only* through ruff-lsp, leave this off.
        -- builtins.diagnostics.ruff,

        ----------------------------------------------------------------------
        -- JAVASCRIPT / TYPESCRIPT / JSON / MARKDOWN
        ----------------------------------------------------------------------
        -- Prefer prettierd (daemon) for speed; fallback would be prettier
        builtins.formatting.prettierd.with({
          -- You can constrain filetypes to be explicit:
          filetypes = {
            "javascript", "javascriptreact", "typescript", "typescriptreact",
            "vue", "svelte",
            "json", "jsonc",
            "yaml", "markdown", "markdown_inline",
            "html", "css", "scss",
          },
        }),

        ----------------------------------------------------------------------
        -- LUA
        ----------------------------------------------------------------------
        builtins.formatting.stylua,

        ----------------------------------------------------------------------
        -- SHELL
        ----------------------------------------------------------------------
        builtins.formatting.shfmt, -- formats sh/bash/zsh

        ----------------------------------------------------------------------
        -- C / C++  (remove if you prefer clangd to handle formatting instead)
        ----------------------------------------------------------------------
        builtins.formatting.clang_format,

        ----------------------------------------------------------------------
        -- (You can add more, e.g. typstfmt when it’s packaged for none-ls)
        ----------------------------------------------------------------------
      }

      --------------------------------------------------------------------------
      -- Helper: pick which client formats on save for each filetype
      --
      -- Strategy:
      -- • python, javascript, typescript, json, markdown, lua, sh, c/c++:
      --     prefer none-ls (our external formatters above)
      -- • go, rust:
      --     prefer the LSP's native formatter (gofmt/gopls, rustfmt via rust-analyzer)
      --------------------------------------------------------------------------
      local prefer_none_ls_ft = {
        python = true,
        javascript = true, javascriptreact = true,
        typescript = true, typescriptreact = true,
        json = true, jsonc = true, markdown = true, markdown_inline = true,
        lua = true, sh = true, bash = true, zsh = true,
        c = true, cpp = true,
      }

      local function format_filter(client)
        local ft = vim.bo.filetype
        if ft == "go" or ft == "rust" then
          -- Prefer the language server (gopls / rust-analyzer)
          return client.name ~= "null-ls"
        end
        -- For most others, prefer null-ls (none-ls):
        if prefer_none_ls_ft[ft] then
          return client.name == "null-ls"
        end
        -- If we don't have an opinion, allow anyone:
        return true
      end

      --------------------------------------------------------------------------
      -- Autoformat on save (you can toggle off by commenting this block)
      --------------------------------------------------------------------------
      local aug = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = aug,
        callback = function()
          -- Skip huge buffers or special buffers
          if vim.bo.readonly or not vim.bo.modifiable then return end
          -- Call the best formatter based on our filter
          vim.lsp.buf.format({
            timeout_ms = 4000,
            filter = format_filter,
          })
        end,
      })

      return {
        sources = sources,
        -- Make diagnostics/format UI nice:
        diagnostics_format = "[#{c}] #{m} (#{s})", -- e.g. "[E] message (ruff)"
        update_in_insert = false,
      }
    end,

    config = function(_, opts)
      -- none-ls setup
      local null_ls = require("null-ls")
      null_ls.setup(opts)

      ------------------------------------------------------------------------
      -- OPTIONAL: automatically ensure tools exist via Mason
      -- If you prefer managing tools via `uv` per project, you can disable this.
      ------------------------------------------------------------------------
      local ok, mason_null_ls = pcall(require, "mason-null-ls")
      if ok then
        mason_null_ls.setup({
          ensure_installed = {
            -- Comment in the ones you want Mason to manage globally:
            -- "ruff", "black", "isort",
            -- "stylua",
            -- "prettierd",
            -- "shfmt",
            -- "clang-format",
          },
          automatic_installation = false, -- keep false if you prefer uv/project tools
          handlers = {}, -- not strictly needed here
        })
      end
    end,
  },
}

