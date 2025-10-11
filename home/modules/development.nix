{ config, pkgs, lib, pkgs-unstable, ... }:

{
  # Julia config file
  home.file = {
    ".julia/config/startup.jl".source = ../config/julia/startup.jl;
  };

  # Add juliaup to PATH
  programs.zsh.initContent = ''
    [[ -d "$HOME/.juliaup/bin" ]] && PATH="$HOME/.juliaup/bin:$PATH"
  '';

  programs.fish.interactiveShellInit = ''
    if test -d "$HOME/.juliaup/bin"
      set -gx PATH "$HOME/.juliaup/bin" $PATH
    end
  '';

  # Auto-install juliaup on activation
  home.activation.installJuliaup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.juliaup/juliaup" ]; then
      export PATH="${pkgs.curl}/bin:${pkgs.wget}/bin:$PATH"

      # Backup existing .zshrc and create a temporary writable one
      if [ -L "$HOME/.zshrc" ] || [ -f "$HOME/.zshrc" ]; then
        $DRY_RUN_CMD mv "$HOME/.zshrc" "$HOME/.zshrc.bak.juliaup"
      fi
      $DRY_RUN_CMD touch "$HOME/.zshrc"

      # Install juliaup
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL https://install.julialang.org | sh -s -- -y

      # Restore original .zshrc
      $DRY_RUN_CMD rm -f "$HOME/.zshrc"
      if [ -e "$HOME/.zshrc.bak.juliaup" ]; then
        $DRY_RUN_CMD mv "$HOME/.zshrc.bak.juliaup" "$HOME/.zshrc"
      fi

      # Install default Julia version
      if [ -f "$HOME/.juliaup/bin/juliaup" ]; then
        $DRY_RUN_CMD $HOME/.juliaup/bin/juliaup default release
      fi
    fi
  '';

  home.packages = with pkgs; [
    # Python with uv in FHS environment
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

    # Rust toolchain
    rustc
    cargo
    rustfmt
    rust-analyzer

    # Build essentials
    pkg-config      # needed for cargo to find libraries
    openssl         # commonly needed by Rust crates
    curl            # needed for juliaup and other downloads

    # Version control
    jujutsu

    # Claude Code
    pkgs-unstable.claude-code
  ];
}
