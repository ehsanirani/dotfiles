{ config, pkgs, lib, eemacs ? null, ... }:

{
  # Config files (Emacs and Neovim)
  home.file = lib.optionalAttrs (eemacs != null) {
    ".emacs.d/init.el".source       = "${eemacs}/init.el";
    ".emacs.d/config.el".source     = "${eemacs}/config.el";
    ".emacs.d/early-init.el".source = "${eemacs}/early-init.el";
    ".emacs.d/modules".source       = "${eemacs}/modules";
  } // {
    ".config/nvim" = {
      source = ../config/nvim;
      recursive = true;
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Emacs configuration
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;  # Latest stable Emacs with all features including X11
  };

  # Build tools needed for Emacs vterm
  home.packages = with pkgs; [
    cmake          # needed for emacs vterm compilation
    gcc            # C compiler for vterm-module
    gnumake        # make for building vterm
    libtool        # build tools for vterm
    libvterm       # vterm library
  ];

  # Optional: Emacs daemon service (currently disabled)
  # systemd.user.services.emacs-daemon = {
  #   Unit = {
  #     Description = "Emacs daemon";
  #     After = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     ExecStart = "${pkgs.emacs}/bin/emacs --daemon";
  #     ExecStop  = "${pkgs.emacs}/bin/emacsclient -e '(kill-emacs)'";
  #   };
  #   Install = { WantedBy = [ "default.target" ]; };
  # };
}
