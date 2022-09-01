let
  pkgs = import (fetchTarball {
    name = "nixpkgs-22.05-darwin-20-08-2022";
    url =
      "https://github.com/NixOS/nixpkgs/archive/50b6709b401f0bfa7e8fadd50c14a8c63c319156.tar.gz";
    sha256 = "1rcyfp6bdfkqy6bmnp1jbhk84rsprks5ynz827dq78164ksxm9ir";
  }) { };

  startSimpleNode = pkgs.writeShellScriptBin "startSimpleNode" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize node/src/Simple.elm --output=node/dist/simple.js
    ${pkgs.nodejs}/bin/node node/src/simple.js $1
  '';

  startNodeServer = pkgs.writeShellScriptBin "startNodeServer" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize node/src/Server.elm --output=node/dist/server.js
    ${pkgs.nodejs}/bin/node node/src/server.js
  '';

  startDenoServer = pkgs.writeShellScriptBin "startDenoServer" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize deno/src/DenoServer.elm --output=deno/dist/denoServerElm.js
    ${pkgs.deno}/bin/deno run --allow-read --allow-env=NODE_DEBUG --allow-net deno/src/denoServer.ts
  '';

  startBunServer = pkgs.writeShellScriptBin "startBunServer" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize bun/src/BunServer.elm --output=bun/dist/bunServerElm.js
    ${pkgs.bun}/bin/bun run bun/src/bunServer.js
  '';

in pkgs.mkShell {
  buildInputs = [
    pkgs.nixfmt
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.bun
    pkgs.deno
    pkgs.nodejs
    # custom scripts
    startSimpleNode
    startNodeServer
    startDenoServer
    startBunServer
  ];
}
