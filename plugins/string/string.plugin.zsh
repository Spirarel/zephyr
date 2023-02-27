#!/bin/zsh

##? string - manipulate strings
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

##? string-escape - escape special characters
function string-escape {
  (( $# )) || return 1
  local s
  for s in "$@"; do
    echo ${s:q}
  done
}

##? string-join - join strings with delimiter
function string-join {
  (( $# )) || return 1
  local sep=$1; shift
  echo ${(pj.$sep.)@}
}

##? string-join0 - join strings with null character
function string-join0 {
  (( $# )) || return 1
  string-join $'\0' "$@" ""
}

##? string-length - print string lengths
function string-length {
  (( $# )) || return 1
  local s
  for s in "$@"; do
    echo $#s
  done
}

##? string-lower - convert strings to lowercase
function string-lower {
  (( $# )) || return 1
  local s; for s in "$@"; echo ${s:l}
}

##? string-pad - pad strings to a fixed width
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

##? string-repeat - multiply a string
function string-repeat {
  (( $# )) || return 1
  local s n; local -A opts
  zparseopts -D -A opts -- n: m: N
  n=${opts[-n]:-$opts[-m]}
  for s in "$@"; do
    if [[ -v opts[-m] ]]; then
      s=$(printf "$s%.0s" {1..$n})
      printf ${s:0:$opts[-m]}
    else
      printf "$s%.0s" {1..$n}
    fi
    [[ -v opts[-N] ]] || printf '\n'
  done
}

##? string-unescape - expand escape sequences
function string-unescape {
  (( $# )) || return 1
  local s
  for s in "$@"; do
    echo ${s:Q}
  done
}

##? string-split - split strings by delimiter
function string-split {
  (( $# )) || return 1
  local s sep=$1; shift
  for s in "$@"; printf '%s\n' "${(@ps.$sep.)s}"
}

##? string-split0 - split strings by null character
function string-split0 {
  string-split $'\0' "$@"
}

##? string-sub - extract substrings
function string-sub {
  local s; local -A opts
  zparseopts -D -A opts -- s: l:
  for s in "$@"; do
    echo ${s:${opts[-s]:-0}:${opts[-l]:-$#s}}
  done
}

##? string-trim -  remove trailing whitespace
function string-trim {
  (( $# )) || return 1
  for s in "$@"; echo $s | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

##? string-upper - convert strings to uppercase
function string-upper {
  (( $# )) || return 1
  local s; for s in "$@"; echo ${s:u}
}
