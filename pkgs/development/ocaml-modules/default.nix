{ k, secp256k1 }:

self: super:

{
  base = self.callPackage ./base {};

  bn128 = self.callPackage ./bn128 {};

  configurator = self.callPackage ./configurator {};

  mlgmp = (self.callPackage ./mlgmp {}).overrideAttrs (attrs: {
    patches = k.patches.mlgmp;
  });

  ocaml-protoc = self.callPackage ./ocaml-protoc {};

  ppx_deriving_protobuf = self.callPackage ./ppx_deriving_protobuf {};

  secp256k1 = self.callPackage ./secp256k1 {
    inherit secp256k1;
  };

  stdio = self.callPackage ./stdio {};
}
