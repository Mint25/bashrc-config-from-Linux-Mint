# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ═══════════════════════════════════════════════════════════════════
# 🚀 WARP-INSPIRED TERMINAL CONFIGURATION
# ═══════════════════════════════════════════════════════════════════

# Enhanced colors for terminal
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Beautiful Warp-like prompt with git integration
function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Dynamic directory icon function
function get_dir_icon() {
    local current_dir="$(basename "$PWD")"
    local full_path="$PWD"
    
    # Check for specific directory patterns
    case "$current_dir" in
        "$USER"|"home") echo "🏠" ;;
        "Desktop") echo "🖥️" ;;
        "Documents") echo "📄" ;;
        "Downloads") echo "⬇️" ;;
        "Pictures"|"Images"|"photos") echo "🖼️" ;;
        "Music"|"Audio") echo "🎵" ;;
        "Videos"|"Movies") echo "🎬" ;;
        "Projects"|"project"*) echo "🚀" ;;
        "src"|"source") echo "💻" ;;
        "bin") echo "⚙️" ;;
        "lib"|"library") echo "📚" ;;
        "config"|"conf"|"cfg") echo "⚙️" ;;
        "tmp"|"temp") echo "🗑️" ;;
        "log"|"logs") echo "📝" ;;
        "backup"|"bak") echo "💾" ;;
        "test"|"tests") echo "🧪" ;;
        "node_modules") echo "📦" ;;
        ".git") echo "🔧" ;;
        *) 
            # Check if it's a git repository
            if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
                echo "📂"
            # Check full path patterns
            elif [[ "$full_path" == "/"* ]]; then
                case "$full_path" in
                    "/") echo "🌐" ;;
                    "/usr"*) echo "⚙️" ;;
                    "/var"*) echo "📊" ;;
                    "/etc"*) echo "⚙️" ;;
                    "/opt"*) echo "📦" ;;
                    *) echo "📁" ;;
                esac
            else
                echo "📁"
            fi
            ;;
    esac
}

# Warp-style prompt with beautiful colors, dynamic icons, and git info
PS1='\[\033[36m\]┌─[\[\033[1;35m\]👤 \u\[\033[36m\]@\[\033[1;34m\]🖥️  \h\[\033[36m\]]\[\033[1;33m\] $(get_dir_icon) \w\n\[\033[36m\]└─\[\033[1;32m\]⚡\$\[\033[0m\] '
PS1+='\[\033[31m\]$(parse_git_branch)\[\033[0m\] '

# Enhanced ls colors
export LS_COLORS='di=1;94:ln=1;96:so=1;95:pi=1;93:ex=1;92:bd=1;93:cd=1;93:su=1;91:sg=1;91:tw=1;94:ow=1;94:fi=0;97'

# Modern aliases for better user experience
alias ls='ls --color=always --group-directories-first'
alias ll='ls -alF --color=always --group-directories-first'
alias la='ls -A --color=always --group-directories-first'
alias lh='ls -lah --color=always'

# Warp-like productivity aliases
alias clear='clear && echo -e "\033[1;36m📁 $(pwd)\033[0m"'
alias ..='cd .. && echo -e "\033[1;34m⬆️  $(pwd)\033[0m"'
alias ...='cd ../.. && echo -e "\033[1;34m⬆️  $(pwd)\033[0m"'

# Enhanced functions with icons
function mkcd() {
    mkdir -p "$1" && cd "$1" && echo -e "\033[32m✅ Created and entered: 📁 $1\033[0m"
}

function weather() {
    echo -e "\033[1;36m🌤️  Weather for ${1:-your location}:\033[0m"
    curl -s "wttr.in/${1:-}?format=3"
}

function sysinfo() {
    echo -e "\033[1;35m💻 System Information\033[0m"
    echo -e "\033[1;32m👤 User: \033[0m$(whoami)"
    echo -e "\033[1;34m🖥️  Host: \033[0m$(hostname)"
    echo -e "\033[1;33m📅 Date: \033[0m$(date)"
    echo -e "\033[1;36m📁 PWD:  \033[0m$(pwd)"
    echo -e "\033[1;91m🔥 Uptime: \033[0m$(uptime -p)"
}


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
