{ config, pkgs, lib, ... }:
let
  ompTheme = "${pkgs.oh-my-posh}/share/oh-my-posh/themes/multiverse-neon.omp.json";
in
{
  home.username = "ehsan";
  home.homeDirectory = "/home/ehsan";
  home.stateVersion = "25.05";

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
    # no version pinned → latest stable
  };

  #########################################################################
  # PACKAGES  (latest by default)
  #########################################################################
  home.packages = with pkgs; [
    alacritty
    wezterm
    kitty
    foot
    rio
    julia          # newest stable
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
  ];

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
