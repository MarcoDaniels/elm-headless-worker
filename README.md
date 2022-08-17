# Elm Headless Worker

Examples with [elm worker](https://package.elm-lang.org/packages/elm/core/latest/Platform#worker).

## Requirements

[nix package manager](https://nixos.org/download.html)

## Simple Example

Start a [pure nix shell](https://nixos.org/manual/nix/unstable/command-ref/nix-shell.html#options) with

```nix
nix-shell --pure shell.nix
```

Available commands within the nix-shell:

- start 123
  - builds and runs example with "123" as input