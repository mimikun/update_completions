#!/bin/bash

shfmt ./update_bat_fish_completion.sh > ./fmt-update_bat_fish_completion.sh
mv ./fmt-update_bat_fish_completion.sh ./update_bat_fish_completion.sh
chmod +x ./update_bat_fish_completion.sh

shfmt ./update_fish_completions.sh > ./fmt-update_fish_completions.sh
mv ./fmt-update_fish_completions.sh ./update_fish_completions.sh
chmod +x ./update_fish_completions.sh

shfmt ./update_ripgrep_fish_completion.sh > ./fmt-update_ripgrep_fish_completion.sh
mv ./fmt-update_ripgrep_fish_completion.sh ./update_ripgrep_fish_completion.sh
chmod +x ./update_ripgrep_fish_completion.sh
