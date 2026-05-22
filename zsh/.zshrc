# ═══════════════════════════════════════════════════════════
#  ~/.zshrc — Main shell config (HyDE managed + user additions)
# ═══════════════════════════════════════════════════════════

# ──────────────────────────────────────────────────────────
#  PATH additions
# ──────────────────────────────────────────────────────────

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.foundry/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

# Go
export PATH="$PATH:$(go env GOPATH)/bin"

# Solana (guarded to prevent duplicate entries)
export SOLANA_HOME="$HOME/.local/share/solana/install/active_release/bin"
case ":$PATH:" in
  *":$SOLANA_HOME:"*) ;;
  *) export PATH="$SOLANA_HOME:$PATH" ;;
esac


# ──────────────────────────────────────────────────────────
#  Environment variables
# ──────────────────────────────────────────────────────────

export EDITOR=code
export LIBVA_DRIVER_NAME=iHD
export NODE_OPTIONS="--max-old-space-size=6144"


# ──────────────────────────────────────────────────────────
#  Rust
# ──────────────────────────────────────────────────────────

source "$HOME/.cargo/env"


# ──────────────────────────────────────────────────────────
#  NVM — Node Version Manager
# ──────────────────────────────────────────────────────────

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ]          && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"


# ──────────────────────────────────────────────────────────
#  Bun
# ──────────────────────────────────────────────────────────

export BUN_INSTALL="$HOME/.bun"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


# ──────────────────────────────────────────────────────────
#  Pyenv
# ──────────────────────────────────────────────────────────

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"


# ──────────────────────────────────────────────────────────
#  Wasmer
# ──────────────────────────────────────────────────────────

export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"


# ──────────────────────────────────────────────────────────
#  Kubectl completions
# ──────────────────────────────────────────────────────────

if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi


# ──────────────────────────────────────────────────────────
#  Shell limits
# ──────────────────────────────────────────────────────────

# Remove stack size limit (needed for cp on large files)
ulimit -s unlimited
