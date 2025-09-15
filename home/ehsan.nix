{ config, pkgs, lib, ... }:

{
  home.username = "ehsan";
  home.homeDirectory = "/home/ehsan";
  home.stateVersion = "25.05";

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
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    initContent = ''
      export EDITOR=emacsclient
      eval "$(zoxide init zsh)"
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set number relativenumber
    '';
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;  # always latest in nixpkgs
  };

  home.packages = with pkgs; [
    julia
    python3
    uv
    rustc
    cargo
    ripgrep fd eza tree tmux zellij htop btop
    zoxide direnv
    firefox
    telegram
  ];

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

  xdg.configFile."alacritty/alacritty.yml".source =
    ./config/alacritty/alacritty.yml;
}

