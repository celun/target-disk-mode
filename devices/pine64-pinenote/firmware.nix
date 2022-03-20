{ config, lib, pkgs, ... }:

{
  wip.stage-1.contents = {
    "/lib/firmware/waveform.bin" =  pkgs.runCommandNoCC "pinenote-waveform" {
      firmware = pkgs.fetchFromGitLab {
        owner = "calebccff";
        repo = "firmware-pine64-pinenote";
        rev = "6676e4cabf5f68062da86ef528ac033507f02529";
        hash = "sha256-Kza3buPUyLUeVjcJnTYlaZTJm523dToFhi5dWTGtuCE=";
      };
    }''
      mkdir -p $out/lib/firmware
      cp $firmware/waveform.bin $out/lib/firmware/waveform.bin
    '';
  };
}
