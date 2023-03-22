#!/bin/bash

before_sudo() {
  if ! test "$(
    sudo uname >>/dev/null
    echo $?
  )" -eq 0; then
    exit 1
  fi
}

run_install() {
  sudo cp ./"$1".sh ~/.local/bin/"$1"
}

before_sudo
run_install update_bat_fish_completion
run_install update_fish_completions
run_install update_ripgrep_fish_completion
