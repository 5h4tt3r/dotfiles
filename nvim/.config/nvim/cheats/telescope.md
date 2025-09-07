# 🔭 Telescope Cheat Sheet

Telescope = fuzzy finder / project search for Neovim.  
Requires **ripgrep** + **fd** installed.

Leader = backtick (\`)  

---

## 🚀 Launching Pickers

- `<leader>ff` → Find files (respects ignore)
- `<leader>fF` → Find ALL files (even ignored, hidden)
- `<leader>fg` → Live grep (ripgrep across project)
- `<leader>fs` → Grep: word under cursor
- `<leader>fS` → Grep: exact word match
- `<leader>fp` → Grep only `.py` + `.md` files (DS focused)
- `<leader>f/` → Search within current buffer
- `<leader>fb` → Open buffers
- `<leader>fr` → Recent files
- `<leader>fd` → Diagnostics (needs LSP later)

### Git pickers
- `<leader>gs` → Git status
- `<leader>gc` → Git commits
- `<leader>gC` → Git commits (current buffer)

---

## 📂 Inside Telescope

**Navigation**
- `<C-j>` / `<C-k>` → move selection down/up
- `<C-n>` / `<C-p>` → cycle history
- `<Tab>` / `<S-Tab>` → mark multiple results

**Open file**
- `<CR>` → open in current window
- `<C-v>` → vertical split
- `<C-x>` → horizontal split
- `<C-t>` → new tab

**Multi-select**
- `<Tab>` to mark results → `<C-q>` send them to **quickfix list**
- Navigate quickfix with `:cnext` / `:cprev` (or `]q` / `[q`)

**Preview**
- `<M-p>` (Alt+p) → toggle preview window

**Exit**
- `<esc>` (insert mode) or `q` (normal mode)

---

## ⚡️ Example Workflows

- **Software Dev**  
  - Find `User` model: `<leader>fg` → type "User" → `<CR>`  
  - Inspect commits: `<leader>gc` → scroll through → `<CR>`  

- **Data Science**  
  - Search all notebooks for `DataFrame`: `<leader>fp` → type "DataFrame" → preview opens  
  - Collect TODOs across repo: `<leader>fg` → search "TODO" → `<Tab>` mark interesting → `<C-q>` to quickfix and step through  


