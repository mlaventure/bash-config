#!/bin/bash

ls=ls

case "$(uname -s)" in
	Darwin)
		ls='gls'
		;;
	Linux)
		# copy from cli to clipboard
		alias pbcopy="xclip -selection clipboard"
		alias pbpaste="xclip -selection clipboard -o"
		alias gnome-control-center='XDG_CURRENT_DESKTOP="GNOME" gnome-control-center'
		;;
	*)
		;;
esac

alias ls="$ls --color=auto -N"
alias l='ls -l'
alias la='l -a'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias fgrep='egrep --color=auto'

alias enw='emacsclient -c -a emacs -nw'
alias rg="rg --no-ignore"

if command -v bat > /dev/null; then
    alias bat='bat --style changes,numbers --theme 1337'
    alias cat='bat'
fi

#
# Function
#

e() {
	emacsclient -c -a emacs "$@" > /dev/null &
	disown
}

em() {
	emacs "$@" 2> /dev/null &
	disown
}

pdftojpg() {
	convert -density 300 -quality 100 "$@"
}

dind() {
	src=${1:-~/go/src/github.com/docker/docker}
	tag=${2:-master}
	docker run --rm --privileged -ti -v $(readlink -f $src):/go/src/github.com/docker/docker -v /var/lib/docker docker-dev:$tag bash
}

for a in $(ls ~/.bash_aliases_* 2>/dev/null)
do
	source $a
done
