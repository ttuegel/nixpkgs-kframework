{
  lib, stdenv, fetchFromGitHub,
  autoconf, automake, libtool,
}:

let
  src = {
    owner = "bitcoin-core";
    repo = "secp256k1";
    rev = "1086fda4c1975d0cad8d3cad96794a64ec12dca4";
    sha256 = "1a7531s38faqjdc2fx9sl0vqd18bl9643fg0r2224qrrsr3n1r54";
  };
in

stdenv.mkDerivation {
  name = "secp256k1-${lib.substring 0 7 src.rev}";
  src = fetchFromGitHub src;
  nativeBuildInputs = [ autoconf automake libtool ];
  preConfigure = ''
    ./autogen.sh
  '';
  configureFlags = [ "--enable-module-recovery" ];
}
