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

brew-fix() {
    sudo chown -R $(whoami) /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig
    chmod u+w /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig
}

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