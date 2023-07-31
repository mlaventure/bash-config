# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#
# HISTORY
#

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# save 100000 lines both in meomry and on disk
HISTSIZE=100000
HISTFILESIZE=100000
HISTTIMEFORMAT="%h %d %H:%M:%S "

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
    xterm* | rxvt*)
        PS1="\[\e]0;\u@\h: \w\a\]$PS1"
        ;;
    *) ;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# add .local/bin to PATH (used by local python package installed via `pip
# install --user <package>`)
export PATH="${HOME}/.local/bin:${PATH}"

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

#
# SSH-Agent
#
SSH_ENV="$HOME/.ssh/agent-environment"

start_agent() {
    echo "Initialising new SSH agent..."
    ssh-agent | sed 's/^echo/#echo/' >"${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" >/dev/null
    /usr/bin/ssh-add || true
}

# Source SSH settings, if applicable

# if [ -f "${SSH_ENV}" ]; then
#     . "${SSH_ENV}" >/dev/null
#     #ps ${SSH_AGENT_PID} doesn't work under cywgin
#     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ >/dev/null || {
#         start_agent
#     }
# else
#     start_agent
# fi

# custom compleion scripts
. ${HOME}/.bash_completion.d/* 2>/dev/null

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

# work

if [ -f ~/.bash_work ]; then
    . ~/.bash_work
fi

# FZF : https://github.com/junegunn/fzf
if [ -f ~/.fzf.bash ]; then
    . ~/.fzf.bash
    # Some options
    export FZF_COMPLETION_TRIGGER='*'
    # allow previwing long command lines, hidden by default
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
    if command -v bat >/dev/null; then
        export FZF_COMPLETION_OPTS="--preview '[ -f {} ] && bat --color always {}' --preview-window 50%:wrap --bind '?:toggle-preview'"
    fi

    if command -v fd >/dev/null; then
        # Use fd (https://github.com/sharkdp/fd) instead of the default find
        # command for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
            fd --hidden --follow --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude ".git" . "$1"
        }
    fi
fi

#
# vterm support
#
function vterm_printf() {
    if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    function clear() {
        vterm_printf "51;Evterm-clear-scrollback"
        tput clear
    }
fi

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
PS1="$PS1'\[$(vterm_prompt_end)\]'"

#
# Direnv (must come last)
#
if command -v direnv >/dev/null; then
    eval "$(direnv hook bash)"
fi
