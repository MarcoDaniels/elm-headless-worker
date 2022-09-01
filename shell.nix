let
  pkgs = import (fetchTarball {
    name = "nixpkgs-22.05-darwin-20-08-2022";
    url =
      "https://github.com/NixOS/nixpkgs/archive/50b6709b401f0bfa7e8fadd50c14a8c63c319156.tar.gz";
    sha256 = "1rcyfp6bdfkqy6bmnp1jbhk84rsprks5ynz827dq78164ksxm9ir";
  }) { };

  startSimpleNode = pkgs.writeShellScriptBin "startSimpleNode" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize node/Simple.elm --output=dist/simple.js
    ${pkgs.nodejs}/bin/node node/simple.js $1
  '';

  startNodeServer = pkgs.writeShellScriptBin "startNodeServer" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize node/Server.elm --output=dist/server.js
    ${pkgs.nodejs}/bin/node node/server.js
  '';

  startDenoServer = pkgs.writeShellScriptBin "startDenoServer" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize deno/DenoServer.elm --output=dist/denoServerElm.js
    ${pkgs.deno}/bin/deno run --allow-read --allow-env=NODE_DEBUG --allow-net deno/denoServer.ts
  '';

  startBunServer = pkgs.writeShellScriptBin "startBunServer" ''
    ${pkgs.elmPackages.elm}/bin/elm make --optimize bun/BunServer.elm --output=dist/bunServerElm.js
    ${pkgs.bun}/bin/bun run bun/bunServer.js
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
