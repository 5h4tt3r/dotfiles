# 🌲 Tree-sitter Cheat Sheet (Neovim)

**What it is:** A parser that understands code structure (functions, classes, blocks, parameters).  
**Why you care:** Better highlighting/indentation _plus_ powerful motions and selections.

---

## 🔀 Motions (jump by structure)
- `]m` → next **function start**
- `[m` → prev **function start**
- `]M` → next **function end**
- `[M` → prev **function end**
- `]]` → next **class start**
- `[[` → prev **class start**
- `][` → next **class end**
- `[]` → prev **class end**

**Use cases**
- Skim a codebase: repeatedly press `]m` to hop function-to-function.
- Review class APIs: `[[` / `]]` to move between classes.

---

## 🧩 Text objects (use with `d`, `y`, `c`, `v`)
- `af` / `if` → a function / inner function
- `ac` / `ic` → a class / inner class
- `aa` / `ia` → an argument (parameter) / inner argument

**Examples**
- `vaf` → visually select entire function (signature + body).
- `yif` → yank only the function body.
- `daa` while cursor on a param → delete that argument.

---

## ➕ Incremental selection (grow/shrink by node)
**If using defaults:**  
- `<CR>` → start / grow selection  
- `<S-CR>` → grow by scope  
- `<BS>` → shrink

**If using leader (example):**  
- `` `v `` start, `` `= `` grow, `` `- `` shrink, `` `V `` scope grow

**Use cases**
- Select a symbol → grow to expression → grow to statement → grow to containing block → function → class.

---

## 🧠 Dev Workflow Examples
- **Refactor function:** `vaf` then move/indent or yank to new file.  
- **Swap function args:** `]a` / `[a` to swap current arg with next/prev.  
- **Navigate fast:** `]m` to jump to next function when tracing logic.

## 📊 Data Science Examples
- **Experiment isolation:** `yif` to yank only function body (e.g., a plotting routine) into a scratch file.  
- **Clean notebooks turned scripts:** Use motions to hop and tidy functions/classes.

---

## Troubleshooting
- Update parsers: `:TSUpdate` (or restart; lazy.nvim runs build hooks).
- See installed parsers: `:TSInstallInfo`

