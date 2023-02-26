# zsh strings

Fish has a utility for [string maniplulation][string].

This is how you can do the same things with Zsh builtins.

References:
- [Zsh regex][3]
- [String modifiers][1]
- [String expansion][2]

Setup:
```zsh
$ source $PWD/plugins/string/string.plugin.zsh
$
```

## Length

Get the length of a string with `#`.
This is similar to `string length` in [fish][length].

```zsh
$ str="abcdefghijklmnopqrstuvwxyz"
$ echo ${#str}
26
$
```

Or, you can use Zephyr's `string length` convenience function to do the same thing:
```zsh
$ string length '' a ab abc
0
1
2
3
$
```

## Pad/Trim

Left pad a string with the [l expansion flag][2].
Right pad a string with the [r expansion flag][2].
This is similar to `string pad` in [fish][pad].

```zsh
$ str="abc"
$ echo ${(l(10)(-))str}
-------abc
$ echo ${(r(10)(ABC))str}
abcABCABCA
$
```

The docs can be confusing. They show the syntax as `l:expr::string1::string2:`, which
uses colons instead of the more readable parens. Don't be confused by the double colon,
which is really just the closing/opening combo `)(`. If you choose to follow the docs,
the syntax looks like this:

```zsh
$ str="abc"
$ echo ${(r:10::-:)str}
abc-------
$
```

Trim requires the use of `sed`. This is similar to `string trim` in [fish][trim].

```zsh
$ str="   \t\t\t   abc   \t\t\t   "
$ echo "$str" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
abc
$
```

Trimming strings other than whitespace can be accomplished with the '#' and '%' [parameter expansions][4].

`#` removes at the start of the string. `#` is the shortest match, and `##` is the longest.

```zsh
$ str="a/b/c/d/e/f/g"
$ echo ${str#*/}
b/c/d/e/f/g
$ echo ${str##*/}
g
$
```

`%` removes at the end of the string. `%` is the shortest match, and `%%` is the longest.

```zsh
$ str="a/b/c/d/e/f/g"
$ echo ${str%/*}
a/b/c/d/e/f
$ echo ${str%%/*}
a
$
```

Or, you can use Zephyr's `string trim` convenience function to do the same thing:

```zsh
$ tab=$'\t'
$ string trim "  ${tab}${tab}  ${tab} a b c${tab}   "
a b c
$
```

## Substring

Get a substing from string with comma indexing `[start,end]`. With this method, indexing starts at 1.
This is similar to `string sub` in [fish][sub].

```zsh
$ str="abcdefghijklmnopqrstuvwxyz"
$ echo ${str[3,6]}
cdef
$
```

You can also use the `${var:offset:length}` syntax. With this method, indexing starts at 0.

```zsh
$ str="abcdefghijklmnopqrstuvwxyz"
$ echo ${str:3:6}
defghi
$ echo ${str:(-4)}
wxyz
$
```

## Repeat

Repeat a string by using `printf`.
This is similar to `string repeat` in [fish][repeat].

```zsh
$ str="abc"
$ abc3=$(printf "$str%.0s" {1..3})
$ echo $abc3
abcabcabc
$
```

## Escape/Unescape

Escape (quote) strings with the [q modifier][1].
This is similar to `string escape` in [fish][escape].

```zsh
$ str="3 tabs \t\t\t."
$ echo "${str:q}"
3\ tabs\ \t\t\t.
$
```

Unescape (unquote) strings with the [Q modifier][1].
This is similar to `string unescape` in [fish][unescape].

```zsh
$ str="3 backticks \`\`\`."
$ esc="${str:q}"
$ echo $esc
3\ backticks\ \`\`\`.
$ echo "${esc:Q}"
3 backticks ```.
$
```

You can quote strings using `q`, `qq`, `qqq`, `qqqq`, as well as `-` and `+` symbols. Each results in different quoting output. They mean:

- `q`: Quote characters that are special to the shell with backslashes
- `qq`: Quote with results in 'single' quotes
- `qqq`: Quote with results in "double" quotes
- `qqq`: Quote with results in $'dollar' quotes
- `q-`: Minimal quoting only where required
- `q+`: Extended minimal quoting using $'dollar'

```zsh
$ strip() { sed -r 's/\x1B\[(;?[0-9]{1,3})+[mGK]//g' }
$ normal="\e[0;0m"
$ blue="\e[0;34m"
$ str="${blue}this is blue${normal}"
$ echo ${(q-)str} | strip
'this is blue'
$ echo ${(q+)str} | strip
'this is blue'
$ echo ${(q)str}
\e\[0\;34mthis\ is\ blue\e\[0\;0m
$ echo ${(qq)str} | strip
'this is blue'
$ echo ${(qqq)str}
"\e[0;34mthis is blue\e[0;0m"
$ echo ${(qqqq)str}
$'\e[0;34mthis is blue\e[0;0m'
$
```

Or, you can use Zephyr's `string escape` and `string unescape` convenience functions to do the same thing:
```zsh
$ excited_man='\\o/'
$ echo $excited_man
\o/
$ string escape $excited_man
\\o/
$ esc_man='\\\\o/'
$ echo $esc_man
\\o/
$ string unescape $esc_man
\o/
$
```

## Join/Split

Join strings with the [j expansion flag][2].
This is similar to `string join` in [fish][join].

```zsh
$ words=(abc def ghi)
$ sep=:
$ echo ${(pj.$sep.)words}
abc:def:ghi
$
```

A common join seperator is the null character.
This is similar to `string join0` in [fish][join0].

```zsh
$ words=(abc def ghi)
$ nul=$'\0'
$ echo ${(pj.$nul.)words} | tr '\0' '0'
abc0def0ghi
$
```

Or, you can use Zephyr's `string join` and `string join0 `convenience functions to do the same thing:

```zsh
$ string join '/' a b c
a/b/c
$ string join0 x y z | tr '\0' '0'
x0y0z
$
```

Split strings with the [s expansion flag][2].
This is similar to `string split` in [fish][split].

- `@`: Preserves empty elements. _"In double quotes, array elements are put into separate words"_.
- `p`: Use print syntax. _"Recognize the same escape sequences as the print."_
- `s`: Split. _"Force field splitting at the separator string."_

```zsh
$ str="a:b::c"
$ sep=:
$ printf '%s\n' "${(@ps.$sep.)str}"
a
b

c
$
```

A common split seperator is the null character.
This is similar to `string split0` in [fish][split0].

```zsh
$ nul=$'\0'
$ str="abc${nul}def${nul}ghi"
$ arr=(${(ps.$nul.)str})
$ printf '%s\n' $arr
abc
def
ghi
$
```

Or, you can use Zephyr's `string split` and `string split0 `convenience functions to do the same thing:

```zsh
$ string split '/' 'a/b/c' 'x//z'
a
b
c
x

z
$ nul=$'\0'
$ string split0 "x${nul}y${nul}z"
x
y
z
$
```

## Upper/Lower

Convert a string to uppercase with the [u modifier][1].
This is similar to `string upper` in [fish][upper].

```zsh
$ str="AbCdEfGhIjKlMnOpQrStUvWxYz"
$ echo "${str:u}"
ABCDEFGHIJKLMNOPQRSTUVWXYZ
$
```

Or, you can use Zephyr's `string upper` convenience function to do the same thing:

```zsh
$ string upper $str
ABCDEFGHIJKLMNOPQRSTUVWXYZ
$
```

Convert a string to lowercase with the [l modifier][1].
This is similar to `string lower` in [fish][lower].

```zsh
$ str="AbCdEfGhIjKlMnOpQrStUvWxYz"
$ echo "${str:l}"
abcdefghijklmnopqrstuvwxyz
$
```

Or, you can use Zephyr's `string lower` convenience function to do the same thing:

```zsh
$ string lower $str
abcdefghijklmnopqrstuvwxyz
$
```

## Match/Replace

The `zsh/pcre` module allows you to match strings in Zsh.

```zsh
$ zmodload zsh/pcre
$ str="The following are zip codes: 78884 90210 99513"
$ setopt REMATCH_PCRE
$ [[ $str =~ '\d{5}' ]] && echo "contains zips" || echo "no zips"
contains zips
$
```

```zsh
$ zmodload zsh/pcre
$ str="https://gist.github.com/mattmc3/110eca74a876154c842423471b8e5cbb"
$ pattern='^(ftp|https?)://'
$ pcre_compile -smx $pattern
$ pcre_match -b -- $str
$ [[ $? -eq 0 ]] && echo "match: $MATCH, position: $ZPCRE_OP" || echo "no match"
match: https://, position: 0 8
$
```

Replacing leverages the [s modifier][1]. 'g' Means globally.

```zsh
$ url=https://github.com/zsh-users/zsh-autosuggestions.git
$ url=${url%.git}
$ url=${url:gs/\@/-AT-}
$ url=${url:gs/\:/-COLON-}
$ url=${url:gs/\//-SLASH-}
$ echo $url
https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-autosuggestions
$
```

## Collect

There are lots of different ways strings need collected. Sometimes you have a string with embedded newlines that you need to split into an array, preserving blanks.

```zsh
$ str=$(printf '%s\n' four score '' "&" '' seven years ago)
$ echo ${(q-)str}
'four
score

&

seven
years
ago'
$ # remove blanks
$ arr=(${(f@)str})
$ echo $#arr
6
$ # preserve blanks
$ arr=("${(f@)str}")
$ echo $#arr
8
$
```

## Tests

This file passes [clitests][clitest]:

```zsh
zsh -f -- =clitest --list-run --progress dot --color always ./**/zsh-strings.md
```

### Additional clitests

```zsh
$ string foo #=> --exit 1
$ string foo
string: Subcommand 'foo' is not valid.
$
```


[1]: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Modifiers
[2]: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion-Flags
[3]: https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fpcre-Module
[4]: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion
[collect]: https://fishshell.com/docs/current/cmds/string-collect.html
[escape]: https://fishshell.com/docs/current/cmds/string-escape.html
[join]: https://fishshell.com/docs/current/cmds/string-join.html
[join0]: https://fishshell.com/docs/current/cmds/string-join0.html
[length]: https://fishshell.com/docs/current/cmds/string-length.html
[lower]: https://fishshell.com/docs/current/cmds/string-lower.html
[match]: https://fishshell.com/docs/current/cmds/string-match.html
[pad]: https://fishshell.com/docs/current/cmds/string-pad.html
[repeat]: https://fishshell.com/docs/current/cmds/string-repeat.html
[replace]: https://fishshell.com/docs/current/cmds/string-replace.html
[split]: https://fishshell.com/docs/current/cmds/string-split.html
[split0]: https://fishshell.com/docs/current/cmds/string-split0.html
[string]: https://fishshell.com/docs/current/cmds/string.html
[sub]: https://fishshell.com/docs/current/cmds/string-sub.html
[trim]: https://fishshell.com/docs/current/cmds/string-trim.html
[unescape]: https://fishshell.com/docs/current/cmds/string-unescape.html
[upper]: https://fishshell.com/docs/current/cmds/string-upper.html
[clitest]: https://github.com/aureliojargas/clitest
