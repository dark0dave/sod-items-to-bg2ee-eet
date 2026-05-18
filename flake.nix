{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    hk = {
      url = "github:jdx/hk/v1.44.2";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      hk,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f system);
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default =
            with pkgs;
            mkShell rec {
              nativeBuildInputs = [
                codespell
                git
                hk.packages.${system}.default
                nixfmt
                weidu
                yamlfmt
              ];
              buildInputs = [
                openssl
              ];
              env.HK_PKL_BACKEND = "pklr";
            };
        }
      );
      formatter = forEachSystem (system: nixpkgs.${system}.nixfmt);
    };
}
