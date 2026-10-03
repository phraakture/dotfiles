#!/usr/bin/env bash
# Idempotent symlinker for this dotfiles repo.
# Layout: each top-level dir maps to ~/.config/<name>; zsh/ maps into $HOME.
# Existing non-symlink targets are moved aside to <target>.bak before linking.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() { # link <repo-relative-path> <absolute-target>
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ] && { echo "ok      $dst"; return; }
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak"
    echo "backup  $dst -> $dst.bak"
  fi
  ln -s "$src" "$dst"
  echo "linked  $dst -> $src"
}

# Create an untracked, mode-600 secrets file from a template if it does not exist.
secret() { # secret <absolute-path> <template-content>
  local dst="$1" tpl="$2"
  [ -e "$dst" ] && { echo "ok      $dst (exists, left alone)"; return; }
  mkdir -p "$(dirname "$dst")"
  (umask 077; printf '%s\n' "$tpl" > "$dst")
  echo "created $dst  <-- fill this in"
}

# --- ~/.config/<name> ---
link hypr      "$HOME/.config/hypr"
link kitty     "$HOME/.config/kitty"
link nvim      "$HOME/.config/nvim"
link waybar    "$HOME/.config/waybar"
link starship  "$HOME/.config/starship"

# --- zsh: $HOME-level files ---
link zsh/.zshenv   "$HOME/.zshenv"
link zsh/.zshrc    "$HOME/.zshrc"
link zsh/.user.zsh "$HOME/.user.zsh"
link zsh/.p10k.zsh "$HOME/.p10k.zsh"

# --- zsh: files inside $ZDOTDIR (~/.config/zsh is HyDE-managed; only link our own files) ---
link zsh/zdotdir/.zshrc           "$HOME/.config/zsh/.zshrc"
link zsh/zdotdir/conf.d/binds.zsh "$HOME/.config/zsh/conf.d/binds.zsh"

# --- machine-local secrets (never tracked; see README) ---
secret "$HOME/.config/zsh/secrets.zsh" '# Machine-local secrets. Sourced by ~/.zshrc. Not tracked.
# export ANTHROPIC_API_KEY="..."'
secret "$HOME/.gitconfig.local" '# Machine-local git settings. Included from ~/.config/git/config. Not tracked.
# [sendemail]
# 	smtppass = ...'

# Legacy ~/.gitconfig would shadow ~/.config/git/config; warn if one exists.
if [ -e "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
  echo "WARN    ~/.gitconfig exists and takes precedence over ~/.config/git/config; merge it and remove it."
fi

echo "done."
