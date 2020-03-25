#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
gurl - version: 2020.03
updated: 2020-03-25 by budRich
EOB
}


# environment variables
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${MATCHERS_DIR:=$HOME/.config/gurl}"


___printhelp(){
  
cat << 'EOB' >&2
gurl - simple plumbing framework


SYNOPSIS
--------
gurl [--matchers-dir|-d DIR] URL [ARG...]
gurl --help|-h
gurl --version|-v

OPTIONS
-------

--matchers-dir|-d URL  

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
    --options "d:hv" \
    --longoptions "matchers-dir:,help,version," \
    -- "$@" || exit 77
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --matchers-dir | -d ) __o[matchers-dir]="${2:-}" ; shift ;;
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 





