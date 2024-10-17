function update_completions --description 'Update completions'
    set -l completions_dir $__fish_config_dir/completions

    echo "Update: default commands completions"
    fish_update_completions >/dev/null 2>&1

    echo "Update: poetry, rustup, deno, mdbook and starship completions"
    for cmd in poetry rustup starship deno mdbook
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

    echo "Update: chezmoi, berg, flyctl, bin, mise, luarocks, gopass, glow, pnpm, aqua and runme completions"
    for cmd in chezmoi berg flyctl runme bin mise luarocks gopass glow pnpm aqua
        if command_exist $cmd
            $cmd completion fish > $completions_dir/$cmd.fish
        end
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

    echo "Update: ripgrep completion"
    if command_exist rg
        rg --generate complete-fish > $completions_dir/rg.fish
    end

    echo "Update: rbw completion"
    if command_exist rbw
        rbw gen-completions fish > $completions_dir/rbw.fish
    end

    echo "Update: helix completion"
    if command_exist hx
        curl -L https://raw.githubusercontent.com/helix-editor/helix/master/contrib/completion/hx.fish -o $completions_dir/hx.fish >/dev/null 2>&1
    end

    echo "Update: alacritty completion"
    if command_exist alacritty
        curl -L https://raw.githubusercontent.com/alacritty/alacritty/master/extra/completions/alacritty.fish -o $completions_dir/alacritty.fish >/dev/null 2>&1
    end

    echo "Update: uv completion"
    if command_exist uv
        uv --generate-shell-completion fish > $completions_dir/uv.fish
    end

    echo "Update: ghq completion"
    if command_exist ghq
        curl -L https://raw.githubusercontent.com/x-motemen/ghq/master/misc/fish/ghq.fish -o $completions_dir/ghq.fish >/dev/null 2>&1
    end

    echo "Update: fish-lsp completion"
    if command_exist fish-lsp
        fish-lsp complete --fish > $completions_dir/fish-lsp.fish
    end

    echo "Update: atuin completion"
    if command_exist atuin
        atuin gen-completions --shell fish > $completions_dir/atuin.fish
    end

    echo "Update: foot completion"
    if command_exist foot
      curl -L https://codeberg.org/dnkl/foot/raw/branch/master/completions/fish/foot.fish -o $completions_dir/foot.fish >/dev/null 2>&1
    end

    echo "Update: footclient completion"
    if command_exist footclient
      curl -L https://codeberg.org/dnkl/foot/raw/branch/master/completions/fish/footclient.fish -o $completions_dir/footclient.fish >/dev/null 2>&1
    end

    echo "Update: nix completion"
    if command_exist nix
      curl -L https://raw.githubusercontent.com/NixOS/nix/master/misc/fish/completion.fish -o $completions_dir/nix.fish >/dev/null 2>&1
    end

    echo "Update: nb completion"
    if command_exist nb
      curl -L https://raw.githubusercontent.com/xwmx/nb/refs/heads/master/etc/nb-completion.fish -o $completions_dir/nb.fish >/dev/null 2>&1
    end

    echo "Update: sharkdp/bat, sharkdp/hyperfine and sharkdp/pastel completions"
    for cmd in bat hyperfine pastel
        if command_exist $cmd
            update_sharkdp_tool_completions $cmd
        end
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

function update_sharkdp_tool_completions
    set -l completions_dir $__fish_config_dir/completions
    set -l cmd_name $argv[1]
    set -l repo_name sharkdp/$cmd_name
    set -l cmd_version (curl --silent https://api.github.com/repos/$repo_name/releases/latest | jq .tag_name -r)
    set -l archive_name "$cmd_name-$cmd_version-x86_64-unknown-linux-gnu"
    set -l archive_format "tar.gz"
    set -l archive_file "$archive_name.$archive_format"
    set -l download_url "https://github.com/$repo_name/releases/download/$cmd_version/$archive_file"
    pushd /tmp
    wget $download_url > /dev/null 2>&1
    tar xvf $archive_file > /dev/null 2>&1
    cp $archive_name/autocomplete/$cmd_name.fish $completions_dir/$cmd_name.fish
    rm -rf $archive_file*
    popd
end
