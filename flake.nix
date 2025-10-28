{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = [
        pkgs.awscli2
        pkgs.nodejs_22
        pkgs.playwright-driver.browsers
        (pkgs.python313.withPackages (p:
          with p; [
            boto3
            moto
            pytest
            pytest-playwright
          ]))
      ];

      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.libz
      ];

      env.PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      env.PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;

      shellHook = "
        python -m venv .venv
        source .venv/bin/activate
      ";
    };
  };
}
