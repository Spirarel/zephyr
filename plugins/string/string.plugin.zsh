#!/bin/zsh
function string {
  if [[ -p /dev/stdin ]]; then
    if (( $# > 0 )); then
      set -- "$@" "${(@f)$(cat)}"
    else
      set -- "${(@f)$(cat)}"
    fi
  fi

  local cmd=$1
  if [[ $# -eq 0 ]]; then
    echo >&2 "string: Expected a subcommand to follow the command"
    return 2
  elif (( $+functions[string-$cmd] )); then
    string-$cmd "$@[2,-1]"
  else
    echo >&2 "string: Subcommand '$cmd' is not valid"
    return 2
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
  local s=0 e=-1 l=
  local -a o_start o_end o_len

  zparseopts -D -M --     \
    s:=o_start -start:=s  \
    e:=o_end   -end:=e    \
    l:=o_len   -length:=l ||
    return 1

  if (( $#o_start )); then
    s=$o_start[-1]
    [[ "$s" -eq "$s" ]] || return 1

  fi

}

# function string-pad {
#   local s w c
#   local -a o_char o_width o_right
#   zparseopts -D -M    -- \
#     r=o_right  -right=r  \
#     c:=o_char  -char:=c  \
#     w:=o_width -width:=w ||
#     return 1
#   (( $#o_char )) && c=$o_char[-1] || c=' '
#   if (( $#o_width )); then
#     w=$o_width[-1]
#   else
#     for s in "$@"
#       [[ $#s -gt $w ]] && w=$#s
#   fi
#   for s in "$@"; do
#     if (( $#o_right )); then
#       echo ${(r($w)(${c}))s}
#     else
#       echo ${(l($w)(${c}))s}
#     fi
#   done
#   echo "char: $c"
# }
