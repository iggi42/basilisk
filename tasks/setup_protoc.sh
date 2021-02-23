#!/usr/bin/env bash
set -e

MIX_HOME="$(elixir -e 'Mix.Utils.mix_home() |> IO.puts()')"

if type asdf &>/dev/null; then
  echo "Reshimming asdf..."
  echo "If warnings about masking executables in your path appeared, you can safely ignore them."
  asdf reshim
fi

if ! type protoc-gen-elixir &>/dev/null; then
  echo "<<===========----------=============>>" >&2
  echo "WARNING: to complete the setup add '$MIX_HOME/escripts' to your PATH!" >&2
  echo "<<===========----------=============>>" >&2
  exit 1;
fi

set +e
