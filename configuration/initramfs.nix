{ config, lib, pkgs, ... }:

/*

For now the initramfs for the target-disk-mode example system is entirely bespoke.

At some point a *busybox init stage-1* module will be added, and this will be
changed to use that module.

*/

let
  inherit (lib)
    mkIf
    mkOption
    optionalString
    types
  ;

  inherit (pkgs)
    runCommandNoCC
    writeScript
    writeScriptBin
    writeText
    writeTextFile
    writeTextDir

    mkExtraUtils

    busybox
    glibc
  ;

  writeScriptDir = name: text: writeTextFile {inherit name text; executable = true; destination = "${name}";};

  cfg = config.examples.target-disk-mode;

  # Alias to `output.extraUtils` for internal usage.
  inherit (cfg.output) extraUtils;
in
{

  options.examples.target-disk-mode = {
    extraUtils = {
      packages = mkOption {
        # TODO: submodule instead of `attrs` when we extract this
        type = with types; listOf (oneOf [package attrs]);
      };
    };
    output = {
      extraUtils = mkOption {
        type = types.package;
        internal = true;
      };
    };
  };

  config = {
    wip.stage-1.contents = {
      "/etc/issue" = writeTextDir "/etc/issue" ''

        Target disk mode system
        =======================

      '';

      # https://git.busybox.net/busybox/tree/examples/inittab
      "/etc/inittab" = writeTextDir "/etc/inittab" ''
        # Allow root login on the `console=` param.
        # (Or when missing, a default console may be launched on e.g. serial)
        # No console will be available on other valid consoles.
        console::respawn:${extraUtils}/bin/getty -l ${extraUtils}/bin/login 0 console

        # Launch all setup tasks
        ::sysinit:${extraUtils}/bin/sh -l -c ${extraUtils}/bin/mount-basic-mounts
        ::sysinit:${extraUtils}/bin/sh -l -c ${extraUtils}/bin/network-setup
        ::wait:${extraUtils}/bin/sh -l -c ${extraUtils}/bin/backlight-setup
        ::wait:${extraUtils}/bin/sh -l -c ${extraUtils}/bin/tdm-setup

        ::restart:${extraUtils}/bin/init
        ::ctrlaltdel:${extraUtils}/bin/poweroff
      '';

      "/etc/passwd" = writeTextDir "/etc/passwd" ''
        root::0:0:root:/root:${extraUtils}/bin/sh
      '';

      "/etc/profile" = writeScriptDir "/etc/profile" ''
        export LD_LIBRARY_PATH="${extraUtils}/lib"
        export PATH="${extraUtils}/bin"
      '';

      # Place init under /etc/ to make / prettier
      init = writeScriptDir "/init" ''
        #!${extraUtils}/bin/sh

        echo
        echo "::"
        echo ":: Launching busybox linuxrc"
        echo "::"
        echo

        . /etc/profile

        exec linuxrc
      '';

      extraUtils = runCommandNoCC "target-disk-mode--initramfs-extraUtils" {
        passthru = {
          inherit extraUtils;
        };
      } ''
        mkdir -p $out/${builtins.storeDir}
        cp -prv ${extraUtils} $out/${builtins.storeDir}
      '';

      # POSIX requires /bin/sh
      "/bin/sh" = runCommandNoCC "target-disk-mode--initramfs-extraUtils-bin-sh" {} ''
        mkdir -p $out/bin
        ln -s ${extraUtils}/bin/sh $out/bin/sh
      '';
    };

    examples.target-disk-mode.extraUtils.packages = [
      {
        package = busybox;
        extraCommand = ''
          (cd $out/bin/; ln -s busybox linuxrc)
        '';
      }

      (writeScriptBin "mount-basic-mounts" ''
        #!/bin/sh

        PS4=" $ "
        set -x
        mkdir -p /proc /sys /dev /run /tmp
        mount -t proc proc /proc
        mount -t sysfs sys /sys
        mount -t devtmpfs devtmpfs /dev
      '')

      (writeScriptBin "network-setup" ''
        #!/bin/sh

        PS4=" $ "
        set -x
        hostname celun-TDM
        ip link set lo up
      '')

      (writeScriptBin "backlight-setup" ''
        #!/bin/sh
        cd /sys/class/backlight/
        for d in *; do
          ( cd $d; echo $(( $(cat max_brightness ) * 30 / 100  )) > brightness )
        done
      '')

      (writeScriptBin "tdm-setup" ''
        #!/bin/sh

        set -e
        PS4=" $ "
        set -x

        move_to_line() {
          printf '\e[%d;0H' "$@" > /dev/tty0
        }

        pr_info() {
          printf '\e[2K\r%s' "$@" > /dev/tty0 
        }

        inquiry_string_for() {
          printf "%-8.8s%-16.16s%-4.4s" "$@"
        }

        device_serial() {
          if [ -e /sys/firmware/devicetree/base/serial-number ]; then
            cat /sys/firmware/devicetree/base/serial-number
          elif [ -e /sys/class/dmi/id/product_serial ]; then
            cat /sys/class/dmi/id/product_serial
          else
            echo "00000000"
          fi
        }

        device_vendor() {
          local vendor
          if [ -e /proc/device-tree/compatible ]; then
            vendor=$(cat /proc/device-tree/compatible)
            echo "''${vendor%%,*}"
          elif [ -e /sys/class/dmi/id/sys_vendor ]; then
            cat /sys/class/dmi/id/sys_vendor
          else
            echo "Unknown"
          fi
        }

        device_name() {
          if [ -e /proc/device-tree/model ]; then
            cat /proc/device-tree/model
          elif [ -e /sys/class/dmi/id/product_name ]; then
            cat /sys/class/dmi/id/product_name
          else
            echo "Unidentified device"
          fi
        }

        mass_storage_lun_number=0
        mass_storage_add_lun() {
          local blockdev
          blockdev="$1"; shift

          if [ -e "$blockdev" ]; then
            # "Friendly" name (four chars)
            local blockname
            blockname="''${blockdev##*/}"         # Strips prefix
            blockname="''${blockname/mmcblk/mmc}" # mmcblk1 → mmc1 (four chars)
            blockname="''${blockname/nvme/nvm}"   # nvme0   → nvm0 (four chars)

            local path
            path=g1/functions/mass_storage.0

            local number
            number=$(( mass_storage_lun_number ))

            path="$path/lun.$number"

            # Add the LUN
            mkdir -p "$path"

            # Attach the block device to the LUN
            # || :  so it doesn't fail the whole script on non-existent block device.
            # It's possible there is no SD card!
            echo "$blockdev" > $path/file || :

            # Add a description to the LUN
            inquiry_string_for "$(device_vendor)" "$(device_name)" \
              "$blockname" > $path/inquiry_string 

            mass_storage_lun_number=$(( mass_storage_lun_number + 1 ))
          fi
        }

        move_to_line 999

        pr_info "... initializing"

        #
        # gadget mode
        #

        pr_info " :: Mounting configfs"

        mount -t configfs configfs /sys/kernel/config/ || :

        pr_info " :: Creating and configuring USB gadget..."

        cd /sys/kernel/config/usb_gadget/
        mkdir -p g1/strings/0x409
        echo 0x0069 > g1/idProduct 
        echo 0x1209 > g1/idVendor 
        device_serial > g1/strings/0x409/serialnumber 
        echo "$(device_vendor)"  > g1/strings/0x409/manufacturer 
        echo "$(device_name) (Target Disk Mode)" > g1/strings/0x409/product 

        pr_info " :: Adding functions to gadget..."

        # Note: Busybox ash doesn't have {0..9} to make a single `for d in /dev/{mmcblk,nvme}{0..9};`
        for d in $(seq 0 9); do
          mass_storage_add_lun "/dev/nvme''${d}n1"
        done
        for d in $(seq 0 9); do
          mass_storage_add_lun "/dev/mmcblk$d"
        done
        for d in a b c d e f g; do
          mass_storage_add_lun "/dev/sd$d"
        done

        # Add configuration and link functions

        mkdir -p g1/configs/mass_storage.1/strings/0x409
        ln -s g1/functions/mass_storage.0 g1/configs/mass_storage.1/

        pr_info " :: Activating gadget."

        # Specific to some platforms

        # RK3399
        if [ -e /sys/class/usb_role/fe800000.usb-role-switch/role ]; then
          echo host > /sys/class/usb_role/fe800000.usb-role-switch/role
          echo device > /sys/class/usb_role/fe800000.usb-role-switch/role
        fi

        # Intel
        if [ -e /sys/class/usb_role/intel_xhci_usb_sw-role-switch/role ]; then
          echo device > /sys/class/usb_role/intel_xhci_usb_sw-role-switch/role
        fi

        # Ensure the gadget actually becomes available to enable.
        sleep 0.5

        pr_info " :: Activating gadget.."

        echo "$(cd /sys/class/udc ; printf '%s\n' *| sort | head -n1 )" > g1/UDC

        pr_info " :: Activating gadget..."

        # RK3399
        if [ -e /sys/class/usb_role/fe800000.usb-role-switch/role ]; then
          # Flip role host/device again...
          # Something's REALLY fucky...
          # On 5.10.0 this is not necessary... 5.10.75 it is...
          # > dwc3 fe800000.usb: unexpected direction for Data Phase
          # These would be good bisect starting/ending points.
          sleep 0.1
          echo host > /sys/class/usb_role/fe800000.usb-role-switch/role
          echo device > /sys/class/usb_role/fe800000.usb-role-switch/role
        fi

        # A small white lie... shhh...
        # We're sleeping here so that it's more than likely to be already
        # active on the other end.
        # We're only delaying the message, not the end-result.
        sleep 2

        pr_info " :: USB mass storage mode is now active!"

      '')
    ];

    examples.target-disk-mode.output = {
      extraUtils = mkExtraUtils {
        name = "celun-target-disk-mode--extra-utils";
        inherit (cfg.extraUtils) packages;
      };
    };
  };

}
