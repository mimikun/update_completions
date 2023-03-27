function update_completions --description 'Update completions'
    set -l completions_dir $__fish_config_dir/completions
    set -l current_dir (pwd)

    echo "Update: default commands completions"
    fish_update_completions >/dev/null 2>&1

    echo "Update: poetry, rustup, deno and starship completions"
    for cmd in poetry rustup starship deno
        if command_exist $cmd
            $cmd completions fish > $completions_dir/$cmd.fish
        end
    end

    echo "Update: asdf completions"
    if command_exist asdf
        cp ~/.asdf/completions/asdf.fish $completions_dir/asdf.fish
    end

    echo "Update: bun completions"
    if command_exist bun
        bun completions >/dev/null 2>&1
    end

    echo "Update: chezmoi, flyctl, and runme completions"
    for cmd in chezmoi flyctl runme bin
        if command_exist $cmd
            $cmd completion fish > $completions_dir/$cmd.fish
        end
    end

    echo "Update: pnpm completions"
    if command_exist pnpm
        pnpm install-completion fish > /dev/null 2>&1
    end

    echo "Update: yq completions"
    if command_exist yq
        yq shell-completion fish > $completions_dir/yq.fish
    end

    echo "Update: GitHub CLI completions"
    if command_exist gh
        gh completion -s fish > $completions_dir/gh.fish
    end

    echo "Update: fd completions"
    if command_exist fd
        fd --gen-completions fish > $completions_dir/fd.fish
    end

    echo "Update: pueue completions"
    if command_exist pueue
        pueue completions fish $completions_dir
    end

    echo "Update: exa completions"
    if command_exist exa
        curl -L https://raw.githubusercontent.com/ogham/exa/master/completions/fish/exa.fish -o $completions_dir/exa.fish >/dev/null 2>&1
    end

    echo "Update: tealdeer completions"
    if command_exist tldr
        curl -L https://raw.githubusercontent.com/dbrgn/tealdeer/main/completion/fish_tealdeer -o $completions_dir/tldr.fish >/dev/null 2>&1
    end

    echo "Update: httpie completions"
    if command_exist http
        curl -L https://raw.githubusercontent.com/httpie/httpie/master/extras/httpie-completion.fish -o $completions_dir/http.fish >/dev/null 2>&1
        cp $completions_dir/http.fish $completions_dir/https.fish >/dev/null 2>&1
    end

    echo "Update: bat completions"
    if command_exist bat
        set -l bat_repo "sharkdp/bat"
        set -l bat_version (curl --silent https://api.github.com/repos/$bat_repo/releases/latest | jq .tag_name -r)
        set -l bat_tar_file "bat-$bat_version-x86_64-unknown-linux-gnu"
        curl -L https://github.com/$bat_repo/releases/download/$bat_version/$bat_tar_file.tar.gz -o /tmp/$bat_tar_file.tar.gz >/dev/null 2>&1
        cd /tmp ; and tar xvf /tmp/$bat_tar_file.tar.gz >/dev/null 2>&1
        cd $current_dir
        cp /tmp/$bat_tar_file/autocomplete/bat.fish $completions_dir/bat.fish
        rm -rf /tmp/bat*
    end

    echo "Update: ripgrep completions"
    if command_exist rg
        set -l rg_repo "BurntSushi/ripgrep"
        set -l rg_version (curl --silent https://api.github.com/repos/$rg_repo/releases/latest | jq .tag_name -r)
        set -l rg_tar_file "ripgrep-$rg_version-x86_64-unknown-linux-musl"
        curl -L https://github.com/$rg_repo/releases/download/$rg_version/$rg_tar_file.tar.gz -o /tmp/$rg_tar_file.tar.gz >/dev/null 2>&1
        cd /tmp ; and tar xvf /tmp/$rg_tar_file.tar.gz >/dev/null 2>&1
        cd $current_dir
        cp /tmp/$rg_tar_file/complete/rg.fish $completions_dir/rg.fish
        rm -rf /tmp/ripgrep*
    end
end

function command_exist
    if type $argv[1] >/dev/null 2>&1
        return 0
    else
        echo $argv[1]: not found
        return 1
    end
end

