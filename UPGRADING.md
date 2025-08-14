# Upgrading

## 1.4.x - 2.0.x

### Repository URL

The repository moved from https://github.com/Cloudstek/zsh-plugin-appup to https://github.com/mdeboer/zsh-plugin-appup.
The owner has not changed, still me.

### Projects (Docker)

There is no longer any support for "projects" where for example `up foo` would look to see if `docker-compose.foo.yml`
exists and would call `docker compose -f docker-compose.yml -f docker-compose.foo.yml up ...`.

The implementation was fragile and a pain to maintain. Composer itself now has plenty of (better) options to manage
scenarios like this and it is often better to supply the arguments themselves if needed.

### Configuration options

The configuration options have changed from environment variables to using `zstyle` (see the `zshmodules` man page).

| Old                  | New                                          | Notes                                                   |
|----------------------|----------------------------------------------|---------------------------------------------------------|
| APPUP_CHECK_STARTED  | `':omz:plugins:appup:docker' check-started`  |                                                         |
| APPUP_DOCKER_MACHINE | `':omz:plugins:appup:docker' docker-machine` |                                                         |
| APPUP_LOAD_ENVS      | `':omz:plugins:appup:docker' env-files`      | Please see the [README](README.md), minor changes here. |
