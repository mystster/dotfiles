export XDG_ROOT_HOME="${XDG_ROOT_HOME:-$HOME}"

export XDG_DATA_HOME="${XDG_DATA_HOME:-$XDG_ROOT_HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$XDG_ROOT_HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$XDG_ROOT_HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$XDG_ROOT_HOME/.cache}"

# pass for git credential manager
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass

# GnuPG
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# git credential manager
export GCM_CREDENTIAL_STORE=gpg

# dotnet
export DOTNET_ROOT="$XDG_DATA_HOME"/dotnet

### Rust ###
export RUST_BACKTRACE=1
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# deno
export DENO_INSTALL="${DENO_INSTALL:-$XDG_DATA_HOME/deno}"
export DENO_INSTALL_ROOT="$DENO_INSTALL"

### sheldon ###
export SHELDON_CONFIG_DIR="$ZDOTDIR"

### gh-rd ###
export GHRD_CONFIG_HOME="$XDG_CONFIG_HOME/gh-rd"
export GHRD_DATA_HOME="$XDG_DATA_HOME/gh-rd"