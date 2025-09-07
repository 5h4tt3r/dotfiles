-- ~/dotfiles/nvim/.config/nvim/lua/plugins/lsp.lua
--
-- PURPOSE
-- -------
-- Turn Neovim into a modern IDE:
--   • Mason:      Installs external *tools/LSP servers* for you.
--   • lspconfig:  Wires those servers into Neovim’s LSP client.
--   • blink.cmp:  Fast, modern completion (LSP + buffer + path + snippets).
--   • LuaSnip:    Snippet engine; friendly-snippets: big snippet collection.
--   • neodev:     Better Lua completion when editing your Neovim config.
--
-- IMPORTANT NOTE ABOUT PYTHON:
--   • pyrefly is a *CLI type checker*, NOT an LSP server. Keep it installed
--     via Mason/uv for CI/local checks, but do NOT configure it under lspconfig.
--   • For editor features (hover, go-to-def, diagnostics, inlay hints, etc.),
--     we use a real LSP server: pyright (configured below).
--
-- DESIGN
-- ------
-- 1) Install/manage servers with Mason (UI: :Mason).
-- 2) Tell Mason which servers to ensure are installed (ensure_installed).
-- 3) Configure LSP client visuals (diagnostics UI) with the *modern* API.
-- 4) Set buffer-local LSP keymaps on server attach (clean global space).
-- 5) Merge blink.cmp completion capabilities so servers know our features.

return {
  ---------------------------------------------------------------------------
  -- 1) Mason: external tool & LSP installer
  ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",  -- keep registry fresh on updates
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- 2) mason-lspconfig: sync Mason installs with lspconfig server names
  ---------------------------------------------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- Only list *real LSP servers* here. (pyrefly is NOT an LSP server.)
      ensure_installed = {
        "pyright",        -- Python LSP (editor features)
        "rust_analyzer",  -- Rust
        "gopls",          -- Go
        "clangd",         -- C/C++
        "zls",            -- Zig
        "tinymist",       -- Typst
        "lua_ls",         -- Lua (Neovim config)
      },
      automatic_installation = true,
    },
  },

  ---------------------------------------------------------------------------
  -- 3) nvim-lspconfig: actual LSP setup (diagnostics + keymaps + servers)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",   -- better Lua for Neovim config
      "saghen/blink.cmp",    -- completion capabilities
    },
    config = function()
      -----------------------------------------------------------------------
      -- A) Diagnostics UI (modern API; no deprecated sign_define)
      -----------------------------------------------------------------------
      local diag = vim.diagnostic
      diag.config({
        signs = {
          text = {
            [diag.severity.ERROR] = "",
            [diag.severity.WARN]  = "",
            [diag.severity.INFO]  = "",
            [diag.severity.HINT]  = "",
          },
        },
        virtual_text = { spacing = 2, prefix = "●" },
        underline = true,
        update_in_insert = false, -- don’t flicker while typing
        severity_sort = true,
        float = { border = "rounded" },
      })

      -----------------------------------------------------------------------
      -- B) neodev BEFORE lua_ls so it improves Lua completion
      -----------------------------------------------------------------------
      require("neodev").setup({})

      -----------------------------------------------------------------------
      -- C) Buffer-local LSP keymaps on attach
      -----------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = bufnr, silent = true, noremap = true, desc = desc
            })
          end

          -- NAVIGATION / INFO
          map("n", "gd", vim.lsp.buf.definition,          "LSP: go to definition")
          map("n", "gD", vim.lsp.buf.declaration,         "LSP: go to declaration")
          map("n", "gr", vim.lsp.buf.references,          "LSP: references")
          map("n", "gi", vim.lsp.buf.implementation,      "LSP: implementations")
          map("n", "gy", vim.lsp.buf.type_definition,     "LSP: type definition")
          map("n", "K",  vim.lsp.buf.hover,               "LSP: hover docs")

          -- REFACTOR / ACTIONS
          map("n", "<leader>rn", vim.lsp.buf.rename,      "LSP: rename symbol")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")

          -- DIAGNOSTICS
          map("n", "[d", vim.diagnostic.goto_prev,        "Diagnostics: previous")
          map("n", "]d", vim.diagnostic.goto_next,        "Diagnostics: next")
          map("n", "gl", vim.diagnostic.open_float,       "Diagnostics: line info")

          -- FORMAT (server formatter if supported; Step 6 adds none-ls)
          map("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, "LSP: format buffer")

          -- INLAY HINTS (Neovim 0.10+); safe no-op on older NVIM
          if vim.lsp.inlay_hint then
            map("n", "<leader>li", function()
              local buf = bufnr
              local on = vim.lsp.inlay_hint.is_enabled and vim.lsp.inlay_hint.is_enabled(buf)
              vim.lsp.inlay_hint.enable(buf, not on)
            end, "LSP: toggle inlay hints")
          end
        end,
      })

      -----------------------------------------------------------------------
      -- D) Completion capabilities from blink.cmp (if present)
      -----------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink and blink.get_lsp_capabilities then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -----------------------------------------------------------------------
      -- E) Per-server settings (override where helpful)
      -----------------------------------------------------------------------
      local lspconfig = require("lspconfig")

      local servers = {
        -- PYTHON (LSP server for editor features)
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  callArgumentNames = true,
                },
              },
            },
          },
        },

        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            }
          },
        },

        gopls = {},
        clangd = { cmd = { "clangd", "--background-index" } },
        zls = {},
        tinymist = {},

        -- LUA: fix “undefined global: vim” & quieten workspace prompts
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      }

      -- Setup servers with shared capabilities
      for name, opts in pairs(servers) do
        opts.capabilities = capabilities
        lspconfig[name].setup(opts)
      end

      -- NOTE: pyrefly is *not* configured here because it’s NOT an LSP server.
      -- Keep it installed and run it as a CLI (`:!pyrefly check .`) or via CI.
    end,
  },

  ---------------------------------------------------------------------------
  -- 4) blink.cmp: modern completion
  --    (No unsupported "snippet" field to avoid schema warnings.)
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { border = "rounded" },
      },
      signature = { enabled = true },
      keymap = { preset = "default" }, -- Tab/Shift-Tab navigate; Enter accept; Ctrl-Space trigger
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}

