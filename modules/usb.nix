{ ... }:
{
  # Disable UAS for Ugreen enclosure (ASMedia 174c:235c) to prevent instant disconnect
  boot.kernelParams = [ "usb-storage.quirks=174c:235c:u" ];
}
