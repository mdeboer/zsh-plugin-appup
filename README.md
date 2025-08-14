# AppUp

> The command that can save you typing 15 characters or more, each time!

[![CircleCI](https://circleci.com/gh/Cloudstek/zsh-plugin-appup.svg?style=svg)](https://circleci.com/gh/Cloudstek/zsh-plugin-appup)

This plugins adds `start`, `restart`, `stop`, `up` and `down` commands when it detects a docker-compose or Vagrant file
in the current directory (e.g. your application). Just run `up` and get coding! This saves you typing `docker-compose`
or `vagrant` every time or aliasing them. Also gives you one set of commands that work for both environments.

### Vagrant

Vagrant doesn't have a `down`, `restart`, `start` or `stop` commands natively but don't worry, that's been taken care of
and running those commands will actually run vagrant's equivalent commands. Additional arguments will be directly
supplied to vagrant.

### Command mapping

| Command | Vagrant command                                            | Docker command                                                |
|---------|------------------------------------------------------------|---------------------------------------------------------------|
| up      | [up](https://www.vagrantup.com/docs/cli/up.html)           | [up](https://docs.docker.com/compose/reference/up/)           |
| down    | [destroy](https://www.vagrantup.com/docs/cli/destroy.html) | [down](https://docs.docker.com/compose/reference/down/)       |
| start   | [up](https://www.vagrantup.com/docs/cli/up.html)           | [start](https://docs.docker.com/compose/reference/start/)     |
| restart | [reload](https://www.vagrantup.com/docs/cli/reload.html)   | [restart](https://docs.docker.com/compose/reference/restart/) |
| stop    | [halt](https://www.vagrantup.com/docs/cli/halt.html)       | [stop](https://docs.docker.com/compose/reference/stop/)       |

#### Enter command

There is one extra command that doesn't map to either Vagrant or Docker natively. Currently it is only implemented for
Docker and allows you to quickly open a shell in a container.

```shell
enter my-container          # Spawns /bin/bash -l in my-container
enter my-container /bin/sh  # Spawns /bin/sh in my-container (useful for Alpine based images) 
```

## Installation

### oh-my-zsh

1. Clone this repository to `$ZSH_CUSTOM/plugins/appup`.
2. Edit your `.zshrc` and add `appup` to the list of plugins.

### Antidote

```shell
antidote install mdeboer/zsh-plugin-appup
```

### Antigen

```shell
antigen bundle mdeboer/zsh-plugin-appup
```

### ZI

```shell
zi load mdeboer/zsh-plugin-appup
```

### Plain ZSH

1. Clone this repository somewhere
2. Edit your `.zshrc` and `source` the `appup.plugin.zsh` somewhere:

## Configuration options

This plugin has a few configuration options to customise its behaviour. Please make sure you define these in your
`.zshrc` file *before* you load any plugins.

For more information about `zstyle`, see the man page `zshmodules(1)`.

| Option                                       | Values | Default | Description                                                                                                                                   |
|----------------------------------------------|--------|---------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| `':omz:plugins:appup:docker' check-started`  | yes/no | no      | Enable/disable checking if docker is running.                                                                                                 |
| `':omz:plugins:appup:docker' docker-machine` | yes/no | no      | If both docker (e.g. Docker Desktop) and docker-machine are installed, check if docker-machine (when `yes`) or docker (when `no`) is running. |
| `':omz:plugins:appup:docker' env-files`      | array  |         | Additional env files to load (if they exist) when running `up` (adds `--env-file=...` arguments to the docker compose command).               | 

### Example

```shell
zstyle ':omz:plugins:appup:docker' check-started yes
zstyle ':omz:plugins:appup:docker' docker-machine no
zstyle ':omz:plugins:appup:docker' env-files .env.foo .env.bar # Will also load .env.foo and/or .env.bar if they exist.

# Load the plugin here...
```
