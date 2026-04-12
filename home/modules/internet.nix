{ config, pkgs, lib, pkgs-unstable, ... }:

let
  # Patch claude-desktop's cowork bwrap sandbox to work on NixOS.
  # The BwrapBackend in cowork-vm-service.js creates a minimal sandbox with
  # --tmpfs / and --ro-bind /usr /usr. On NixOS (inside the FHS wrapper),
  # /usr/lib64/ contains symlinks into /nix/store/, but /nix is not mounted
  # in the inner sandbox. Additionally, --tmpfs /run wipes /run/current-system
  # which nix-ld needs to find the real dynamic linker.
  # Fix: bind-mount /nix and /run/current-system read-only into the sandbox.
  claude-desktop-patched = pkgs.claude-desktop.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # Patch cowork-vm-service.js to bind /nix in the bwrap sandbox
      substituteInPlace $out/lib/claude-desktop/electron/resources/app.asar.unpacked/cowork-vm-service.js \
        --replace-warn \
          "'--tmpfs', '/'," \
          "'--tmpfs', '/',
            // NixOS fix: /usr/lib64 contains symlinks into /nix/store
            ...(require('fs').existsSync('/nix/store') ? ['--ro-bind', '/nix', '/nix'] : []),"

      # Bind /run/current-system so nix-ld can find the real dynamic linker.
      # This must come after --tmpfs /run to overlay onto the tmpfs.
      substituteInPlace $out/lib/claude-desktop/electron/resources/app.asar.unpacked/cowork-vm-service.js \
        --replace-warn \
          "'--tmpfs', '/run'," \
          "'--tmpfs', '/run',
            // NixOS fix: nix-ld needs /run/current-system/sw/share/nix-ld/lib/ld.so
            ...(require('fs').existsSync('/run/current-system') ? ['--ro-bind', '/run/current-system', '/run/current-system'] : []),"

      # Also fix shim.sh permissions (Nix store files are 0555, causing
      # EACCES when Claude Desktop tries to overwrite on retries)
      chmod 755 $out/lib/claude-desktop/electron/resources/cowork-plugin-shim.sh
    '';
  });

  claude-desktop-wrapped = pkgs.claude-desktop-fhs.override {
    claude-desktop = claude-desktop-patched;
  };
in
{
  home.packages = with pkgs; [
    firefox
    google-chrome
    chromium
    telegram-desktop
    pkgs-unstable.thunderbird
    zoom-us
    zulip
    slack
    pkgs-unstable.openconnect
    claude-desktop-wrapped
    bubblewrap
    socat
    virtiofsd
  ];
}
