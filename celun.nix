let
  rev = "31bf043c671a84a15c1dc4a1279a37af8244ddd3";
  sha256 = "073nw744m5h3rc0yzvyyx9vv061wrkkvad7vhywn78hvic4i849h";
in
builtins.fetchTarball {
  url = "https://github.com/celun/celun/archive/${rev}.tar.gz";
  inherit sha256;
}
