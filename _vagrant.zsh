_appup_vagrant () {
    if hash vagrant >/dev/null 2>&1; then
        vagrant $1 "${@:2}"
    else
        echo >&2 "Vagrant file found but vagrant is not installed."
    fi
}
