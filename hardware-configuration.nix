# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/eefd952d-7f07-4011-aa85-4457a15faf66";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/33BA-C907";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
	fileSystems."/data" = {
    device = "/dev/disk/by-partlabel/Data";
    fsType = "auto";
    options = [
		"nofail"
		"nodev"
		"uid=1000"
		"gid=1000"
		"utf8"
		"umask=022"
		"exec"
		"x-gvfs-show"
	];
};

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s16f1u2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
