let
  user-key-dell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNgLKtqZqtHJOpS7TgcVosTOmYON+pvLB4jXF4MViab ehsan@laptop-dell";  # from id_ed25519_new.pub
  user-key-hzi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYgCnLFfxpycUzVyym506Pp/+lEGi0+XBb9qX81rVhU ehsan@laptop-hzi"; # paste from HZI user key
  host-key-dell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILo+vz2klZ6lV1SdlgjCtFTkaG0ak1NVrz8svQrFwnKD root@laptop-dell";   # paste from host key dell laptop
  host-key-hzi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrvrMLVI02nIMTuT+GqZSRghWz0N53VllxSKWj1B2dr root@nixos"; # paste from HZI dell laptop
in
{
  "secrets/id_ed25519.age".publicKeys = [ user-key-dell user-key-hzi host-key-dell host-key-hzi ];
  "secrets/deepseek-api-key.age".publicKeys = [ user-key-dell user-key-hzi host-key-dell host-key-hzi ];
  "secrets/kimi-api-key.age".publicKeys = [ user-key-dell user-key-hzi host-key-dell host-key-hzi ];
  "secrets/moonshot-api-key.age".publicKeys = [ user-key-dell user-key-hzi host-key-dell host-key-hzi ];
  "secrets/brics-ssh-key.age".publicKeys = [ user-key-dell user-key-hzi host-key-dell host-key-hzi ];
}
