let
  pkgs = import (fetchTarball {
    name = "nixpkgs-22.05-darwin-20-08-2022";
    url =
      "https://github.com/NixOS/nixpkgs/archive/50b6709b401f0bfa7e8fadd50c14a8c63c319156.tar.gz";
    sha256 = "1rcyfp6bdfkqy6bmnp1jbhk84rsprks5ynz827dq78164ksxm9ir";
  }) { };

  startSimple = pkgs.writeShellScriptBin "startSimple" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize node/src/Simple.elm --output=node/dist/simple.js
    ${pkgs.nodejs}/bin/node node/src/simple.js $1
  '';

    startServer = pkgs.writeShellScriptBin "startServer" ''
      ${pkgs.elmPackages.elm}/bin/elm make --optimize node/src/Server.elm --output=node/dist/server.js
      ${pkgs.nodejs}/bin/node node/src/server.js
    '';

in pkgs.mkShell {
  buildInputs = [
    pkgs.nixfmt
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.nodejs
    # custom scripts
    startSimple
    startServer
  ];
}
