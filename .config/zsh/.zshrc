# Lines configured by zsh-newuser-install
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=1000
SAVEHIST=1000
# End ofines configured by zsh-newuser-install

### paths ###
typeset -gU PATH path
typeset -gU FPATH fpath

path=(
    '/usr/local/bin'(N-/)
    '/usr/bin'(N-/)
    '/bin'(N-/)
    '/usr/local/sbin'(N-/)
    '/usr/sbin'(N-/)
    '/sbin'(N-/)
)

path=(
    "$HOME/.local/bin"(N-/)
    "$CARGO_HOME/bin"(N-/)
    "$DENO_INSTALL/bin"(N-/)
    "$GHRD_DATA_HOME/bin"(N-/)
    "$XDG_CONFIG_HOME/scripts"(N-/)
    "$DOTNET_ROOT"(N-/)
    "$HOME/.dotnet/tools"(N-/)
    "$path[@]"
)

fpath=(
    "$GHRD_DATA_HOME/completions"(N-/)
    "$XDG_DATA_HOME/zsh/completions"(N-/)
    "$fpath[@]"
)

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt GLOBDOTS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
# setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS
setopt NO_SHARE_HISTORY
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT
setopt NO_FLOW_CONTROL

# 色を使用出来るようにする
autoload -Uz colors
colors

#補完のリストの、選択している部分を塗りつぶす
zstyle ':completion:*' menu select

#入力ミスに対応する。
# setopt correct

#直前のコマンドと同じなら、履歴に残さない
setopt hist_ignore_dups

# change zcompdump location
# compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
# zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache

### source ###
source() {
    local input="$1"
    local cache="$input.zwc"
    if [[ ! -f "$cache" || "$input" -nt "$cache" ]]; then
        zcompile "$input"
    fi
    \builtin source "$@"
}

### hooks ###
# zshaddhistory() {
#     local line="${1%%$'\n'}"
#     [[ ! "$line" =~ "^(cd|history|jj?|lazygit|la|ll|ls|rm|rmdir|trash)($| )" ]]
# }

chpwd() {
    printf "\e[34m%s\e[m:\n" "${PWD/$HOME/~}"
    if (( ${+commands[eza]} )); then
        eza --group-directories-first --icons -a
    else
        ls -a
    fi
}

### key bindings ###
widget::history() {
    local selected="$(history -inr 1 | fzf --exit-0 --query "$LBUFFER" | cut -d' ' -f4- | sed 's/\\n/\n/g')"
    if [[ -n "$selected" ]]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle -R -c # refresh screen
}

widget::ghq::source() {
    local session color icon green="\e[32m" blue="\e[34m" reset="\e[m" checked="󰄲" unchecked="󰄱"
    local sessions=($(tmux list-sessions -F "#S" 2>/dev/null))

    ghq list | sort | while read -r repo; do
        session="${repo//[:. ]/-}"
        color="$blue"
        icon="$unchecked"
        if (( ${+sessions[(r)$session]} )); then
            color="$green"
            icon="$checked"
        fi
        printf "$color$icon %s$reset\n" "$repo"
    done
}
widget::ghq::select() {
    local root="$(ghq root)"
    widget::ghq::source | fzf --exit-0 --preview="fzf-preview-git ${(q)root}/{+2}" --preview-window="right:60%" | cut -d' ' -f2-
}
widget::ghq::dir() {
    local selected="$(widget::ghq::select)"
    if [[ -z "$selected" ]]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    BUFFER="cd ${(q)repo_dir}"
    zle accept-line
    zle -R -c # refresh screen
}
widget::ghq::session() {
    local selected="$(widget::ghq::select)"
    if [[ -z "$selected" ]]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    local session_name="${selected//[:. ]/-}"

    # if [[ -z "$ZELLIJ" ]]; then
    #     BUFFER="zellij -s ${(q)session_name} run --cwd ${(q)repo_dir} -- pwd"
    #     zle accept-line
    # else
    #     BUFFER="zellij action new-tab -n ${(q)session_name} --cwd ${(q)repo_dir} -- pwd"
    #     zle accept-line
    # fi
    BUFFER="cd ${(q)repo_dir}"
    zle accept-line
    zle -R -c # refresh screen
}

zle -N widget::history
zle -N widget::ghq::dir
zle -N widget::ghq::session
zle -N forward-kill-word

bindkey -v
bindkey "^R"        widget::history                 # C-r
bindkey "^G"        widget::ghq::session            # C-g
bindkey "^[g"       widget::ghq::dir                # Alt-g
bindkey "^A"        beginning-of-line               # C-a
bindkey "^E"        end-of-line                     # C-e
bindkey "^K"        kill-line                       # C-k
bindkey "^Q"        push-line-or-edit               # C-q
bindkey "^W"        vi-backward-kill-word           # C-w
bindkey "^?"        backward-delete-char            # backspace
bindkey "^[[3~"     delete-char                     # delete
bindkey "^[[1;3D"   backward-word                   # Alt + arrow-left
bindkey "^[[1;3C"   forward-word                    # Alt + arrow-right
bindkey "^[^?"      vi-backward-kill-word           # Alt + backspace
bindkey "^[[1;33~"  kill-word                       # Alt + delete
bindkey -M vicmd "^A" beginning-of-line             # vi: C-a
bindkey -M vicmd "^E" end-of-line                   # vi: C-e

# Change the cursor between 'Line' and 'Block' shape
function zle-keymap-select zle-line-init zle-line-finish {
    case "${KEYMAP}" in
        main|viins)
            printf '\033[6 q' # line cursor
            ;;
        vicmd)
            printf '\033[2 q' # block cursor
            ;;
    esac
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select


# sheldon
sheldon::load() {
    local profile="$1"
    local plugins_file="$SHELDON_CONFIG_DIR/plugins.toml"
    local cache_file="$XDG_CACHE_HOME/sheldon/$profile.zsh"
    if [[ ! -f "$cache_file" || "$plugins_file" -nt "$cache_file" ]]; then
        mkdir -p "$XDG_CACHE_HOME/sheldon"
        sheldon --profile="$profile" source >"$cache_file"
        zcompile "$cache_file"
    fi
    \builtin source "$cache_file"
}

sheldon::update() {
    sheldon --profile="eager" lock --update
    sheldon --profile="lazy" lock --update
    gh-rd
}

sheldon::load eager