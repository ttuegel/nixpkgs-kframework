self: super:

{
  k = self.callPackage ./pkgs/k {
    mavenix = self.callPackage ./pkgs/k/mavenix.nix {};
  };
}
