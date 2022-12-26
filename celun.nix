let
  rev = "9167f946b6ea75144cef3bfcc2cb18edf502408d";
  sha256 = "0wxb8wkn2fwmbw1grj2yaav3di7471rk879zd3va5wm61dqzddmm";
in
builtins.fetchTarball {
  url = "https://github.com/celun/celun/archive/${rev}.tar.gz";
  inherit sha256;
}
