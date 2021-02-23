#!/usr/bin/env bash
set -e

MIX_HOME="$(elixir -e 'Mix.Utils.mix_home() |> IO.puts()')"

function which() {
  which $@ 1>/dev/null 2>&1
  return $?
}

if which asdf; then
  echo "Reshimming asdf..."
  echo "If warnings about masking executables in your path appeared, you can safely ignore them."
  asdf reshim
fi

if  which protoc-gen-elixir; then
  true
else
  echo "<<===========----------=============>>" >&2
  echo "WARNING: to complete the setup add '$MIX_HOME/escripts' to your PATH!" >&2
  echo "<<===========----------=============>>" >&2
  exit 1;
fi

set +e
