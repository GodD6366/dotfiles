if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod go-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
# examples here -> https://wiki.zshell.dev/ecosystem/category/-annexes
zicompinit # <- https://wiki.zshell.dev/docs/guides/commands


autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# completion detail
zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*:*sh:*:' tag-order files

# case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# process completion
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"



# Load pure theme
# https://github.com/sindresorhus/pure
zi light-mode for @sindresorhus/pure

# zi ice depth=1;
# zi light romkatv/powerlevel10k

# zinit light spaceship-prompt/spaceship-prompt


zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/termsupport.zsh


zi ice lucid wait as'completion'
zi light zsh-users/zsh-completions
# zinit light zsh-users/zsh-completions

# zinit light zsh-users/zsh-autosuggestions
# zinit light zdharma-continuum/fast-syntax-highlighting
zi ice wait lucid atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zi light z-shell/F-Sy-H
zi ice wait lucid atload"!_zsh_autosuggest_start"
zi load zsh-users/zsh-autosuggestions

zinit light agkozak/zsh-z
zinit light SukkaW/zsh-gitcd

zi ice lucid wait has'fzf'
zi light Aloxaf/fzf-tab

zi ice wait lucid
zi load z-shell/zsh-navigation-tools

# zi ice as"completion"
# zi snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

omz_plugins=(
    git
    npm
    yarn
    sudo
    extract
    dotenv
)
for plugin in ${omz_plugins[@]}; do
    zinit snippet OMZP::$plugin
done

# Switching directories for lazy people
setopt autocd
# See: http://zsh.sourceforge.net/Intro/intro_6.html
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups

# Disable correction
unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true"
alias dh='dirs -v'

# load custom shell
source $HOME/dotfiles/_zshrc/extends/common.zshrc
source $HOME/dotfiles/_zshrc/extends/mac-only.zshrc