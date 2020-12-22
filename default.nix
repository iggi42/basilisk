{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;

  elixir = beam.packages.erlangR22.elixir_1_10;
in

mkShell {
  buildInputs = [
      elixir
    ]
  ++ optional stdenv.isLinux glibcLocales # To allow setting consistent locale on linux
  ++ optional stdenv.isLinux libnotify # For ExUnit
  ;

  shellHook = ''
    export XDG_CONFIG_HOME="$HOME/.config"
    export TERM=xterm
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
  '';
}
