let
  pkgs = import (fetchTarball {
    name = "nixpkgs-22.05-darwin-20-08-2022";
    url =
      "https://github.com/NixOS/nixpkgs/archive/50b6709b401f0bfa7e8fadd50c14a8c63c319156.tar.gz";
    sha256 = "1rcyfp6bdfkqy6bmnp1jbhk84rsprks5ynz827dq78164ksxm9ir";
  }) { };

  startServer = pkgs.writeShellScriptBin "startServer" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize src/BunServer.elm --output=dist/bunServerElm.js
    ${pkgs.bun}/bin/bun run src/bunServer.js
  '';

in pkgs.mkShell {
  buildInputs = [
    pkgs.nixfmt
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.bun
    # custom scripts
    startServer
  ];
}
