let
  user-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNgLKtqZqtHJOpS7TgcVosTOmYON+pvLB4jXF4MViab ehsan@laptop-dell";  # paste from ~/.ssh/id_ed25519_new.pub
  host-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILo+vz2klZ6lV1SdlgjCtFTkaG0ak1NVrz8svQrFwnKD root@laptop-dell";   # paste from host key above
in
{
  "secrets/id_ed25519.age".publicKeys = [ user-key host-key ];
  "secrets/deepseek-api-key.age".publicKeys = [ user-key host-key ];
  "secrets/kimi-api-key.age".publicKeys = [ user-key host-key ];
}
