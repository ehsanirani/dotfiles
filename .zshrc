plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Modern CLI aliases
alias ls='eza --icons --git'
alias ll='eza -l --icons --git'
alias cat='bat'
alias find='fd'
alias grep='rg'
alias cd='z'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
# Linuxbrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# rust
. "$HOME/.cargo/env"

#eval "$(starship init zsh)"
#eval "$(oh-my-posh init zsh --config negligible )"
#eval "$(oh-my-posh init zsh --config powerlevel10k_lean )"
eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/powelevel10k_lean_extended.omp.json )"
#eval "$(oh-my-posh init zsh --config negligible )"
#eval "$(oh-my-posh init zsh --config avit )"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

eval "$(zoxide init zsh)"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/ehsan/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

. "$HOME/.local/bin/env"
export UV_CACHE_DIR="/mnt/archive/ehsan/.cache/uv"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
