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

    echo "Update: brew completion"
    if command_exist brew
        cp (brew --prefix)/Homebrew/completions/fish/brew.fish $completions_dir/brew.fish
    end

    echo "Update: bun completion"
    if command_exist bun
        bun completions >/dev/null 2>&1
    end

    echo "Update: chezmoi, flyctl, bin, mise, luarocks and runme completions"
    for cmd in chezmoi flyctl runme bin mise luarocks
        if command_exist $cmd
            $cmd completion fish > $completions_dir/$cmd.fish
        end
    end

    echo "Update: pnpm completion"
    if command_exist pnpm
        pnpm install-completion fish > /dev/null 2>&1
    end

    echo "Update: yq completion"
    if command_exist yq
        yq shell-completion fish > $completions_dir/yq.fish
    end

    echo "Update: GitHub CLI completion"
    if command_exist gh
        gh completion -s fish > $completions_dir/gh.fish
    end

    echo "Update: fd completion"
    if command_exist fd
        fd --gen-completions fish > $completions_dir/fd.fish
    end

    echo "Update: pueue completion"
    if command_exist pueue
        pueue completions fish $completions_dir
    end

    echo "Update: pipx completion"
    if command_exist pipx
        register-python-argcomplete --shell fish pipx > $completions_dir/pipx.fish
    end

    echo "Update: zellij completion"
    if command_exist zellij
        zellij setup --generate-completion fish > $completions_dir/zellij.fish
    end

    echo "Update: wezterm completion"
    if command_exist wezterm
        wezterm shell-completion --shell fish > $completions_dir/wezterm.fish
    end

    echo "Update: rye completion"
    if command_exist rye
        rye self completion -s fish > $completions_dir/rye.fish
    end

    echo "Update: procs completion"
    if command_exist procs
        procs --gen-completion-out fish > $completions_dir/procs.fish
    end

    echo "Update: sheldon completion"
    if command_exist sheldon
      sheldon completions --shell fish > $completions_dir/sheldon.fish
    end

    echo "Update: eza completion"
    if command_exist eza
        curl -L https://raw.githubusercontent.com/eza-community/eza/main/completions/fish/eza.fish -o $completions_dir/exa.fish >/dev/null 2>&1
    end

    echo "Update: tealdeer completion"
    if command_exist tldr
        curl -L https://raw.githubusercontent.com/dbrgn/tealdeer/main/completion/fish_tealdeer -o $completions_dir/tldr.fish >/dev/null 2>&1
    end

    echo "Update: zoxide completion"
    if command_exist zoxide
      curl -L https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/contrib/completions/zoxide.fish -o $completions_dir/zoxide.fish >/dev/null 2>&1
    end

    echo "Update: httpie completions"
    if command_exist http
        curl -L https://raw.githubusercontent.com/httpie/httpie/master/extras/httpie-completion.fish -o $completions_dir/http.fish >/dev/null 2>&1
        cp $completions_dir/http.fish $completions_dir/https.fish >/dev/null 2>&1
    end

    echo "Update: bat completion"
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

    echo "Update: hyperfine completion"
    if command_exist hyperfine
        set -l hyperfine_repo "sharkdp/hyperfine"
        set -l hyperfine_version (curl --silent https://api.github.com/repos/$hyperfine_repo/releases/latest | jq .tag_name -r)
        set -l hyperfine_tar_file "hyperfine-$hyperfine_version-x86_64-unknown-linux-gnu"
        curl -L https://github.com/$hyperfine_repo/releases/download/$hyperfine_version/$hyperfine_tar_file.tar.gz -o /tmp/$hyperfine_tar_file.tar.gz >/dev/null 2>&1
        cd /tmp ; and tar xvf /tmp/$hyperfine_tar_file.tar.gz >/dev/null 2>&1
        cd $current_dir
        cp /tmp/$hyperfine_tar_file/autocomplete/hyperfine.fish $completions_dir/hyperfine.fish
        rm -rf /tmp/hyperfine*
    end

    echo "Update: ripgrep completion"
    if command_exist rg
        rg --generate complete-fish > $completions_dir/rg.fish
    end

    echo "Update: helix completion"
    if command_exist hx
        set -l hx_repo "helix-editor/helix"
        set -l hx_version (curl --silent https://api.github.com/repos/$hx_repo/releases/latest | jq .tag_name -r)
        set -l hx_tar_file "helix-$hx_version-x86_64-linux"
        curl -L https://github.com/$hx_repo/releases/download/$hx_version/$hx_tar_file.tar.xz -o /tmp/$hx_tar_file.tar.xz >/dev/null 2>&1
        cd /tmp ; and tar xvf /tmp/$hx_tar_file.tar.xz >/dev/null 2>&1
        cd $current_dir
        cp /tmp/$hx_tar_file/contrib/completion/hx.fish $completions_dir/hx.fish
        rm -rf /tmp/helix*
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
