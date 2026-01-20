{ config, pkgs, lib, pkgs-unstable, ... }:

{
  # Julia config file
  home.file = {
    ".julia/config/startup.jl".source = ../config/julia/startup.jl;
  };

  # Expose juliaup and cargo to GUI apps via session PATH
  home.sessionPath = [
    "$HOME/.juliaup/bin"
    "$HOME/.cargo/bin"
  ];

  # Add juliaup and rustup to PATH
  programs.zsh.initContent = ''
    [[ -d "$HOME/.juliaup/bin" ]] && PATH="$HOME/.juliaup/bin:$PATH"
    [[ -d "$HOME/.cargo/bin" ]] && PATH="$HOME/.cargo/bin:$PATH"
  '';

  programs.fish.interactiveShellInit = ''
    if test -d "$HOME/.juliaup/bin"
      set -gx PATH "$HOME/.juliaup/bin" $PATH
    end
    if test -d "$HOME/.cargo/bin"
      set -gx PATH "$HOME/.cargo/bin" $PATH
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

  # Auto-install rustup on activation
  home.activation.installRustup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.cargo/bin/rustup" ]; then
      export PATH="${pkgs.curl}/bin:$PATH"

      # Backup existing shell rc files and create temporary writable ones
      for file in .zshrc .zshenv .bash_profile .profile; do
        if [ -L "$HOME/$file" ] || [ -f "$HOME/$file" ]; then
          $DRY_RUN_CMD mv "$HOME/$file" "$HOME/$file.bak.rustup"
        fi
        $DRY_RUN_CMD touch "$HOME/$file"
      done

      # Install rustup
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile default

      # Restore original shell rc files
      for file in .zshrc .zshenv .bash_profile .profile; do
        $DRY_RUN_CMD rm -f "$HOME/$file"
        if [ -e "$HOME/$file.bak.rustup" ]; then
          $DRY_RUN_CMD mv "$HOME/$file.bak.rustup" "$HOME/$file"
        fi
      done

      # Install rust-analyzer
      if [ -f "$HOME/.cargo/bin/rustup" ]; then
        $DRY_RUN_CMD $HOME/.cargo/bin/rustup component add rust-analyzer
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

    # JS/TS
    bun

    # Build essentials
    pkg-config      # needed for cargo to find libraries
    openssl         # commonly needed by Rust crates
    curl            # needed for juliaup and other downloads

    # Tools
    jq
    killall
    
    # Version control
    jujutsu
    pkgs-unstable.prek

    # Claude Code
    pkgs-unstable.claude-code

    # MongoDB
    mongosh
    mongodb-compass

    # Visualization
    paraview
    mermaid-cli

    # Typst
    pkgs-unstable.typst
    pkgs-unstable.tinymist
  ];
}
