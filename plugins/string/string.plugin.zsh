#!/bin/zsh
function string {
  if [[ ! -t 0 ]] && [[ -p /dev/stdin ]]; then
    if (( $# )); then
      set -- "$@" "${(@f)$(cat)}"
    else
      set -- "${(@f)$(cat)}"
    fi
  fi

  if (( $+functions[string-$1] )); then
    string-$1 "$@[2,-1]"
  else
    echo >&2 "string: Subcommand '$1' is not valid." && return 1
  fi
}

function string-escape {
  (( $# )) || return 1
  local s; for s in "$@"; echo ${s:q}
}

function string-unescape {
  (( $# )) || return 1
  local s; for s in "$@"; echo ${s:Q}
}

function string-length {
  (( $# )) || return 1
  local s; for s in "$@"; echo $#s
}

function string-lower {
  (( $# )) || return 1
  local s; for s in "$@"; echo ${s:l}
}

function string-upper {
  (( $# )) || return 1
  local s; for s in "$@"; echo ${s:u}
}

function string-join {
  (( $# )) || return 1
  local sep=$1; shift
  echo ${(pj.$sep.)@}
}

function string-join0 {
  string-join $'\0' "$@"
}

function string-split {
  (( $# )) || return 1
  local s sep=$1; shift
  for s in "$@"; printf '%s\n' "${(@ps.$sep.)s}"
}

function string-split0 {
  string-split $'\0' "$@"
}

function string-trim {
  (( $# )) || return 1
  for s in "$@"; echo $s | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

function string-sub {
  local s; local -A opts
  zparseopts -D -A opts -- s: l:
  for s in "$@"; do
    echo ${s:${opts[-s]:-0}:${opts[-l]:-$#s}}
  done
}

function string-pad {
  local s d pad; local -A opts=(-c ' ' -w 0)
  zparseopts -D -K -A opts -- c: w: r
  for s in "$@"; [[ $#s -gt $opts[-w] ]] && opts[-w]=$#s
  for s in "$@"; do
    [[ -v opts[-r] ]] && d=r || d=l
    pad="$d:$opts[-w]::$opts[-c]:"
    eval "echo \"\${($pad)s}\""
  done
}
