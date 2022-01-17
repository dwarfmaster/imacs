{
  description = "IMACS: Intelligent Multi-Agent Chores Scheduler";

  inputs = {
    nixpkgs.url = "nixpkgs";
    django-nixos.url = "github:pnmadelaine/django-nixos";
  };

  outputs = { self, nixpkgs, django-nixos }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    python = pkgs.python38.withPackages (ps: with ps; [ django_3 ]);
  in
  {
    devShell.${system} = pkgs.stdenv.mkDerivation {
      name = "django-dev-shell";
      buildInputs = [ python ];
      shellHook = ''
        source ${./dev_secrets.sh}
      '';
    };
    mkNixosModule = { fqdn, keys-file }: django-nixos.lib.mkNixosModule {
      name = "imacs";
      inherit pkgs;
      inherit keys-file fqdn;
      src = ./.;
      settings = "imacs.settings.nix";
    };
  };
}
