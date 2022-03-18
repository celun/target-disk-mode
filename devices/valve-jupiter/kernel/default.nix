{ stdenv, fetchFromGitHub }:

# This is not actually the build derivation...
# We're co-opting this derivation as a source of truth for the version and src.
stdenv.mkDerivation rec {
  version = "5.13.0-valve36";

  src = fetchFromGitHub {
    owner = "Jovian-Experiments";
    repo = "linux";
    rev = version;
    sha256 = "sha256-UdH738KVUwKm2JZVnAwJuQoy2sYQVdleFn0mXmWx5H4=";
  };

  patches = [
    ./0001-HACK-always-show-logo.patch
  ];
}
