{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    overlay = final: prev: {
      vrui = prev.callPackage ./vrui { };
      kinect = prev.callPackage ./kinect { };
      sarndbox = prev.callPackage ./sarndbox { };
    };
  } // (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
    in
    rec {
      packages = {
        inherit (pkgs) vrui kinect sarndbox;
      };

      defaultPackage = packages.sarndbox;
    }));
}
