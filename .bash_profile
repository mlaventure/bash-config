#!/bin/bash

if [ -f ~/.bashrc ]
then
	source ~/.bashrc
fi

if command -v gpg-agent > /dev/null
then
	eval $(gpg-agent --daemon 2> /dev/null)
fi

#xinput set-prop 'Logitech Performance MX' "Evdev Scrolling Distance" 2 1 1
