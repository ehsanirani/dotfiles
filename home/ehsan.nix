{ config, pkgs, lib, eemacs ? null, pkgs-unstable, ... }:
let
  ompTheme = ./config/oh-my-posh/powerlevel10k_lean_extended.omp.json;
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  home.username = "ehsan";
  home.homeDirectory = "/home/ehsan";
  home.stateVersion = "25.05";

  ########################################################
  #  XDG dot-files
  ########################################################
  xdg.configFile = {
    "wezterm/wezterm.lua".source = ./config/wezterm/wezterm.lua;
    "zellij/config.kdl".source   = ./config/zellij/config.kdl;
  };

  # Home files (emacs, julia, etc)
  home.file = {
    # Julia startup file
    ".julia/config/startup.jl".source = ./config/julia/startup.jl;
  } // lib.optionalAttrs (eemacs != null) {
    # Emacs config in ~/.emacs.d
    ".emacs.d/init.el".source       = "${eemacs}/init.el";
    ".emacs.d/config.el".source     = "${eemacs}/config.el";
    ".emacs.d/early-init.el".source = "${eemacs}/early-init.el";
    ".emacs.d/modules".source       = "${eemacs}/modules";
  };

  #########################################################################
  # PROGRAMS  (latest versions by default)
  #########################################################################
  programs.git = {
    enable = true;
    userName  = "Ehsan Irani";
    userEmail = "ehsan.irani@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

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

    sessionVariables = { EDITOR = "emacsclient"; };
  };

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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = "set number relativenumber";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;  # Latest stable Emacs with all features including X11
  };
  
  #########################################################################
  # PACKAGES  (latest by default)
  #########################################################################
  home.packages = with pkgs; [
    home-manager   # standalone CLI for fast user rebuilds
    pkgs-unstable.julia-bin  # Latest Julia from unstable channel
    pkgs-unstable.claude-code
    alacritty
    wezterm
    kitty
    foot
    rio
    jujutsu
    python3
    (pkgs.buildFHSEnv {
      name = "uv";
      targetPkgs = pkgs: with pkgs; [
        uv
        stdenv.cc.cc.lib
        zlib
        openssl
      ];
      runScript = "uv";
    })
    rustc
    cargo
    rustfmt
    rust-analyzer
    pkg-config      # needed for cargo to find libraries
    openssl         # commonly needed by Rust crates
    oh-my-posh
    starship
    fzf
    zoxide
    eza
    bat
    fd
    ripgrep
    tree
    tmux
    htop
    btop
    firefox
    zellij
    curl           # needed for juliaup and other downloads
    cmake          # needed for emacs vterm compilation
    gcc            # C compiler for vterm-module
    gnumake        # make for building vterm
    libtool        # build tools for vterm
    libvterm       # vterm library
    telegram-desktop
    # Nerd Fonts for icons (new syntax for NixOS 25.05)
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  # Enable fontconfig for proper font detection
  fonts.fontconfig.enable = true;

  #########################################################################
  # SERVICES
  #########################################################################
  #systemd.user.services.emacs-daemon = {
  #  Unit = {
  #    Description = "Emacs daemon";
  #    After = [ "graphical-session.target" ];
  #  };
  #  Service = {
  #    ExecStart = "${pkgs.emacs}/bin/emacs --daemon";
  #    ExecStop  = "${pkgs.emacs}/bin/emacsclient -e '(kill-emacs)'";
  #  };
  #  Install = { WantedBy = [ "default.target" ]; };
  #};
}
