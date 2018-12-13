{ mkDerivation, array, base, bytestring, call-stack, clock, comonad
, containers, criterion, data-default, deepseq, deriving-compat
, directory, errors, fetchgit, fgl, filepath, free, gitrev, groom
, hashable, haskeline, hedgehog, hpack, integer-gmp, lens
, megaparsec, mmorph, mtl, optparse-applicative, parser-combinators
, prettyprinter, process, QuickCheck, quickcheck-instances
, recursion-schemes, reflection, stdenv, tasty, tasty-ant-xml
, tasty-discover, tasty-golden, tasty-hedgehog, tasty-hunit
, tasty-quickcheck, template-haskell, temporary, text, these, time
, transformers, unordered-containers
}:
mkDerivation {
  pname = "kore";
  version = "0.0.1.0";
  src = fetchgit {
    url = "https://github.com/kframework/kore";
    sha256 = "0qaj1b87z8nzgr61b6qa060vav5qaj2bfnqapjsahmsyvr2r365l";
    rev = "8689ad580dd58c416abb5b8435573daf7bc136a2";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/src/main/haskell/kore; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    array base bytestring clock comonad containers data-default deepseq
    deriving-compat errors fgl free gitrev groom hashable haskeline
    integer-gmp lens megaparsec mmorph mtl optparse-applicative
    parser-combinators prettyprinter process recursion-schemes
    reflection template-haskell text these time transformers
    unordered-containers
  ];
  libraryToolDepends = [ hpack tasty-discover ];
  executableHaskellDepends = [
    array base bytestring clock comonad containers data-default deepseq
    deriving-compat errors fgl free gitrev groom hashable haskeline
    integer-gmp lens megaparsec mmorph mtl optparse-applicative
    parser-combinators prettyprinter process recursion-schemes
    reflection template-haskell text these time transformers
    unordered-containers
  ];
  executableToolDepends = [ tasty-discover ];
  testHaskellDepends = [
    array base bytestring call-stack clock comonad containers
    data-default deepseq deriving-compat directory errors fgl filepath
    free gitrev groom hashable haskeline hedgehog integer-gmp lens
    megaparsec mmorph mtl optparse-applicative parser-combinators
    prettyprinter process QuickCheck quickcheck-instances
    recursion-schemes reflection tasty tasty-ant-xml tasty-golden
    tasty-hedgehog tasty-hunit tasty-quickcheck template-haskell text
    these time transformers unordered-containers
  ];
  testToolDepends = [ tasty-discover ];
  benchmarkHaskellDepends = [
    array base bytestring clock comonad containers criterion
    data-default deepseq deriving-compat directory errors fgl filepath
    free gitrev groom hashable haskeline integer-gmp lens megaparsec
    mmorph mtl optparse-applicative parser-combinators prettyprinter
    process recursion-schemes reflection template-haskell temporary
    text these time transformers unordered-containers
  ];
  benchmarkToolDepends = [ tasty-discover ];
  preConfigure = "hpack";
  homepage = "https://github.com/kframework/kore#readme";
  license = stdenv.lib.licenses.ncsa;
}
