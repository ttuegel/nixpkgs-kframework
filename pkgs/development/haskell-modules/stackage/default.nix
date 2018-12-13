{ callPackage, haskell, z3 }:
let inherit (haskell) lib; in
let
  addTestTool = drv: x: addTestTools drv [x];
  addTestTools = drv: xs: lib.overrideCabal drv (drv: {
    testToolDepends = (drv.testToolDepends or []) ++ xs;
  });
in
{
  lts_12_21 = callPackage ./lts-12.21 {
    overrides = self: super: {
      kore =
        let drv = self.callPackage ../kore {}; in
        addTestTool drv z3;
      tasty-discover = lib.dontCheck super.tasty-discover;
    };
  };
}
