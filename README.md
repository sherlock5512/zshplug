# ZshPlug

A simple and naive plugin manager for zsh

Does what I want and that's probably enough

## How it works

Basically it takes an array of plugins.
Then if they are already installed they are loaded.
Otherwise the plugin is installed to a known location
It's a simple system and it works for me.

I'm happy to hear about any improvements that people might have.

### Limitations

Currently ZshPlug can only load plugins from github.
And only accepts the format `GITHUB_USER/GITHUB_REPO`
Anything else is likely to cause issues.

## Configuration

There are two environment variables you can use to configure how ZshPlug works

Firstly `$ZSH_PLUG_pluginDir` this is the directory you want your plugins
installed to

Secondly `$ZSH_PLUG_plugins` this is a "bash style" array of the plugins
you want installed.
As an example you could have `$ZSH_PLUG_plugins=("zsh-users/zsh-autosuggestions" "zdharma/fast-syntax-highlighting")`

You must also add the configuration for any plugins before you source
ZshPlug

## How to use

Place `ZshPlug.zsh` into a known location.

edit your `zshrc` and add in your configuration for ZshPlug
then add a line at the end that sources ZshPlug.

The next time you start your shell it should fire up automatically

### Updating Plugins

To update your installed plugins you just need to run
`ZSH_PLUG_pluginUpdate`
And ZshPlug will pull the latest versions for you.

You will need to restart your shell for any changes to take effect
