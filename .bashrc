# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Put your fun stuff here.

PS1='\[\033[1m\]\h\[\033[0m\]: \W \$ '

export PATH="/home/xrchen/bin":$PATH

export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=200000
shopt -s checkwinsize


[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh

alias ls='ls --color'
alias ll='ls -l'
alias emacs='emacs -nw'
