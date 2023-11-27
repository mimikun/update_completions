#!/bin/bash

current_dir=$(pwd)

run_shfmt() {
  shfmt ./"$1" >./fmt-"$1"
  mv ./fmt-"$1" ./"$1"
  chmod +x ./"$1"
}

run_shfmt update_bat_fish_completion.sh
run_shfmt update_fish_completions.sh
run_shfmt update_helix_fish_completion.sh
run_shfmt update_hyperfine_fish_completion.sh

cd utils || exit
run_shfmt format.sh
run_shfmt install.sh
run_shfmt lint.sh
cd "$current_dir" || exit
