# directories and files
function cd-up {
  echo
  cd ..
  zle reset-prompt
}
zle -N cd-up

function ll-files {
  echo
  ls -lF --color=auto
  zle reset-prompt
}
zle -N ll-files

# etcetra

#   move to before period of filename ext
function move-to-before-file-ext() {
  zle vi-backward-word
  for i in {1..2}
  do
      zle backward-char
  done
}
zle -N move-to-before-file-ext

#   quote the previous word with single or double quote.
autoload -U modify-current-argument

function quote-previous-word-in-single() {
  modify-current-argument '${(qq)${(Q)ARG}}'
  zle vi-forward-blank-word
}
zle -N quote-previous-word-in-single

function quote-previous-word-in-double() {
  modify-current-argument '${(qqq)${(Q)ARG}}'
  zle vi-forward-blank-word
}
zle -N quote-previous-word-in-double

# copy and paste with OS clipboard

function clipboard-copy() {
  if [[ "$(uname)" == "Linux" ]]; then
    print -rn $CUTBUFFER | xclip -i -selection clipboard
  elif [[ "$(uname)" == "Darwin" ]]; then
    print -rn $CUTBUFFER | pbcopy
  fi
}

function clipboard-paste() {
  if [[ "$(uname)" == "Linux" ]]; then
    CUTBUFFER=$(xclip -o -selection clipboard)
  elif [[ "$(uname)" == "Darwin" ]] ; then
    CUTBUFFER=$(pbpaste)
  fi
}

function x-copy-region-as-kill() {
  zle copy-region-as-kill
  REGION_ACTIVE=0
  clipboard-copy
}
zle -N x-copy-region-as-kill

function x-kill-region() {
  zle kill-region
  clipboard-copy
}
zle -N x-kill-region

function x-put() {
  clipboard-paste
  zle put
}
zle -N x-put

function x-vi-yank() {
  zle vi-yank
  clipboard-copy
}
zle -N x-vi-yank

function x-vi-delete() {
  zle vi-delete
  clipboard-copy
}
zle -N x-vi-delete

function x-vi-put-before() {
  clipboard-paste
  zle vi-put-before
}
zle -N x-vi-put-before

function x-vi-put-after() {
  clipboard-paste
  zle vi-put-after
}
zle -N x-vi-put-after


# ===============================================================================
# Git   {{{1
# ===============================================================================

function git-status {
  echo
  command git status
  repeat-echo 2
  zle reset-prompt
}
zle -N git-status

function git-branch {
  echo
  git branch --color --verbose
  repeat-echo 2
  zle reset-prompt
}
zle -N git-branch

function git-shortlog {
  echo
  git ll
  repeat-echo 3
  zle reset-prompt
}
zle -N git-shortlog
