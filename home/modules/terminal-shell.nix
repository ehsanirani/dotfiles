{ config, pkgs, lib, ... }:
let
  ompTheme = ../config/oh-my-posh/powerlevel10k_lean_extended.omp.json;
in
{
  # XDG config files for terminals
  xdg.configFile = {
    "wezterm/wezterm.lua".source = ../config/wezterm/wezterm.lua;
    "zellij/config.kdl".source   = ../config/zellij/config.kdl;
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # prompt & completions
    initContent = ''
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${ompTheme})"
      #source <(${pkgs.fzf}/bin/fzf --zsh)
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
      #eval "$(${pkgs.uv}/bin/uv generate-shell-completion zsh)"
      #eval "$(${pkgs.uv}/bin/uvx --generate-shell-completion zsh)"

      # to fix up/down in nixos version of autosuggestion
      # check https://nixos.wiki/wiki/Zsh
      bindkey "''${key[Up]}" up-line-or-search
      bindkey "''${key[Down]}" down-line-or-search

      alias ls='${pkgs.eza}/bin/eza --icons --git'
      alias ll='${pkgs.eza}/bin/eza -l --icons --git'
      # alias cat='${pkgs.bat}/bin/bat'
      alias find='${pkgs.fd}/bin/fd'
      alias grep='${pkgs.ripgrep}/bin/rg'

      [[ -d "$HOME/bin"        ]] && PATH="$HOME/bin:$PATH"
      [[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"

      # Load fzf last - without overriding history search
      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
    '';

    sessionVariables = {
      EDITOR = "emacsclient";
      PATH = "$HOME/.cargo/bin:$HOME/.juliaup/bin:$PATH";
    };
  };

  # Fish configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Initialize tools
      ${pkgs.zoxide}/bin/zoxide init fish --cmd cd | source
      ${pkgs.fzf}/bin/fzf --fish | source

      # Aliases
      alias ls='${pkgs.eza}/bin/eza --icons --git'
      alias ll='${pkgs.eza}/bin/eza -l --icons --git'
      alias find='${pkgs.fd}/bin/fd'
      alias grep='${pkgs.ripgrep}/bin/rg'

      # Add user paths
      if test -d "$HOME/bin"
        set -gx PATH "$HOME/bin" $PATH
      end
      if test -d "$HOME/.local/bin"
        set -gx PATH "$HOME/.local/bin" $PATH
      end
    '';
    shellAliases = {
      ls = "${pkgs.eza}/bin/eza --icons --git";
      ll = "${pkgs.eza}/bin/eza -l --icons --git";
      find = "${pkgs.fd}/bin/fd";
      grep = "${pkgs.ripgrep}/bin/rg";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      format = "$all$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
      };
      git_branch = {
        symbol = " ";
      };
      git_status = {
        conflicted = "⚡";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };
      package = {
        disabled = true;
      };
    };
  };

  # Terminal emulators, multiplexers, and CLI tools
  home.packages = with pkgs; [
    # Terminal emulators
    alacritty
    wezterm
    kitty
    foot
    rio

    # Terminal multiplexers
    zellij
    tmux

    # Shell enhancements
    oh-my-posh
    starship
    fzf
    zoxide

    # Modern CLI replacements
    eza        # better ls
    bat        # better cat
    fd         # better find
    ripgrep    # better grep
    tree       # directory tree viewer

    # System monitoring
    htop
    btop
  ];
}
