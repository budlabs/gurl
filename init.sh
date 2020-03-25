#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
gurl - version: 2020.03
updated: 2020-03-25 by budRich
EOB
}


# environment variables
: "${XDG_CONFIG_HOME:=$HOME/.config}"


___printhelp(){
  
cat << 'EOB' >&2
gurl - SHORT DESCRIPTION


SYNOPSIS
--------
gurl --help|-h
gurl --version|-v

OPTIONS
-------

--help|-h  
Show help and exit.


--version|-v  
Show version and exit.
EOB
}


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

declare -A __o
options="$(
  getopt --name "[ERROR]:gurl" \
    --options "hv" \
    --longoptions "help,version," \
    -- "$@" || exit 77
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 





