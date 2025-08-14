#region Docker
COMPOSER_FILES=('compose.yaml' 'compose.yml' 'docker-compose.yaml' 'docker-compose.yml')

_appup_docker () {
    if hash docker >/dev/null 2>&1 -neq 0; then
        echo >&2 "Docker compose file found but docker compose is not installed."
        return 1
    fi

    # Check if docker has been started
    if zstyle -t ':omz:plugins:appup:docker' check-started; then
        if hash docker-machine >/dev/null 2>&1 && zstyle -t ':omz:plugins:appup:docker' docker-machine; then
            if docker-machine status | grep -qi "Stopped"; then
                read -r -k 1 "REPLY?Docker Machine is not running, would you like to start it? [y/N] "
                echo ""

                if [[ "${REPLY:l}" != "y" ]]; then
                    return 0
                fi

                docker-machine start default && eval $(docker-machine env default)
                echo ""
            fi
        elif docker ps 2>&1 | grep -qi "Is the docker daemon running?"; then
            if [[ "${OSTYPE:l}" != "darwin"* ]]; then
                echo "Docker is not running."
                return 1
            fi

            read -r -k 1 "REPLY?Docker for Mac is not running, would you like to start it? [y/N] "
            echo ""

            if [[ "${REPLY:l}" != "y" ]]; then
                return 0
            fi

            open -a Docker

            echo ""
            echo "Waiting for docker to start.."
            echo ""

            # Wait for it to start
            while true; do
                if docker ps 2>&1 | grep -qi "Is the docker daemon running?" || docker ps 2>&1 | grep -qi "connection refused"; then
                    sleep 5
                else
                    break
                fi
            done
        fi
    fi

    # Env files
    env_files=()

    if [[ "$1" == "up" ]]; then
        zstyle -a ':omz:plugins:appup:docker' env-files opt_env_files

        for f in $opt_env_files; do
            if [ -e "$f" ]; then
                env_files+=( "$f" )
            fi
        done
    fi

    # Run docker compose.
    docker compose --env-file=$^env_files $1 "${@:2}"
}

_appup_docker_file_found() {
    for f in "${COMPOSER_FILES[@]}"; do
        if [ -e "$f" ]; then
            return 0
        fi
    done

    return 1
}
#endregion

#region Vagrant
_appup_vagrant () {
    if hash vagrant >/dev/null 2>&1; then
        vagrant $1 "${@:2}"
    else
        echo >&2 "Vagrant file found but vagrant is not installed."
    fi
}
#endregion

up () {
    if _appup_docker_file_found; then
        _appup_docker up "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant up "$@"
    elif hash up >/dev/null 2>&1; then
        env up "$@"
    else
        exit 255
    fi
}

down () {
    if _appup_docker_file_found; then
        _appup_docker down "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant destroy "$@"
    elif hash down >/dev/null 2>&1; then
        env down "$@"
    else
        exit 255
    fi
}

start () {
    if _appup_docker_file_found; then
        _appup_docker start "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant up "$@"
    elif hash start >/dev/null 2>&1; then
        env start "$@"
    else
        exit 255
    fi
}

restart () {
    if _appup_docker_file_found; then
        _appup_docker restart "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant reload "$@"
    elif hash start >/dev/null 2>&1; then
        env start "$@"
    else
        exit 255
    fi
}

stop () {
    if _appup_docker_file_found; then
        _appup_docker stop "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant halt "$@"
    elif hash stop >/dev/null 2>&1; then
        env stop "$@"
    else
        exit 255
    fi
}

enter () {
    if [ $# -gt 0 ] && _appup_docker_file_found; then
        CMD=( "${@:2}" )

        if [ $# -eq 1 ]; then
            CMD=( /bin/bash -l )
        fi

        _appup_docker exec "$1" $CMD
    elif hash enter >/dev/null 2>&1; then
        env enter "$@"
    else
        exit 255
    fi
}
