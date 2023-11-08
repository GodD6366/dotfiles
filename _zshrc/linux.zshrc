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

# Set NPM Global Path
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
# Create .npm-global folder if not exists
[[ ! -d "$HOME/.npm-global" ]] && mkdir -p $HOME/.npm-global

# fnm
if (( $+commands[fnm] )); then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Path should be set after fnm
export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$HOME/.yarn/bin:$NPM_CONFIG_PREFIX/bin:/usr/local/opt/openjdk/bin:/usr/local/opt/openjdk@8/bin:/opt/homebrew/bin:$PATH"


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

if (( $+commands[code] )); then
    alias zshconfig="code $HOME/.zshrc"
elif (( $+commands[we] )); then
    alias zshconfig="we $HOME/.zshrc"
else
    alias zshconfig="nano $HOME/.zshrc"
fi


alias ll="ls -al"


# Git Undo
alias git-undo="git reset --soft HEAD^"
# Git Delete Local Merged
git-delete-local-merged() {
    red=$(tput setaf 1)
    blue=$(tput setaf 4)
    green=$(tput setaf 2)
    reset=$(tput sgr0)

    branches=($(git branch --merged master | grep -v "\*\|master\|unstable\|develop"))

    (( ! $#branches )) && printf "${green}\nNo merged branches to delete!${reset}\n"

    command="git branch -d $branches"

    echo ""
    printf "%s" "$branches"
    echo ""

    printf "\n${blue}Delete merged branches locally? Press [Enter] to continue...${reset}"
    read _

    echo ""
    echo "Safely deleting merged local branches..."

    for branch ($branches); do
        git branch -d $branch
    done

    echo "${green}Done!${reset}"
}

alias ping="nali-ping"
alias dig="nali-dig"
alias traceroute="nali-traceroute"
alias tracepath="nali-tracepath"
alias nslookup="nali-nslookup"

# Enable sudo in aliased
# http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# Avoid stupidity with trash-cli:
# https://github.com/sindresorhus/trash-cli
# or use default rm -i
if (( $+commands[trash] )); then
  alias rm='trash'
else
  alias rm='rm -i'
fi

alias q="cd $HOME && clear"

alias digshort="dig @1.0.0.1 +short "

# Kills all docker containers running
docker-kill-all() {
    docker kill $(docker ps -aq)
}

cfdns="@1.0.0.1 +tcp"

alias flushdns="clear_dns_cache"

ci-edit-update() {
    (
        cd "$HOME/ci_edit"
        git pull
    ) && sudo "$HOME/ci_edit/install.sh"
}

git-config(){
    git config --global pull.rebase true
    git config --global alias.s status
    git config --global alias.sb "status -sb"
    git config --global alias.d diff
    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.br branch
    git config --global alias.last "log -1 HEAD"
    git config --global alias.cane "commit --amend --no-edit"
    git config --global alias.pr "pull --rebase"
    git config --global alias.lo "log --oneline -n 10"
    git config --global alias.a "add ."
    git config --global alias.cm "commit -m"
    git config --global alias.rh "reset --hard"
    git config --global alias.f "fetch"
    git config --global alias.up "upstream"
    git config --global alias.upstream "!git push -u origin HEAD"
    git config --global alias.wt "worktree"
    git config --global alias.gt "describe --abbrev=0"
}

git-config-user() {
    echo -n "
===================================
      * Git Configuration *
-----------------------------------
Please input Git Username: "

    read username

    echo -n "
-----------------------------------
Please input Git Email: "

    read email

    echo -n "
-----------------------------------
Done!
===================================
"

    git config --global user.name "${username}"
    git config --global user.email "${email}"
}

git-bk() {
  br=$(git symbolic-ref --short -q HEAD)
  git branch -c "$br" "backup/$br"
}

# Kills a process running on a specified tcp port
killport() {
  echo "Killing process on port: $1"
  fuser -n tcp -k $1;
}

# MVP
# Move and make parent directories
mvp() {
    source="$1"
    target="$2"
    target_dir=${target:h}
    mkdir --parents $target_dir; mv $source $target
}

find_folder_by_name() {
    local dir="$1"
    local name="$2"
    if (( $+commands[fd] )) &>/dev/null; then
        fd --color "never" -H -g --type d $name $dir
    else
        find $dir -type d -name $name
    fi
}

extract() {
    if [[ -f $1 ]]; then
        case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar e $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# update_ohmyzsh_custom_plugins() {
#     red=$(tput setaf 1)
#     blue=$(tput setaf 4)
#     green=$(tput setaf 2)
#     reset=$(tput sgr0)

#     echo ""
#     printf "${blue}%s${reset}\n" "Upgrading custom plugins"

#     find_folder_by_name "${ZSH_CUSTOM:-$ZSH/custom}" ".git" | while read LINE; do
#         p=${LINE:h}
#         pushd -q "${p}"

#         if git pull --rebase; then
#             printf "${green}%s${reset}\n" "${p:t} has been updated and/or is at the current version."
#         else
#             printf "${red}%s${reset}\n" "There was an error updating ${p:t}. Try again later?"
#         fi
#         popd -q
#     done
# }

gig() { curl -L -s https://www.gitignore.io/api/$@;}


# Lazyload Function

## Setup a mock function for lazyload
## Usage:
## 1. Define function "_sukka_lazyload_command_[command name]" that will init the command
## 2. sukka_lazyload_add_command [command name]
sukka_lazyload_add_command() {
    eval "$1() { \
        unfunction $1; \
        _sukka_lazyload_command_$1; \
        $1 \$@; \
    }"
}
## Setup autocompletion for lazyload
## Usage:
## 1. Define function "_sukka_lazyload_completion_[command name]" that will init the autocompletion
## 2. sukka_lazyload_add_comp [command name]
sukka_lazyload_add_completion() {
    local comp_name="_sukka_lazyload__compfunc_$1"
    eval "${comp_name}() { \
        compdef -d $1; \
        _sukka_lazyload_completion_$1; \
    }"
    compdef $comp_name $1
}

# Load zsh-async worker
# source ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-async/async.zsh
# async_init

## Lazyload thefuck
if (( $+commands[thefuck] )) &>/dev/null; then
    _sukka_lazyload_command_fuck() {
        eval $(thefuck --alias)
    }

    sukka_lazyload_add_command fuck
fi

## Lazyload pyenv
if (( $+commands[pyenv] )) &>/dev/null; then
    _sukka_lazyload_command_pyenv() {
        export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}" # pyenv init --path
        eval "$(command pyenv init -)"
    }
    sukka_lazyload_add_command pyenv

    _sukka_lazyload_completion_pyenv() {
        source "${__SUKKA_HOMEBREW_PYENV_PREFIX}/completions/pyenv.zsh"
    }
    sukka_lazyload_add_completion pyenv

    export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
fi

# hexo completion
if (( $+commands[hexo] )) &>/dev/null; then
    _hexo_completion() {
        compls=$(hexo --console-list)
        completions=(${=compls})
        compadd -- $completions
    }

    compdef _hexo_completion hexo
fi

# pnpm completion
if (( $+commands[pnpm] )) &>/dev/null; then
    _pnpm_completion() {
        local reply
        local si=$IFS

        IFS=$'\n'
        reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" pnpm completion -- "${words[@]}"))
        IFS=$si

        _describe 'values' reply
    }

    compdef _pnpm_completion pnpm
fi

# npm completion
if (( $+commands[npm] )) &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
fi



# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish


# flutter
# export PATH="$PATH:/Users/dcc/coding/flutter/bin"


# backup my config
backup_mac(){
    sh -c $HOME/dotfiles/backup.sh
#   sh -c $HOME/dotfiles/brew/backup.sh
}

recover_mac(){
  brew bundle --file="~/dotfiles/macos/$(whoami)/Brewfile"
#   sh -c $HOME/dotfiles/brew/brew_my_mac.sh
}
