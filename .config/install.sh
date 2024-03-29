#!/usr/bin/env bash

export CUR_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
export XDG_ROOT_HOME="$(cd $CUR_DIR/.. || exit 1; pwd)"

# パス情報の読み込み
. $CUR_DIR/zsh/.zshenv

# add link
mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_STATE_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_CACHE_HOME"

if [[ ! -e "$HOME/.zshenv" ]]; then
    ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"
fi
if [[ ! -e "$HOME/.vim" ]]; then
    ln -sfnv "$XDG_CONFIG_HOME/vim" "$HOME/.vim"
fi

# Deno install
if [[ -x "$DENO_INSTALL/bin/deno" ]]; then
    echo "Deno is already installed."
    "$DENO_INSTALL/bin/deno" upgrade
else
    echo "Installing Deno..."
    curl -fsSL https://deno.land/x/install/install.sh | /bin/sh
fi

echo "Install Deno completions..."
mkdir -p "$XDG_DATA_HOME/zsh/completions"
"$DENO_INSTALL/bin/deno" completions zsh >"$XDG_DATA_HOME/zsh/completions/_deno"

#rust install
if [[ $RUST_INSTALL = "true" ]]; then
    echo "Install RUST..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
fi

#pnpm install
if [[ $PNPM_INSTALL = "true" ]]; then
    echo "Install pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# gh-rd install
curl -fsSL https://raw.githubusercontent.com/Ryooooooga/gh-rd/main/install.bash | /bin/bash

# add to path
export PATH="$DENO_INSTALL/bin:$PATH"

# install using gh-rd
"$GHRD_DATA_HOME/bin/gh-rd"