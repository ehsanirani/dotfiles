{ config, pkgs, lib, pkgs-unstable, ... }:

{
  # Julia config file
  home.file = {
    ".julia/config/startup.jl".source = ../config/julia/startup.jl;
  };

  home.packages = with pkgs; [
    # Julia (from unstable channel)
    pkgs-unstable.julia-bin

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
