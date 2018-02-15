#
# Bash completion definition for imgp.
#
# Author:
#   Arun Prakash Jana <engineerarun@gmail.com>
#

_imgp () {
    COMPREPLY=()
    local IFS=$' \n'
    local cur=$2 prev=$3
    local -a opts opts_with_args
    opts=(
        -a --adapt
        -c --convert
        -d --dot
        -e --eraseexif
        -f --force
        -h --help
        -i --includeimgp
        -k --keep
        -m --mute
        -n --enlarge
        --nn
        -o --rotate
        -p --optimize
        -q --quality
        -r --recurse
        -s --size
        -w --overwrite
        -x --res
        -z --debug
    )
    opts_with_arg=(
        -o --rotate
        -q --quality
        -s --size
        -x --res
    )

    # Do not complete non option names
    [[ $cur == -* ]] || return 1

    # Do not complete when the previous arg is an option expecting an argument
    for opt in "${opts_with_arg[@]}"; do
        [[ $opt == $prev ]] && return 1
    done

    # Complete option names
    COMPREPLY=( $(compgen -W "${opts[*]}" -- "$cur") )
    return 0
}

complete -F _imgp imgp
