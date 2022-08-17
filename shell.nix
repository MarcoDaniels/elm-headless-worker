let
  pkgs = import (fetchTarball {
    name = "nixpkgs-22.05-darwin-20-08-2022";
    url =
      "https://github.com/NixOS/nixpkgs/archive/50b6709b401f0bfa7e8fadd50c14a8c63c319156.tar.gz";
    sha256 = "1rcyfp6bdfkqy6bmnp1jbhk84rsprks5ynz827dq78164ksxm9ir";
  }) { };

  start = pkgs.writeShellScriptBin "start" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize src/Main.elm --output=dist/main.js
    ${pkgs.nodejs}/bin/node index.js $1
  '';

in pkgs.mkShell {
  buildInputs = [
    pkgs.nixfmt
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.nodejs
    # custom scripts
    start
  ];
}
