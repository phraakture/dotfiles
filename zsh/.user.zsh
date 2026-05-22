# ═══════════════════════════════════════════════════════════
#  ~/.user.zsh — Personal aliases, plugins, functions
# ═══════════════════════════════════════════════════════════


# ──────────────────────────────────────────────────────────
#  Zsh plugins
# ──────────────────────────────────────────────────────────

# oh-my-zsh plugins (loaded via HyDE in ~/.hyde.zshrc)
plugins=(
  "sudo"
)

# Autopair — auto-close quotes and brackets
source ~/.zsh/zsh-autopair/autopair.zsh


# ──────────────────────────────────────────────────────────
#  Aliases — Navigation & shell
# ──────────────────────────────────────────────────────────

alias a='anchor'
alias k='kubectl'
alias p='pnpm'
alias ss='source ~/.zshrc'


# ──────────────────────────────────────────────────────────
#  Aliases — Git
# ──────────────────────────────────────────────────────────

alias gc='git commit -s -m'
alias gch='git checkout'
alias gp='git push'


# ──────────────────────────────────────────────────────────
#  Aliases — Dev runners
# ──────────────────────────────────────────────────────────

alias nd='npm run dev'
alias pd='pnpm run dev'
alias yd='yarn run dev'


# ──────────────────────────────────────────────────────────
#  Aliases — Cargo / Rust
# ──────────────────────────────────────────────────────────

alias cc='cargo check'
alias cr='cargo run'
alias ct='cargo test'
alias cb='cargo build'


# ──────────────────────────────────────────────────────────
#  Aliases — Vim shortcuts
# ──────────────────────────────────────────────────────────

alias vl='vi src/lib.rs'
alias vm='vi src/main.rs'


# ──────────────────────────────────────────────────────────
#  Aliases — Misc
# ──────────────────────────────────────────────────────────

alias db='echo DATABASE_URL=postgresql://postgres:cupcake@localhost:5432/db'
alias xtree="tree -L 3 -I '.*|node_modules'"
alias comp='g++ -std=c++17 -O2 -Wall main.cpp -o a'
alias gocp='cd ~/cp'


# ──────────────────────────────────────────────────────────
#  Functions
# ──────────────────────────────────────────────────────────

# Append a timestamped log entry to ./log.md
log2() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> ./log.md
}

# Deduplicate PATH entries
typeset -U PATH path
