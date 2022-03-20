{ lib, ... }:

let
  inherit (lib)
    mkOption
    types
  ;
in
{
  options = {
    target-disk-mode = {
      eink = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Builds with a configuration optimized for eink displays.

          Main differences are black-on-white instead of colour use.
        '';
      };
    };
  };
}
