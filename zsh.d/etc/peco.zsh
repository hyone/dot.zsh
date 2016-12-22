function peco-file() {
  local selected=$(/bin/ls | peco)
  _peco-insert-command-line $selected
}
zle -N peco-file

function peco-git-files() {
  # check whether the current directory is under `git` repository.
  if git rev-parse 2&> /dev/null; then
    local selected=$(git ls-files . | peco)
    _peco-insert-command-line $selected
  else
    echo 'current directory is not under git repository';
    return 1
  fi
}
zle -N peco-git-files

function peco-ssh () {
  local selected_host=$(awk '
  tolower($1)=="host" {
    for (i=2; i<=NF; i++) {
      if ($i !~ "[*?]") {
        print $i
      }
    }
  }
  ' ~/.ssh/config | sort | peco --query "$LBUFFER")
  if [ -n "$selected_host" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ssh

function peco-git-branch() {
    local selected=$(git branch -a --sort=-authordate | peco | tr -d ' ' | tr -d '*')
    _peco-insert-command-line $selected
}
zle -N peco-git-branch

function peco-git-commit() {
    local selected=$(git log --oneline --decorate=full | peco | awk '{print $1}')
    _peco-insert-command-line $selected
}
zle -N peco-git-commit

function peco-history() {
  local tac="tail - r"
  if which tac > /dev/null; then
    tac="tac"
  elif which gtac > /dev/null; then
    tac="gtac"
  fi
  local selected=$(fc -l -n 1 | eval $tac | peco)
  _peco-insert-command-line $selected
}
zle -N peco-history

## find a repository by ghq and go to its directory
function peco-repository() {
  local selected=$(ghq list -p | peco --prompt "REPOSITORY >" --query "$LBUFFER")
  if [ -n "$selected" ]; then
    BUFFER="cd ${selected}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-repository


function _peco-insert-command-line {
  local selected=$1

  if [ -n "$selected" ]; then
    if [ -n "$LBUFFER" ]; then
      local NEW_LBUFFER="${LBUFFER%\ } $selected"
    else
      local NEW_LBUFFER="$selected"
    fi
    BUFFER=${NEW_LBUFFER}${RBUFFER}
    CURSOR=${#NEW_LBUFFER}
  fi
}
