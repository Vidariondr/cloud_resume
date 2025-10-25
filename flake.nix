{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = [
        pkgs.awscli2
        (pkgs.python313.withPackages (p:
          with p; [
            pip
          ]))
      ];

      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.libz
      ];

      shellHook = "
        python -m venv .venv
        source .venv/bin/activate
      ";
    };
  };
}
