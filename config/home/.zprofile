#
# ~/.bash_profile
#

export VISUAL=vim
export EDITOR=vim
export TERMINAL=urxvt
export MONITOR1=eDP1
export MONITOR2=HDMI1
export BROWSER=firefox
export PATH=/home/kensai/.cargo/bin:$PATH

if [[ "$(tty)" == '/dev/tty1' ]]; then
    startx
fi
