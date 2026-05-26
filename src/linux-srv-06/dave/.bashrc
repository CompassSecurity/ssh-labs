#
# ~/.bashrc
#

# Shell must be interactive
[ -z "$PS1" ] && return

# Options
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=1000
shopt -s histappend
shopt -s checkwinsize

# Prompt
if tput setaf 1 >&/dev/null; then
    font_bold="\[$(tput bold)\]"
    color_red="\[$(tput setaf 1)\]"
    color_green="\[$(tput setaf 2)\]"
    color_blue="\[$(tput setaf 4)\]"
    color_reset="\[$(tput sgr0)\]"

    if [[ "$UID" == "0" ]]
    then
      color_user="$color_red"
    else
      color_user="$color_green"
    fi

    PS1="\n${font_bold}${color_user}\u@\h${color_reset}${font_bold}:${color_blue}\w${color_reset}\\$ "
else
    PS1='\n\u@\h:\w\n\$ '
fi

# Set terminal title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
