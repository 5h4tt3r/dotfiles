-- Molten: notebook-like Python execution in regular .py files using # %% cells.
-- Shows outputs (and figures) inline via image.nvim.
-- Python-side deps (install in your venv via uv):
--   uv add ipykernel ipython jupyter-client jupyter-core matplotlib plotly
-- Then register a kernel: python -m ipykernel install --user --name sagemaker-ds

return {
  {
    "benlubas/molten-nvim",
    ft = { "python" }, -- load when editing Python
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins", -- Recommended by molten
    init = function()
      -- Pick a default kernel name (you can switch per-file via <leader>mk)
      vim.g.molten_default_kernel = "sagemaker-ds"

      -- Use image.nvim to render rich outputs
      vim.g.molten_image_provider = "image.nvim"

      -- Store Molten notebooks & outputs in project; change if you prefer elsewhere
      vim.g.molten_auto_open_output = true
      vim.g.molten_save_path = ".molten"

      -- Cell markers: we use VSCode/Jupytext %-style (# %%)
      -- recognized both markers
      vim.g.molten_cell_marker = { [[^#%%]], [[^# %%]], [[^#%%.*]] }
    end,
    config = function()
      local map = function(lhs, rhs, desc, mode)
        vim.keymap.set(mode or "n", lhs, rhs, { silent = true, desc = desc })
      end

    -- 🔌 Initialization / Kernel
      map("<leader>mk", "<cmd>MoltenInit<cr>", "Molten: init / select kernel")

      -- ▶️ Execution
      map("<leader>mr", "<cmd>MoltenEvaluateOperator<cr>", "Molten: run motion/selection", { "n", "v" })
      map("<leader>mR", "<cmd>MoltenReevaluateAll<cr>",    "Molten: run entire buffer")
      map("<leader>mc", "<cmd>MoltenReevaluateCell<cr>",   "Molten: run current cell")
      map("<leader>mo", "<cmd>MoltenShowOutput<cr>",       "Molten: show last output")

      -- ⚙️ Kernel Management
      map("<leader>mK", "<cmd>MoltenRestart<cr>",   "Molten: restart kernel")
      map("<leader>mi", "<cmd>MoltenInterrupt<cr>", "Molten: interrupt execution")

      -- 🧭 Cell Navigation
      map("]m", "<cmd>MoltenNext<cr>", "Molten: next cell")
      map("[m", "<cmd>MoltenPrev<cr>", "Molten: prev cell")

      -- ℹ️ Extra useful commands
      map("<leader>ms", "<cmd>MoltenSave<cr>",          "Molten: save outputs")
      map("<leader>mh", "<cmd>MoltenHideOutput<cr>",    "Molten: hide output")
      map("<leader>me", "<cmd>MoltenExportOutput<cr>",  "Molten: export output")
      map("<leader>miB", "<cmd>MoltenInfo<cr>",         "Molten: kernel info")
    end,
  },
}

