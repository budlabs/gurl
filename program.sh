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


main(){

  [[ -z ${_url:=$1} ]] && ERX no url

  _dir=${__o[matchers-dir]:-$MATCHERS_DIR}
  
  if [[ -z $dir ]]; then
    ERX "MATCERS_DIR not specified"
  elif [[ ! -d $_dir ]]; then
    createconfig "$_dir"
  fi

  [[ -d $_dir/_lib ]] && newpath="$_dir/_lib:$PATH"

  printf '%s\n' "$@" > "$_dir/.last"

  mapfile -t files < <(find "$_dir" -name match)
  target=$(awk -v url "$_url" '
    /^[^#]/ && {
      t=$1 $1=""
      if (url ~ $0) {
        dir = gensub(/[^/]+$/,"",1,FILENAME)
        print dir gensub(/:$/,"",1,t)
        exit
      }
  ' "${files[@]}")

  echo "$target"
  # (( ${#matchfiles[@]} > 0 )) && mapfile -t matchlist < <(
  #   awk '/^[^#]/ { print gensub(/[^/]+$/,"",1,FILENAME) $0 }' \
  #   "${matchfiles[@]}")

  # for e in "${matchlist[@]}"; do
  #   re=${e#*: } trg=${e%%: *}
  #   [[ $_url =~ ${re} ]] && {
  #     [[ -x $trg ]] || ERX "$trg is not executable"
  #     PATH="${trg%/*}:${newpath:-$PATH}" exec "$trg" "$@"
  #   }
  # done

  # [[ -x $_dir/default ]] \
  #   && PATH="${newpath:-$PATH}" exec "$_dir/default" "$@"
}

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


set -E
trap '[ "$?" -ne 77 ] || exit 77' ERR

ERM(){

  local mode

  getopts xr mode
  case "$mode" in
    x ) urg=critical ; prefix='[ERROR]: '   ;;
    r ) urg=low      ; prefix='[WARNING]: ' ;;
    * ) urg=normal   ; mode=m ;;
  esac
  shift $((OPTIND-1))

  msg="${prefix}$*"

  if [[ -t 2 ]]; then
    echo "$msg" >&2
  else
    notify-send -u "$urg" "$msg"
  fi

  [[ $mode = x ]] && exit 77
}

ERX() { ERM -x "$*" ;}
ERR() { ERM -r "$*" ;}
ERH(){
  {
    ___printhelp 
    [[ -n "$*" ]] && printf '\n%s\n' "$*"
  } >&2 
  exit 77
}

__=""
__stdin=""

read -N1 -t0.01 __  && {
  (( $? <= 128 ))  && {
    IFS= read -rd '' __stdin
    __stdin="$__$__stdin"
  }
}

YNP() {

  local sp key default opts status

  default=y
  opts=yn

  [[ $1 =~ -([${opts}]) ]] \
    && default="${BASH_REMATCH[1]}" && shift

  sp="$* [${default^^}/${opts/$default/}]"

  if [[ -t 2 ]]; then
    >&2 echo "$sp"

    while :; do
      read -rsn 1

      key="${REPLY:-$default}"
      [[ $key =~ [${opts}] ]] || continue
      break
    done
  else
    key="$default"
  fi

  [[ ${key,,} = n ]] && status=1

  return "${status:-0}"
}

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


main "${@:-}"


