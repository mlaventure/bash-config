# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


#
# HISTORY
#

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# save 1000 lines both in meomry and on disk
HISTSIZE=1000
HISTFILESIZE=1000
# append to the history file, don't overwrite it
shopt -s histappend


#
# Terminal
#

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


#
# Completion
#
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# custom compleion scripts
. ${HOME}/.bash_completion.d/* 2> /dev/null

#
# Environment
#
if [ -f ~/.bash_env ]; then
    . ~/.bash_env
fi


#
# Aliases
#
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


#
# Prompt
#
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

#
# Direnv (must come last)
#
if command -v direnv > /dev/null
then
	eval "$(direnv hook bash)"
fi
