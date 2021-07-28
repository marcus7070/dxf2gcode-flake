{
  description = "A tool for converting 2D (dxf, pdf, ps) drawings to CNC machine compatible GCode";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils.url = "github:numtide/flake-utils";
    dxf2gcode-src = {
      url = "git+https://git.code.sf.net/p/dxf2gcode/sourcecode";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] ( system:
      let pkgs = nixpkgs.legacyPackages.${system}; in rec {
        packages = {
          dxf2gcode = pkgs.libsForQt5.callPackage ./dxf2gcode.nix {
            src = inputs.dxf2gcode-src;
          };
        };
        defaultPackage = packages.dxf2gcode;
      }
    );
}
