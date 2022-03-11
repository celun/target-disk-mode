let
  celunPath = import ./celun.nix;
in
{ device ? null }@args:

import (celunPath + "/lib/eval-with-configuration.nix") (args // {
  inherit device;
  verbose = true;
  configuration = {
    imports = [
      ./configuration/configuration.nix
      (
        { lib, ... }:
        {
          celun.system.automaticCross = lib.mkDefault true;
        }
      )
    ];
  };
})
