{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = with inputs; [
        devshell.flakeModule
        treefmt.flakeModule
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, ... }: {

        packages.default = pkgs.callPackage ./. {};

        devshells.default = (
          { extraModulesPath, ... }@args:
          {
            imports = [ "${extraModulesPath}/git/hooks.nix" ];
            git.hooks.enable = false;
          }
        );
        treefmt = {
          programs.clang-format.enable = false;
          programs.nixfmt.enable = true;
          programs.prettier = {
            enable = false;
            includes = [
              "*.md"
              "*.yml"
            ];
          };
        };
      };
    };
}
