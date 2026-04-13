{ config, pkgs, lib, pkgs-unstable, ... }:

let
  # Patch claude-desktop's cowork bwrap sandbox to work on NixOS.
  #
  # Problems on NixOS:
  #   1. The BwrapBackend creates a minimal sandbox with --tmpfs / and
  #      --ro-bind /usr. On NixOS (inside the FHS wrapper), /usr/lib64/
  #      contains symlinks into /nix/store/, but /nix is not mounted in
  #      the inner sandbox. Same for /run/current-system which nix-ld needs.
  #   2. resolveSubpath() turns relative paths like "nix/store/..." into
  #      "$HOME/nix/store/..." instead of "/nix/store/...", breaking mounts
  #      for paths originating from the Nix store.
  #   3. cowork-plugin-shim.sh has Nix store 0555 permissions, causing
  #      EACCES when the app tries to overwrite a previously-copied file.
  claude-desktop-patched = pkgs.claude-desktop.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      COWORK_JS=$out/lib/claude-desktop/electron/resources/app.asar.unpacked/cowork-vm-service.js

      # --- Fix: Force host backend to bypass bwrap sandbox entirely ---
      # The nested bwrap sandbox (inside the FHS wrapper) has multiple issues
      # on NixOS: /nix not mounted, /tmp and /run wiped (hiding MITM proxy
      # certs and sockets), nix store paths rejected by home-dir check.
      # The host backend runs claude-code-vm directly without sandboxing,
      # which is fine since the FHS wrapper already provides isolation.
      substituteInPlace "$COWORK_JS" \
        --replace-warn \
          "const BACKEND_OVERRIDE = process.env.COWORK_VM_BACKEND || null;" \
          "const BACKEND_OVERRIDE = process.env.COWORK_VM_BACKEND || 'host';"

      # --- Fix: resolveSubpath must prefer absolute paths that exist ---
      # Without this, "nix/store/..." resolves to "$HOME/nix/store/..." which
      # breaks mount-map entries for Nix store paths (e.g. app.asar).
      substituteInPlace "$COWORK_JS" \
        --replace-warn \
          'return path.resolve(path.join(os.homedir(), subpath));' \
          '{ const abs = path.resolve(path.join("/", subpath)); if (require("fs").existsSync(abs)) return abs; return path.resolve(path.join(os.homedir(), subpath)); }'

      # --- Fix: buildMountMap rejects paths outside $HOME ---
      # On NixOS, app.asar lives in /nix/store, which gets rejected by the
      # home-directory security check. Allow /nix/store paths through.
      substituteInPlace "$COWORK_JS" \
        --replace-warn \
          "!resolved.startsWith(homeDir + path.sep))" \
          "!resolved.startsWith(homeDir + path.sep) && !resolved.startsWith('/nix/store/'))"

    '';
  });

  claude-desktop-fhs-wrapped = pkgs.claude-desktop-fhs.override {
    claude-desktop = claude-desktop-patched;
  };

  # Wrap claude-desktop to fix stale read-only shim.sh copies from Nix store.
  # The main app.asar (which we can't easily patch) also copies shim.sh and
  # hits EACCES on previously-copied 0555 files. Clean them up before launch.
  # We symlinkJoin the FHS wrapper with an overridden bin/ so we keep .desktop
  # files and icons from the original package.
  claude-desktop-wrapped = pkgs.symlinkJoin {
    name = "claude-desktop-wrapped";
    paths = [ claude-desktop-fhs-wrapped ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm "$out/bin/claude-desktop"
      makeWrapper "${claude-desktop-fhs-wrapped}/bin/claude-desktop" "$out/bin/claude-desktop" \
        --run 'find "$HOME/.config/Claude/local-agent-mode-sessions" -name "shim.sh" ! -writable -exec chmod 644 {} \; 2>/dev/null || true'
    '';
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
