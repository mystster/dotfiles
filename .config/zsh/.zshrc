# Lines configured by zsh-newuser-install
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# 色を使用出来るようにする
autoload -Uz colors
colors

#補完機能を有効にする
autoload -Uz compinit
compinit

#補完のリストの、選択している部分を塗りつぶす
zstyle ':completion:*' menu select

#入力ミスに対応する。
setopt correct

#直前のコマンドと同じなら、履歴に残さない
setopt hist_ignore_dups

# change zcompdump location
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
