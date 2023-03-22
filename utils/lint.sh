#!/bin/bash

run_lint() {
  shellcheck ./"$1"
}

run_lint update_bat_fish_completion.sh
run_lint update_fish_completions.sh
run_lint update_ripgrep_fish_completion.sh

run_lint utils/format.sh
run_lint utils/install.sh
run_lint utils/lint.sh
