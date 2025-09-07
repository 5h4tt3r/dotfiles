-- Cheats palette:
-- :Cheats      -> pick a cheatsheet (from ~/.config/nvim/cheats), open in float
-- :CheatsLive  -> live-grep across cheats
-- <leader>ch   -> convenience mapping for :Cheats

return {
  {
    "nvim-telescope/telescope.nvim",

    -- Ensure Telescope is present (we’ll lazy-load it when needed).
    dependencies = { "nvim-lua/plenary.nvim" },

    -- Define user commands *at startup* so :Cheats exists before plugin loads.
    init = function()
      -- Where your stowed cheats live (already created earlier)
      local cheats_dir = vim.fn.expand("~/.config/nvim/cheats")

      -- Floating markdown viewer (read-only, q/esc to close)
      local function open_in_float(filepath)
        local ok, lines = pcall(vim.fn.readfile, filepath)
        if not ok then
          vim.notify("Failed to read: " .. filepath, vim.log.levels.ERROR)
          return
        end
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].filetype = "markdown"
        vim.bo[buf].modifiable = false
        vim.bo[buf].bufhidden = "wipe"

        local ui = vim.api.nvim_list_uis()[1]
        local width  = math.min(100, math.floor(ui.width  * 0.8))
        local height = math.min(30,  math.floor(ui.height * 0.7))
        local row = math.floor((ui.height - height) / 2)
        local col = math.floor((ui.width  - width ) / 2)

        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          style = "minimal",
          border = "rounded",
          row = row, col = col, width = width, height = height,
        })
        vim.wo[win].winblend = 0
        vim.wo[win].wrap = true

        local opts = { buffer = buf, silent = true, nowait = true }
        vim.keymap.set("n", "q",     function() pcall(vim.api.nvim_win_close, win, true) end, opts)
        vim.keymap.set("n", "<esc>", function() pcall(vim.api.nvim_win_close, win, true) end, opts)
      end

      -- :Cheats -> file picker rooted at cheats_dir, <CR> opens float
      vim.api.nvim_create_user_command("Cheats", function()
        if vim.fn.isdirectory(cheats_dir) == 0 then
          vim.notify("Cheat sheets dir not found: " .. cheats_dir, vim.log.levels.WARN)
          return
        end

        -- This require will lazy-load Telescope if it isn’t loaded yet.
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        builtin.find_files({
          cwd = cheats_dir,
          prompt_title = "Cheat Sheets",
          hidden = false,
          attach_mappings = function(_, map)
            local function open_float_action(prompt_bufnr)
              local entry = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              if entry and entry.path then open_in_float(entry.path) end
            end
            map("i", "<CR>", open_float_action)
            map("n", "<CR>", open_float_action)
            return true
          end,
        })
      end, {})

      -- :CheatsLive -> live-grep across cheats_dir
      vim.api.nvim_create_user_command("CheatsLive", function()
        if vim.fn.isdirectory(cheats_dir) == 0 then
          vim.notify("Cheat sheets dir not found: " .. cheats_dir, vim.log.levels.WARN)
          return
        end
        require("telescope.builtin").live_grep({
          cwd = cheats_dir,
          prompt_title = "Cheat Sheets (live grep)",
        })
      end, {})

      -- Optional mapping: <leader>ch opens :Cheats
      vim.keymap.set("n", "<leader>ch", "<cmd>Cheats<CR>", { desc = "Cheat sheets" })
    end,
  },
}

