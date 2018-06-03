# Set up a basic profile that isn't too fancy.

#
# Prompt stuff
#

# Even though Termux supports >16 colors, it isn't guaranteed
# that the user is actually using Termux.
if [ "${TERM}" != "dumb" ] && [ "$(tput colors)" -ge 16 ]; then
	# Note: Color codes need to be wrapped with \001 and \002 or
	# it breaks wrapping!
	RED='\001\033[31m\002'
	GREEN='\001\033[32m\002'
	BLUE='\001\033[34m\002'
	MAGENTA='\001\033[35m\002'
	RESET='\001\033[0m\002'
fi

# Replace $HOME with ~ and the parent of the prefix with termux_root
# to make paths shorter.
prompt_pwd() {
	local homedir="${PWD/${HOME}/\~}"
	local termux_root="$(realpath "${PREFIX}/..")"
	printf "%b" "${BLUE}${homedir/${termux_root}/termux_root}${RESET}"
}

# Print the username prettily.
show_username() {
	# show user@hostname in magenta if we are not localhost
	if [ "$(hostname -s)" != "localhost" ]; then
		printf "%b" "${MAGENTA}$(id -un)@$(hostname -s)${RESET}"
	# show root in red if we are root
	elif [ "$(id -u)" = "0" ]; then
		printf "%b" "${RED}root${RESET}"
	# Otherwise, show termux in green.
	else
		printf "%b" "${GREEN}termux${RESET}"
	fi
}

# Actually set the prompt.
# [termux ~/.termux] $
PS1='[$(show_username) $(prompt_pwd)] \$ '

# aliases
alias ls='ls --color=auto --group-directories-first'
alias l='ls -1'
alias ll='ls -l'
alias llh='ls -lh'
alias sl='ls'

# Unless the user chooses otherwise, disable nano
# hard-wrapping. It is almost never useful.
if [ ! -f "@TERMUX_PREFIX@/etc/nanorc" ] && [ ! -f "@TERMUX_HOME@/.nanorc" ]; then
	alias nano='nano -w'
fi

# Will either be busybox vi or vim.
if [ -z "${EDITOR}" ]; then
	export EDITOR="vi"
fi

alias edit='${EDITOR}'
alias e='${EDITOR}'

# Allow the user to always run Busybox applets by prefixing
# them with 'bb'.
alias bb='busybox'
while IFS= read applet; do
	alias bb${applet}="busybox ${applet}"
done < <(busybox --list)

# Enable a few helpful options.
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s histappend
shopt -s nocaseglob
shopt -s nocasematch
shopt -s histreedit
shopt -s cmdhis

# Set up the command not found handler.
command_not_found_handle() {
	@TERMUX_PREFIX@/libexec/termux/command-not-found "$1"
}
