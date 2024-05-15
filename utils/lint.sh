#!/bin/bash

run_lint() {
  shellcheck ./"$1"
}

run_lint update_bat_fish_completion.sh
run_lint update_fish_completions.sh
run_lint update_hyperfine_fish_completion.sh
run_lint update_pastel_fish_completion.sh

run_lint utils/changelog.sh
run_lint utils/clean.sh
run_lint utils/create-patch.sh
run_lint utils/format.sh
run_lint utils/install.sh
run_lint utils/lint.sh
