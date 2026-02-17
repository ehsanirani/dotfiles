{ pkgs, ... }:

{
  # Printing support (CUPS)
  services.printing = {
    enable = true;
    drivers = [
      pkgs.gutenprint      # Many consumer printers (Canon, Epson, HP, etc.)
      pkgs.hplip           # HP printers
    ];
  };

  # Network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
