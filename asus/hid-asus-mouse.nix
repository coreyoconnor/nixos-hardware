{ config, lib, pkgs, ... }:
with lib;
let cfg = config.hardware.hid-asus-mouse;
  kernel = config.boot.kernelPackages.kernel;
  hid-asus-mouse = pkgs.stdenv.mkDerivation {
    name = "hid-asus-mouse";
    version = "0.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "coreyoconnor";
      repo = "hid-asus-mouse";
      rev = "8a684b8b6078daa8043b7913e10a8e3cea2c24fd";
      hash = "sha256-ye5X0iflcjdXO3vH5QgB7a3U6yAWPKRHxQZd3lS648c=";
    };

    hardeningDisable = [ "pic" "format" ];
    nativeBuildInputs = kernel.moduleBuildDependencies;

    KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
    INSTALL_MOD_PATH = "$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid/";

    buildPhase = ''
      make kernel_modules
    '';

    installPhase = ''
      mkdir -p $$INSTALL_MOD_PATH
      make kernel_modules_install
    '';
  };
in {
  options.hardware.hid-asus-mouse = {
    enable = mkOption {
      description = "Whether to add the hid-asus-mouse kernel module";
      default = false;
      type = lib.types.bool;
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ hid-asus-mouse ];
    boot.kernelModules = [ "hid-asus-mouse" ];
  };
}

