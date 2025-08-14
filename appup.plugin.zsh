source _docker.zsh
source _vagrant.zsh

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
