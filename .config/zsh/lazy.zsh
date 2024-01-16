### ls-colors ###
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

### Aliases ###
alias la='ls -a'
alias ll='ls -al'
alias wget='wget --hsts-file="$XDG_STATE_HOME/wget-hsts"'

### bat ###
if (( ${+commands[bat]} )); then
    export MANPAGER="sh -c 'col -bx | bat --color=always --language=man --plain'"

    alias cat='bat --paging=never'
fi

### eza ###
if (( ${+commands[eza]} )); then
    alias ls='eza --group-directories-first'
    alias la='eza --group-directories-first -a'
    alias ll='eza --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
    alias tree='eza --group-directories-first --tree --icons'
fi

### diff ###
diff() {
    command diff "$@" | bat --paging=never --plain --language=diff
    return "${pipestatus[1]}"
}
alias diffall='diff --new-line-format="+%L" --old-line-format="-%L" --unchanged-line-format=" %L"'

### hgrep ###
alias hgrep="hgrep --hidden --glob='!.git/'"

### completion styles ###
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"


### Editor ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

### Node.js ###
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_history"

### npm ###
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_DATA_DIR="$XDG_DATA_HOME/npm"
export NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$NPM_CONFIG_DIR/npmrc"

### FZF ###
export FZF_DEFAULT_OPTS='--reverse --border --ansi --bind="ctrl-d:print-query,ctrl-p:replace-query"'
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'

### ripgrep ###
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

### local ###
if [[ -f "$ZDOTDIR/local.zsh" ]]; then
    source "$ZDOTDIR/local.zsh"
fi

### gpg ###
export GPG_TTY=$(tty)

### dotnet ###
path=(
    "$path[@]"
    "$DOTNET_ROOT"(N-/)
    "~/.dotnet/tools"(N-/)
)

sheldon::load lazy

/boot/dietpi/func/dietpi-banner 1