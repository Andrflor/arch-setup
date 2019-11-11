# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/kensai/.oh-my-zsh"
export PATH=/home/kensai/.cargo/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"
# 10ms for key sequences
KEYTIMEOUT=1


# Aliases
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -all'
alias cp='cp -i'
alias df='df -h'
alias grepi='grep -i'
alias diff='diff --color=auto'
alias trash='gio trash'
alias ssh='TERM=xterm ssh'
alias fehbg='feh --bg-fill "$(xsel -b)"'
alias lss='systemctl list-units -t service'
alias USB1='echo /run/media/$USER/$(ls /run/media/$USER/)/'
alias rsyncHome='Rsync $HOME/ "$(USB1)" "/.*" /Qemu/ /Desktop/Synology/ /Windows/ --.git/'
alias xdual='xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --output HDMI2 --mode 1920x1080 --pos 1920x0'
alias restart='reboot'
alias del='sudo pacman -Rs'
alias search='history | grep'
alias vol='pactl -- set-sink-volume 0'
alias myip='ip addr | grep wlp |grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1'
alias exip='curl -s https://api.my-ip.io/ip | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"'
alias pulse='qtile-run -f ~/Hygia/build-app-Desktop-Debug/app'
alias tax="tar xf"
alias ygg="python ~/ygg.py"

cdd() { cd "$1" && ls -all; }

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

rpi() {
        case $1 in
            build)    ~/Hygia/booting/scripts/build.sh $2;;
            install)  ~/Hygia/booting/scripts/install.sh $2;;
            qt)       ~/Hygia/booting/qt/build.sh $2;;
            ssh)      ssh pi@10.42.0.35;;
        esac
}

fail() { journalctl "$@" | egrep -i "warn|error|fail"; }

diffDirs() { diff -r -q {$1,$2} -x "$3" -x "$4" -x "$5" -x "$6"; }

xmirror() {
    RES=$(xrandr | sed -nr "s/$1 connected ([0-9]+x[0-9]+).*/\1/p")
     [ -z $RES ] && RES=$(xrandr | sed -nr "s/$1 connected primary ([0-9]+x[0-9]+).*/\1/p")
    xrandr --output $1 --auto --primary --preferred --output $2 --auto --same-as $1 --scale-from $RES
}

update() {
    if grep -q "lts" /boot/loader/loader.conf; then
        sudo pacman -Syyu --ignore linux,linux-headers,linux-api-headers
    else
        sudo pacman -Syyu --ignore linux-lts,linux-lts-headers
    fi
}

bkup() {
    cp $1 arch-setup/config/home/$1
}

ssa() {
  eval $(ssh-agent)
  ssh-add
}

sr () {
   waterfox --new-window duckduckgo.com/$1 && exit
}

extract () {
    if [ -f $1 ] ; then
        [ -z $2 ] && dir="." || dir=$2
        case $1 in
            *.tar.bz2)   tar xjf $1 -C $dir ;;
            *.tar.gz)    tar xzf $1 -C $dir ;;
            *.tbz2)      tar xjf $1-C  $dir ;;
            *.tgz)       tar xzf $1 -C $dir ;;
            *.tar)       tar xf $1 -C $dir ;;
            *.bz2)       bzcat $1 > $dir/"${1%.*}" ;;
            *.gz)        zcat $1 > $dir/"${1%.*}" ;;
            *.rar)       unrar e $1 $dir ;;
            *.zip)       unzip $1 -d $dir ;;
            *.7z)        7z x $1 -o$dir ;;
            *.Z)         uncompress -c $1 > $dir/"${1%.*}" ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
    echo "'$1' is not a valid file"
    fi
}

wgex () {
    wget $1 -P $2
    extract "$2$(basename "$1")" $2
    trash "$2$(basename "$1")"
}

push() { 
    git add -A
    git commit -m "$1"
    git push
}

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
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
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"# Aliases

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    vi-mode
    sudo
    )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
