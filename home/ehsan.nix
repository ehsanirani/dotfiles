{ config, pkgs, lib, eemacs ? null, ... }:
let
  ompTheme = ./config/oh-my-posh/powerlevel10k_lean_extended.omp.json;
in
{
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

  # Emacs config in ~/.emacs.d
  home.file = lib.mkIf (eemacs != null) {
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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # prompt & completions
    initContent = ''
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${ompTheme})"
      source <(${pkgs.fzf}/bin/fzf --zsh)
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
      eval "$(${pkgs.uv}/bin/uv generate-shell-completion zsh)"
      eval "$(${pkgs.uv}/bin/uvx --generate-shell-completion zsh)"

      alias ls='${pkgs.eza}/bin/eza --icons --git'
      alias ll='${pkgs.eza}/bin/eza -l --icons --git'
      alias cat='${pkgs.bat}/bin/bat'
      alias find='${pkgs.fd}/bin/fd'
      alias grep='${pkgs.ripgrep}/bin/rg'

      [[ -d "$HOME/bin"        ]] && PATH="$HOME/bin:$PATH"
      [[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"

    '';

    sessionVariables = { EDITOR = "emacsclient"; };
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
    alacritty
    wezterm
    kitty
    foot
    rio
    juliaup        # Julia version manager (use: juliaup add release, juliaup default release)
    python3
    uv
    rustc
    cargo
    oh-my-posh
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
    cmake          # needed for emacs vterm compilation
    gcc            # C compiler for vterm-module
    gnumake        # make for building vterm
    libtool        # build tools for vterm
    libvterm       # vterm library
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
  systemd.user.services.emacs-daemon = {
    Unit = {
      Description = "Emacs daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.emacs}/bin/emacs --daemon";
      ExecStop  = "${pkgs.emacs}/bin/emacsclient -e '(kill-emacs)'";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };
}
