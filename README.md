# Elm Headless Worker

Examples with [elm worker](https://package.elm-lang.org/packages/elm/core/latest/Platform#worker) in different JavaScript runtimes.

## Requirements

[nix package manager](https://nixos.org/download.html)

## Examples

Start a [pure nix shell](https://nixos.org/manual/nix/unstable/command-ref/nix-shell.html#options) with

```nix
nix-shell --pure shell.nix
```

Available commands within the nix-shell:

- startSimpleNode 123
  - compiles Elm simple worker and runs nodejs simple example with "123" as input
- startNodeServer
  - compiles Elm server worker and starts a nodejs server in http://localhost:8000
- startDenoServer
  - compiles Elm server worker and starts a deno server in http://localhost:8000
- startBunServer
  - compiles Elm server worker and starts a bun server in http://localhost:8000