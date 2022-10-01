# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
# export PATH=/usr/local/bin:$PATH
# export PATH=/opt/homebrew/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# This speed up zsh-autosuggetions by a lot
export ZSH_AUTOSUGGEST_USE_ASYNC='true'

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    # osx
    zsh-autosuggestions
    # git
    # zsh-syntax-highlighting
    # fast-syntax-highlighting
    F-Sy-H
    zsh-gitcd
    # zsh-completion will be added to FPATH directly
    # zsh-completions
    zsh-z
    # zsh-interactive-cd
    fzf-tab
)

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

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

alias rezsh="omz reload"
if (( $+commands[code] )); then
    alias zshconfig="code $HOME/.zshrc"
elif (( $+commands[we] )); then
    alias zshconfig="we $HOME/.zshrc"
else
    alias zshconfig="nano $HOME/.zshrc"
fi

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# alias npm="echo -e '\033[31mERROR: 非必要请勿执行 run 指令！\033[0m'"

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

hash -d desktop="$HOME/Desktop"
hash -d music="$HOME/Music"
hash -d pictures="$HOME/Pictures"
hash -d picture="$HOME/Pictures"
hash -d downloads="$HOME/Downloads"
hash -d download="$HOME/Downloads"
hash -d documents="$HOME/Documents"
hash -d document="$HOME/Documents"
hash -d dropbox="$HOME/Dropbox"
hash -d services="$HOME/Services"
hash -d projects="$HOME/Project"
hash -d project="$HOME/Project"
hash -d tools="$HOME/Tools"
hash -d tool="$HOME/Tools"
hash -d applications="/Applications"
hash -d application="/Applications"
hash -d surge="$HOME/Library/Application Support/Surge/Profiles"
hash -d smartdns="$HOME/.config/smartdns"

alias finder_show="defaults write com.apple.finder AppleShowAllFiles YES"
alias finder_hide="defaults write com.apple.finder AppleShowAllFiles NO"
clear_finder_icon_cache() {
    green=$(tput setaf 2)
    reset=$(tput sgr0)
    printf "${green}%s${reset}\n" '- Cleaning "/Library/Caches/com.apple.iconservices.store" folder ...'
    sudo rm -rfv /Library/Caches/com.apple.iconservices.store
    printf "${green}%s${reset}\n" '- Cleaning "com.apple.dock.iconcache" and "com.apple.dock.iconcache" files ...'
    sudo find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rfv {} \;
    sleep 1
    sudo touch /Applications/*
    printf "${green}%s${reset}\n" '- Restarting Dock & Finder ...'
    killall Dock
    killall Finder
    sleep 2
    printf "${green}%s${reset}\n" '- Done!'
}

clear_dns_cache() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    sudo killall mDNSResponderHelper
}

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


brew-fix() {
    sudo chown -R $(whoami) /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig
    chmod u+w /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig
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

update_ohmyzsh_custom_plugins() {
    red=$(tput setaf 1)
    blue=$(tput setaf 4)
    green=$(tput setaf 2)
    reset=$(tput sgr0)

    echo ""
    printf "${blue}%s${reset}\n" "Upgrading custom plugins"

    find_folder_by_name "${ZSH_CUSTOM:-$ZSH/custom}" ".git" | while read LINE; do
        p=${LINE:h}
        pushd -q "${p}"

        if git pull --rebase; then
            printf "${green}%s${reset}\n" "${p:t} has been updated and/or is at the current version."
        else
            printf "${red}%s${reset}\n" "There was an error updating ${p:t}. Try again later?"
        fi
        popd -q
    done
}

gig() { curl -L -s https://www.gitignore.io/api/$@;}

# eval "__sukka_original_$(which omz)"
# unfunction omz

# omz() {
#     if [[ $1 == update ]]; then
#         __sukka_original_omz update
#         update_ohmyzsh_custom_plugins
#     else
#         __sukka_original_omz $@
#     fi
# }

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

# Add OSX-like shadow to image
# USAGE: osx-shadow [--rm|-r] <original.png> [result.png]
osx-shadow() {
    # Help message
    function help {
        echo "Wrong number of arguments have been entered."
        echo "USAGE: osx-shadow [--rm|-r] <original.png> [result.png]"
    }

    if [[ $1 == --rm || $1 == -r ]]; then
        # Remove shadow
        case $# in
            3) # osx-shadow --rm|-r src.png dist.png
                convert $2 -crop +50+34 -crop -50-66 $3
                ;;
            2) # osx-shadow --rm|-r src.png
                convert $2 -crop +50+34 -crop -50-66 ${2%.*}-croped.png
                ;;
            *)
                help
                ;;
        esac
    else
        # Add shadow
        case $# in
            2) # osx-shadow src.png dist.png
                convert $1 \( +clone -background gray -shadow 100x40+0+16 \) +swap -background none -layers merge +repage $2
                ;;
            1) # osx-shadow src.png
                convert $1 \( +clone -background gray -shadow 100x40+0+16 \) +swap -background none -layers merge +repage ${1%.*}-shadow.png
                ;;
            *)
                help
                ;;
        esac
    fi
}

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


# autojump j
# [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# flutter
# export PATH="$PATH:/Users/dcc/coding/flutter/bin"

# bk() {
#     cp ~/.zshrc ~/dotfiles/macos/zshrc
#     # brew bundle dump --describe --force --no-upgrade --file="~/dotfiles/macos/Brewfile"
#     # sh -c $HOME/dotfiles/brew/backup.sh
#     sh -c $HOME/dotfiles/backup.sh
#     # code --list-extensions > ~/dotfiles/_rc/exts.txt
# }

# backup my config
backup_mac(){
    sh -c $HOME/dotfiles/backup.sh
#   sh -c $HOME/dotfiles/brew/backup.sh
}

recover_mac(){
  brew bundle --file="~/dotfiles/macos/$(whoami)/Brewfile"
#   sh -c $HOME/dotfiles/brew/brew_my_mac.sh
}