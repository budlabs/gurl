#!/usr/bin/env bash

main(){

  [[ -z ${url:=$1} ]] && ERX no url

  dir=${__o[matchers-dir]:-$MATCHERS_DIR}
  
  [[ -z $dir ]] && ERX "MATCHERS_DIR not specified"
  [[ -d $dir ]] || createconf "$dir"

  printf '%s\n' "$@" > "$dir/.last"

  mapfile -t files < <(find "$dir" -name match)

  ((${#files[@]} > 0)) && trg=$(awk -v url="$url" '
    /^[^#]/ {
      if (match(url,gensub(/^.+:\s+/,"",1,$0))) {
        dir = gensub(/[^/]+$/,"",1,FILENAME)
        print gensub(/^([^:]+).+/,dir "\\1",1,$1)
        exit
      }
    }
  ' "${files[@]}")

  [[ -x ${trg:=$dir/default} ]] \
    || ERX "$trg is not executable"

  PATH=${trg%/*}:$dir/_lib:$PATH exec "$trg" "$@"
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "${@}"                                     #bashbud
