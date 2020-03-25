#!/usr/bin/env bash

main(){

  while getopts :d: _ ; do _dir=${OPTARG}; done
  shift $((OPTIND-1))

  [[ -z ${_url:=$1} ]] && ERX no url

  [[ -d ${_dir:=$MATCHERS_DIR} ]] || {
    _source=$(readlink -f "${BASH_SOURCE[0]}")
    _dir=${_source%/*}/matchers
    [[ -d $_dir ]] || ERX MATCHERS_DIR: "$_dir" not found
  }

  [[ -d $_dir/_lib ]] && newpath="$_dir/_lib:$PATH"

  printf '%s\n' "$@" > "$_dir/.last"

  mapfile -t matchfiles < <(
    find "$_dir" -mindepth 1 -type f -name match)

  (( ${#matchfiles[@]} > 0 )) && mapfile -t matchlist < <(
    awk '/^[^#]/ { print gensub(/[^/]+$/,"",1,FILENAME) $0 }' \
    "${matchfiles[@]}")

  for e in "${matchlist[@]}"; do
    re=${e#*: } trg=${e%%: *}
    [[ $_url =~ ${re} ]] && {
      [[ -x $trg ]] || ERX "$trg is not executable"
      PATH="${trg%/*}:${newpath:-$PATH}" exec "$trg" "$@"
    }
  done

  [[ -x $_dir/default ]] \
    && PATH="${newpath:-$PATH}" exec "$_dir/default" "$@"
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "${@}"                                     #bashbud
