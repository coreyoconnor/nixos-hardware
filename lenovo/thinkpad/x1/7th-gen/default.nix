{ lib, ... }:
{
  imports = [
    ../.
    ../../../../common/pc/ssd
    ../../../../common/cpu/intel/whiskey-lake
  ];

  services.throttled.enable = lib.mkDefault true;
}
