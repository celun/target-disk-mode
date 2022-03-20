{ stdenv, fetchFromGitLab, fetchpatch }:

# This is not actually the build derivation...
# We're co-opting this derivation as a source of truth for the version and src.
stdenv.mkDerivation rec {
  version = "5.17.0-rc2";

  src = fetchFromGitLab {
    owner = "pine64-org";
    repo = "linux";
    rev = "2d1ab1f1c2c01b45d22d78260c08c8da8ef396eb";
    hash = "sha256-KMH2haFl9zj6shSdPjbR0/jTBD9iSqFUOwl/PXll7BM=";
  };
}
