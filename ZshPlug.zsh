###############################
#          ZSH Plug           #
#             By:             #
#        sherlock5512         #
#                             #
# Simple Naive plugin manager #
#    It does enough for me    #
###############################

#########################################################################
# ZshPlug - A simple naive plugin manager for zsh                       #
# Copyright © 2022 Robert Morrison                                      #
#                                                                       #
# This program is free software: you can redistribute it and/or modify  #
# it under the terms of the GNU General Public License as published by  #
# the Free Software Foundation, either version 3 of the License, or     #
# (at your option) any later version.                                   #
#                                                                       #
# This program is distributed in the hope that it will be useful,       #
# but WITHOUT ANY WARRANTY; without even the implied warranty of        #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
# GNU General Public License for more details.                          #
#                                                                       #
# You should have received a copy of the GNU General Public License     #
# along with this program.  If not, see <http://www.gnu.org/licenses/>. #
#########################################################################


## Complain if the user is not running zsh
## First test the $SHELL variable
if [[ "$SHELL" != "/bin/zsh" ]]; then
	printf "Your $SHELL variable is set to %s\n" $SHELL >&2
	printf "This is unexpected (Expected values "/bin/zsh")\n" >&2
	printf "If you are running zsh and your path is different open a GitHub issue\n" >&2
	printf "and let me know what Distro you're using and the path to zsh\n" >&2
	exit 1
fi
## Confirm running shell is actually zsh
runningShell="$(ps -p $$ c -o cmd | tail -n1)"
if [[ "$runningShell" != "zsh" ]]; then
	printf "Your $SHELL variable is set to %s\n" $SHELL >&2
	printf "This is correct However your running shell is %s\n" $runningShell >&2
	printf "This is unexpected (Expected values "zsh")\n" >&2
	printf "If zsh is named something different on your system open a GitHub issue\n" >&2
	printf "and let me know what Distro you are using and the name that zsh has\n"
	exit 1
fi


###########################
# Load User Configuration #
###########################

## Load custom Plugin directory
## Otherwise use default location
export pluginDir=${ZSH_PLUG_pluginDir:-$HOME/.local/share/zsh}

########################
# FUNCTION DEFINITIONS #
########################

export githubPrefix="https://github.com/"

ZSH_PLUG_pluginTest() {
## Test if a plugin is installed or not
## RETURNS
## 0: Plugin is installed
## 2: Plugin is not installed
## 4: Too many Arguments sent
## 5: No Arguments sent
	[ -z "$1" ] && return 5
	[ "$#" -gt "1" ] && return 4
	[ -d "$pluginDir/$1" ] && return 0
	return 1
}

ZSH_PLUG_pluginInstall() {
## Install Plugin to PluginDir
## Accepts 1 Argument (Plugin)
## CURRENTLY NO ERROR HANDLING
## ALSO DOES NOT HIDE OUTPUT
	[ $# -eq 0 ] && return 1
	local plugin="$1"
	local InstallDir="$pluginDir/$plugin"
	plugin="$githubPrefix$plugin"
	git clone "$plugin" "$InstallDir"
	chmod +X $InstallDir/*.zsh
	return
}

ZSH_PLUG_pluginLoad() {
## Source plugin 
## Accepts 1 Argument (Plugin)
## CURRENTLY NO ERROR HANDLING
## DOES NOT HIDE OUTPUT
## RELIES ON PLUGINS HAVING A DEFINED FORMAT
	[ $# -eq 0 ] && return 1
	local plugin="$1"
	local InstallDir="$pluginDir/$plugin"
	source $(find "$InstallDir" -name "*.plugin.zsh")
	return
}

ZSH_PLUG_pluginUpdate() {
## Update all Plugins
## Should really do one at a time
## Might not work with new config setup
	for Plugin in ${ZSH_PLUG_plugins[@]}; do
		echo "Updating $Plugin"
		local InstallDir="$pluginDir/$Plugin"
		pushd $InstallDir
		git pull 2> /dev/null
		popd
	done
	echo "Plugins Updated. Please restart zsh to use them"
}

Plug() {
	echo "Running ZshPlug"
	#Test for plugin directory and make if needed
	[ ! -d "$pluginDir" ] && { echo "Plugin directory doesn't exist making it now"; mkdir -p "$pluginDir"; }
	# test for git as needed to get plugins
	command -v git > /dev/null || { echo "Git is not installed" >&2 ; return 1; }

	## No need to check if plugins has content since if there are no plugins this does not run anythinh

	for Plugin in ${ZSH_PLUG_plugins[@]}; do
		echo "$Plugin"
		ZSH_PLUG_pluginTest "$Plugin"
		local exitcode="$?"
		case $exitcode in
			0)
				## plugin installed
				echo "Loading $Plugin"
				ZSH_PLUG_pluginLoad "$Plugin"
				;;
			1)
				## plugin not installed
				echo "Installing $Plugin"
				ZSH_PLUG_pluginInstall "$Plugin"
				echo "Loading $Plugin"
				ZSH_PLUG_pluginLoad "$Plugin"
				;;
			4)
				## Too many args to pluginTest
				echo "Something is wrong here..." >&2
				echo "Too many args to pluginTest" >&2
				break
				;;
			5)
				## No args to pluginTest
				echo "Something is wrong here..." >&2
				echo "No args to pluginTest" >&2
				break
				;;
			*)
				echo "Something is really wrong..." >&2
				echo "Exit Code Was $exitcode" >&2
				echo "Maybe you should start an issue"
				break
				;;
		esac
	done
}

Plug

## Clean up non-required variables and functions

unset -f Plug
unset -f ZSH_PLUG_pluginInstall
unset -f ZSH_PLUG_pluginTest
unset -f ZSH_PLUG_pluginLoad
unset githubPrefix

































