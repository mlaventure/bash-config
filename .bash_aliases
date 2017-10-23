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
		;;
	*)
		;;
esac

alias ls="$ls --color=auto"
alias l='ls -l'
alias la='l -a'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias fgrep='egrep --color=auto'

#
# Function
#


e() {
	emacsclient -c -a emacs $@ > /dev/null &
	disown
}

em() {
	emacs $@ 2> /dev/null &
	disown
}

pdftojpg() {
	convert -density 300 -quality 100 $@
}
