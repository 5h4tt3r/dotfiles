
Hottkeys Cheat Sheet
_A quick reference to navigate projects, edit faster, and leverage Zed’s modern features while staying in Vim mode._

---

## 🗂 File Tree & Project Navigation
- Open Project Panel (file tree): `:E` (or `:Explore`)
- Navigate inside file tree: `h j k l` (Vim-like)
- Open file: `o`
- Open file in new tab: `t`
- Split open:
  - Vertical: `:vnew`
  - Horizontal: `:new`

---

## 🔍 Semantic Code Navigation
- Go to definition: `g d`
- Go to declaration: `g D`
- Go to type definition: `g y`
- Go to implementation: `g I`
- Rename symbol (refactor): `c d`
- Find references: `g A`
- Find symbol in file/project:
  - Current file: `g s`
  - Entire project: `g S`

---

## 🔀 Splits & Pane Management
- Vertical split: `:vsplit` or `:vs`
- Horizontal split: `:split` or `:sp`
- New file in split: `:new` or `:vnew`
- Switch panes (like Vim):
  - `ctrl-w h` → left pane
  - `ctrl-w l` → right pane
  - `ctrl-w j` → down
  - `ctrl-w k` → up

---

## 📑 Tabs & Buffers
- New tab: `:tabnew` or `:tabedit`
- Next tab: `:tabn`
- Previous tab: `:tabp`
- Close tab: `:tabc`
- List open buffers: `:ls`

---

## 🔄 Multiple Cursors (Zed-specific Vim Enhancements)
> These are Zed’s modern multi-cursor features, built on top of Vim motions.

- Add cursor at next match: `g l`
- Add cursor at previous match: `g L`
- Select all matches: `g a`
- Skip current, jump to next: `g >`
- Skip current, jump to previous: `g <`

### 🏹 Motion Shortcuts (Combine with cursors!)
**Word motions:**
- `w` → next word start
- `e` → next word end
- `ge` → previous word end
- `b` → previous word start

**Line motions:**
- `0` → start of line
- `^` → first non-whitespace char
- `$` → end of line

**File motions:**
- `gg` → top of file
- `G` → bottom of file
- `{` / `}` → prev/next paragraph or block

✅ Example combos:
- `g a` → `$` → every cursor moves to line end across the file.
- `g l` → `w` → every cursor jumps to start of next word.
- `g a` → `e` → select all word ends in file.

---

## ✂️ Essential Vim Editing Commands
- Insert mode: `i`, `a`, `o`
- Delete: `d w` (word), `d d` (line)
- Yank (copy): `y w`, `y y` (line)
- Paste: `p` (after), `P` (before)
- Change: `c w` (change word), `c c` (line)
- Undo/Redo: `u` / `ctrl-r`
- Visual mode: `v` (char), `V` (line), `ctrl-v` (block)
- Search forward/backward: `/pattern`, `?pattern`
- Repeat last command: `.`

---

## 📜 Ex Command Mode (:)
- Save file: `:w`
- Save & quit: `:wq`
- Quit file: `:q`
- Save all files: `:wa`
- Save all + quit all: `:wqa`
- Force quit: `:q!`
- Jump to line: `:42`
- Search & replace:
  - Current line: `:s/foo/bar/g`
  - Whole file: `:%s/foo/bar/g`
- Project search: `g /` (project-wide), `g <space>` (excerpt)
- Git panel: `:G`
- Terminal panel: `:te`

---

## ⚡️ Quick Pro Tips
- Use relative line numbers (`"toggle_relative_line_numbers": true` in settings).
- Enable wrapping left/right so `h/l` wrap across lines.
- Use surround (`y s`, `c s`, `d s`) for quotes/brackets.
- Comment toggles: `g c c` (line), `g c` (visual mode).

---
