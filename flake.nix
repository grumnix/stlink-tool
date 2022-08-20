{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    stlink-tool_src.url = "git+https://github.com/UweBonnes/stlink-tool.git?submodules=1";
    stlink-tool_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, stlink-tool_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = stlink-tool;
          stlink-tool = pkgs.stdenv.mkDerivation rec {
            pname = "stlink-tool";
            version = "0.0.0";

            src = stlink-tool_src;

            buildPhase = ''
              make
            '';

            installPhase = ''
              mkdir -p $out/bin
              install stlink-tool $out/bin
            '';

            nativeBuildInputs = [
              pkgs.pkgconfig
            ];

            buildInputs = [
              pkgs.libusb
            ];
          };
        };
      }
    );
}
