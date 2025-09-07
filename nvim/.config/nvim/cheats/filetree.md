# 📂 Neovim File Management Cheat Sheet

> Two tools:  
> **neo-tree** = full sidebar tree (right side, persistent, with git status)  
> **oil.nvim** = quick floating “finder-like” directory buffer  

Leader = backtick (`)  

---

## 🔲 Neo-tree (sidebar file tree, right)

**Launch / focus**
- `<leader>e` → Toggle file tree (open/close sidebar)
- `<leader>E` → Reveal current file in tree & focus it
- `q` or `esc` inside → Close tree

**Navigation**
- `<CR>` or `o` → Open file / expand folder  
- `<` / `>` → Switch source (filesystem, buffers, git)

**CRUD (files/folders)**
- `a` → Add new file  
- `A` → Add new directory  
- `r` → Rename  
- `d` → Delete  
- `y` → Copy to clipboard  
- `x` → Cut to clipboard  
- `p` → Paste from clipboard  
- `m` → Move (prompt for new location)

**Splits / tabs**
- `s` → Open in horizontal split  
- `v` → Open in vertical split  
- `t` → Open in new tab  

---

## 🪟 Oil.nvim (floating directory-as-buffer)

**Launch**
- `-` → Open parent directory in floating Oil window  
- `<leader>-` → Same as above (leader variant)  
- `q` / `esc` → Close float

**Navigation**
- `<CR>` → Open file / enter directory  
- `-` → Go up one directory  
- `H` → Toggle hidden files  

**CRUD**
- `a` → Create file/directory  
- `d` → Delete  
- `r` → Rename  
- `y` → Copy (stage)  
- `x` → Move (stage)  
- `p` → Paste  

**Splits / tabs**
- `<C-v>` → Vertical split  
- `<C-s>` → Horizontal split  
- `<C-t>` → New tab  

---

## ⚡️ Typical Workflows

- **Sidebar for context**:  
  `<leader>e` → glance at project structure → open file.  

- **Reveal current file in tree**:  
  Editing deep in `/models/train.py` → `<leader>E` → instantly see where it lives in the tree.  

- **Quick file creation**:  
  Editing → need `notes.md` in `data/raw/`. Press `-` (Oil float) → navigate into `data/raw` → `a` → type `notes.md` → `<CR>`.  

- **Bulk move/rename**:  
  In Oil: mark files with `x`, go to target dir, `p`.
