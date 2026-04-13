let
  user-key-dell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNgLKtqZqtHJOpS7TgcVosTOmYON+pvLB4jXF4MViab ehsan@laptop-dell";
  host-key-dell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILo+vz2klZ6lV1SdlgjCtFTkaG0ak1NVrz8svQrFwnKD root@laptop-dell";
  host-key-hzi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrvrMLVI02nIMTuT+GqZSRghWz0N53VllxSKWj1B2dr root@nixos";
in
{
  "secrets/id_ed25519.age".publicKeys = [ user-key-dell host-key-dell host-key-hzi ];
  "secrets/deepseek-api-key.age".publicKeys = [ user-key-dell host-key-dell host-key-hzi ];
  "secrets/kimi-api-key.age".publicKeys = [ user-key-dell host-key-dell host-key-hzi ];
  "secrets/moonshot-api-key.age".publicKeys = [ user-key-dell host-key-dell host-key-hzi ];
  "secrets/brics-ssh-key.age".publicKeys = [ user-key-dell host-key-dell host-key-hzi ];
}
