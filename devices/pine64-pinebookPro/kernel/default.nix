{ stdenv, fetchurl }:

# This is not actually the build derivation...
# We're co-opting this derivation as a source of truth for the version and src.
stdenv.mkDerivation rec {
  version = "5.10.103";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "sha256-T7itVeZDA0Lk+8lNVOWU6b6Otqi+odcezPg1lI0IWAo=";
  };                                                            

  patches = [
    ./0001-HACK-Make-PBP-display-init-more-stable-on-low-batter.patch
    ./0001-PinebookPro-gadget-mode.patch
  ];
}
