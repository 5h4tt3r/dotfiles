# ==========================
# 1. Environment Variables
# ==========================
export PATH="$PATH:/opt/homebrew/bin"

# ==========================
# 2. Plugins
# ==========================
# Zsh syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Zsh autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ==========================
# 3. Prompt
# ==========================
# Starship prompt (must be last in prompt-related configs)
eval "$(starship init zsh)"

# ==========================
# 4. Startup Commands
# ==========================
# Show Fastfetch on interactive shells
if [[ $- == *i* ]] && command -v fastfetch >/dev/null; then
  # Uncomment next line if you like a clean slate
  # clear
  fastfetch
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- zoxide (smart cd) ---
eval "$(zoxide init zsh)"

# ---- eza aliases (replace ls) ----
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -F --group-directories-first'    # -F: classify (/ for dirs), nice default
  alias ll='eza -l --git --group-directories-first'
  alias la='eza -la --git --group-directories-first'
  alias lt='eza --tree --level=2 --group-directories-first'
fi
# To bypass the alias in a pinch: use \ls or command ls
# --------------------------------

export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"
