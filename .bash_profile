#!/bin/bash

if [ -f ~/.bashrc ]
then
	source ~/.bashrc
fi

if command -v gpg-agent
then
	eval $(gpg-agent --daemon)
fi

#xinput set-prop 'Logitech Performance MX' "Evdev Scrolling Distance" 2 1 1
