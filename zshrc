# ===============================================================================
# zshrc
# @author hyone (http://github.com/hyone)
# ===============================================================================
#   {{{1

ZSH_DIR=~/.zsh.d
ZSH_BUNDLE_DIR=${ZSH_DIR}/bundle
ZSH_CONFIGURATIONS_DIR=${ZSH_DIR}/etc
ZSH_FUNCTIONS_DIR=${ZSH_DIR}/functions

FPATH="${ZSH_FUNCTIONS_DIR}:$FPATH"


# ===============================================================================
# Antigen    {{{1
# ===============================================================================

source ${ZSH_BUNDLE_DIR}/antigen/antigen.zsh

antigen bundles <<EOBUNDLES
  osx
  # hchbaw/auto-fu.zsh
  # zsh-users/zsh-history-substring-search.git
  zsh-users/zsh-syntax-highlighting
EOBUNDLES

#   need before load cdd
autoload -U compinit;   compinit -u
antigen bundle hyone/cdd
#   For development
# antigen bundle ~/work/cdd


# ===============================================================================
# Options   {{{1
# ===============================================================================

#   avoid to be irretated
setopt nobeep

#   disable C-s, C-q
setopt no_flow_control

#   -- glob
setopt extended_glob
#   if filename includes number, output by sorting asc by number. ( not work on ls )
setopt numeric_glob_sort

#   not to redirect the existing files.
setopt noclobber
#   enable to move a directory only with typing path (i.e. without prefixed 'cd')
setopt autocd
#   allow a variable that is set to the abosolute path of directory 
#   can immdediately become a name for that directory.
#   e.g. mypath='/path/to/hoge' and then cd ~mypath become equivalent to cd '/path/to/hoge'
setopt auto_name_dirs
#   If the argument to a cd command is  not a directory, and does not begin with a slash,
#   try to expand the expression as if it were preceded by a '~'
setopt cdable_vars


#   -- pushd
#   make behavior of cd like pushed
setopt autopushd
#   allow to move last directory by like cd ~-1 ( i.e. swap cd ~+1 and cd ~-1 )
setopt pushdminus
#   stop displaying directory stack every time pushed
setopt pushdsilent
#   guess pushd with no argument as move home directory
#   ( defualt behavior is swap directory stack )
setopt pushdtohome
#   don't push same directory as that of being already in the directory stack
setopt pushd_ignore_dups

#   -- history
#   remove older item when history all already same item.
setopt hist_ignore_all_dups
#   remove command from the history list when the first character on the line is a space.
setopt hist_ignore_space
#   strip unnecessary spaces on commandline
setopt hist_reduce_blanks
#   share command history with all zsh shell process
setopt share_history
#   works  like  APPEND_HISTORY  except  that new history lines are added to the
#   $HISTFILE incrementally (as soon as they are entered)
setopt inc_append_history
# setopt append_history
#   append date to log in history file
setopt extended_history

#   -- completion
setopt completeinword
unsetopt listambiguous
#   disable typing a completion key to select the first candidate
#   when there are more than one candidate.
unsetopt menu_complete
#   # ( Is this a wrong explanation? not work like what I intended )
#   #   expand aliases before completion
# setopt complete_aliases

#   automatically display list choices when completion is an ambiguous.
setopt auto_list

#   enable a behavior like below
#   $HO => type <TAB> => $HOME/ => type ':' => $HOME:
#   ( '/' is automatically removed )
setopt auto_param_keys

#   display filetypes like 'ls -F'
setopt list_types
#   if a parameter is completed whose content is the name of a directory,
#   then add a trailing slash instead of a space.
setopt auto_param_slash

setopt list_packed
#   rotate candidates by typing a completion key when more than one candiate.
setopt auto_menu
#   correct word spelling
setopt correct
# #   correct word spelling including all arguments
# setopt correctall

#   something like magic to allow to specify color
setopt prompt_subst

#   avoid to scroll out prompt when completion
setopt always_last_prompt


# ===============================================================================
# Completion    {{{1
# ===============================================================================

zstyle ':completion:*' menu select
zstyle ':completion:*' format '%F{yellow}[%d]%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _expand _prefix _match _approximate _list _history
zstyle ':completion:*' verbose yes
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

#   cache completion
zstyle ':completion::complete:*' use-cache true
zstyle :compinstall filename "$HOME/.zshrc"

# autoload -U compinit;   compinit -u
autoload -U promptinit; promptinit # prompt gentoo
autoload -U colors;     colors


#   colorize candidates of completion like 'ls'
export ZLS_COLORS=${LS_COLORS}
# zstyle ':completion:*' list-colors di=34 fi=0
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#   enable completion when using sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin


# #   display predictive typing by using history search
# autoload -U predict-on
# predict-on
# #   display a message when turn on or off predictive typing
# zstyle ':predict' verbose true


# ===============================================================================
# History   {{{1
# ===============================================================================

HISTFILE=$HOME/etc/local/zsh-history
HISTSIZE=100000
SAVEHIST=100000

#   Direcotory move
DIRSTACKSIZE=50

#   separator between words
WORDCHARS='*?_-[]~&;!#$%^(){}<>'
# WORDCHARS='*?_-[]~=&;!#$%^(){}<>'


# ===============================================================================
# Keybind   {{{1
# ===============================================================================
# reference: http://www.cs.elte.hu/zsh-manual/zsh_14.html

# keybindings that can be mapped to something
# "^[j", "^[m"

#   to enable <C-s> <C-q> on terminal
stty stop undef     # <C-s>
stty start undef    # <C-q>

bindkey -e
# bindkey -v

#   default emacs bindings but can use vi normal mode by Ctrl-]
bindkey '^]' vi-cmd-mode
#   By default, there is a 0.4 second delay, which cause time lag when moving between modes
#   so, make shorter to 0.1 seconds.
export KEYTIMEOUT=10

#   move cursor
bindkey '^B'    backward-char
bindkey '^F'    forward-char
bindkey '^H'    backward-delete-char
bindkey '^K'    kill-line
bindkey '^U'    backward-kill-line
bindkey '^A'    beginning-of-line
bindkey '^E'    end-of-line

bindkey '^[b'   backward-word
bindkey '^[f'   forward-word

#   Read a character from the keyboard, and move to the next (previous) occurrence of it in the line. 
bindkey '^L'    vi-find-next-char
bindkey '^[l'   vi-find-prev-char

#   search history by partly match
bindkey '^P'    history-beginning-search-backward
bindkey '^N'    history-beginning-search-forward

#   use increamental-pattern-search
bindkey '^R'    history-incremental-pattern-search-backward
bindkey '^S'    history-incremental-pattern-search-forward

#   map <S-Tab> and <C-o> to select a completion candidate in reverse order.
bindkey '\e[Z'  reverse-menu-complete
bindkey '^O'    reverse-menu-complete

#   copy and paste
#   paste: <C-y>
bindkey '^@'    set-mark-command       # <C-Space>
bindkey '^[w'   copy-region-as-kill


#   Prefix: C-X   {{{2
# ==================================================

#   toggle predictive typing
# zle -N predict-on
# zle -N predict-off
# bindkey '^XP'   predict-on
# bindkey '^X^P'  predict-off

bindkey '^X^_' zce

bindkey '^Xb' peco-git-branch
bindkey '^Xc' peco-git-commit
bindkey '^Xf' peco-file
bindkey '^Xp' peco-git-files
bindkey '^Xq' peco-repository
bindkey '^Xr' peco-history
#   "^Xs" is originally bound to 'history-incremental-search-forward'
bindkey '^Xs' peco-ssh


#   Prefix: C-Q   {{{2
# ==================================================

bindkey -r  '^Q'
bindkey -s  '^Qq'       "~/"
bindkey -s  '^Q^Q'      "~/"
bindkey -s  '^Qd'       " --diff "
bindkey -s  '^Q^D'      " --diff "
bindkey -s  '^Qh'       " --help"
bindkey -s  '^Q^H'      " --help"
bindkey -s  '^Ql'       " --list "
bindkey -s  '^Q^L'      " --list "
bindkey -s  '^Qs'       " --stat "
bindkey -s  '^Q^S'      " --stat "
bindkey -s  '^Qv'       " --version"
bindkey -s  '^Q^V'      " --version"


#   Prefix: Esc (meta key)   {{{2
# ==================================================

#   show candidates list that is matched shell meta charaters such as wildcard
bindkey    '^[e'   list-expand
#   hotkey to move a specified directory
bindkey -s '^[i'   "cd -\t"
bindkey    '^[j'   git-status
bindkey    '^[m'   git-branch
bindkey    '^[n'   git-shortlog
# bindkey    '^[l'   ll-files
bindkey    '^[k'   move-to-before-file-ext
#   argument completion from history
bindkey -s '^[o'   "!??:%^B^B^B"
bindkey    '^[p'   cd-up
#   undo, redo
bindkey    '^[u'   undo
bindkey    '^[r'   redo
bindkey    '^[s'   quote-previous-word-in-single
# bindkey    '^[w'   quote-previous-word-in-double
bindkey    '^[w'   quote-previous-word-in-double

#   map <Esc-:> to complete the last argument of the previouse command
autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
#   specify characters zsh guesses as a part of words.
# zstyle :insert-last-word match '*([^[:space]][[:alpha]/\\\\]|[[:alpha:]/\\\\][^[:space:]])*'']]]]]]]])'
bindkey    '^[:'   insert-last-word

#   vi normal mode  {{{2
# ==================================================

# with clipboard
bindkey -M vicmd '^Y'  x-vi-yank
bindkey -M vicmd '^Y'  x-vi-yank
bindkey -M vicmd '^D'  x-vi-delete
bindkey -M vicmd '^K'  x-vi-put-after
bindkey -M vicmd '^[p' x-vi-put-before

bindkey -M vicmd 'q'   push-line-or-edit
bindkey -M vicmd 'z'   zce


# ===============================================================================
# Prompt    {{{1
# ===============================================================================

# special character that is able to use
#   %n            user name
#   %a            "logged on" or "logged off"
#   %F            color dict
#   %f            reset color
#   %l            terminal name we make use of
#   %M            full host name
#   %m            short host name
#   %d            current directory
#   %~            current directory ( use ~ to represent sub directories of home directory )
#   %S~%s         reverse between ~
#   %U~%u         underline between ~
#   %B~%b         make bold between ~
#   %t,%@         time by 12 hour notation
#   %T            time by 24 hour notation
#   %w            date (week day)
#   %W            date (month/day/year)
#   %D            date (year-month-day)
# git:
#   %b => current branch
#   %a => current action (rebase/merge)

#   prompt charaters format
if [ $UID = 0 ] ; then
    PSCOLOR='01;04;31'      # bold;underline;red
else
    PSCOLOR='00;04;32'      # thin;underline:green
fi

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git # You can add hg too if needed: `git hg`
zstyle ':vcs_info:git*' formats ' %b'
zstyle ':vcs_info:git*' actionformats ' %b|%a'


PROMPT_INFO_DEFAULT="%F{blue}%~%f"

PROMPT_INFO="${PROMPT_INFO_DEFAULT}"

PROMPT_TTY="%F{magenta}%U%n%u%f%F{243}@%f%F{248}%m%f %(?.%F{magenta}.%F{red})❯%F{white} "

PROMPT="${PROMPT_INFO}
${PROMPT_TTY}"

# export MYSQL_PS1="(${LIGHTGRAY}\u${DEFAULT}@${LIGHTPURPLE}\h${DEFAULT}) [${LIGHTBLUE}\d${DEFAULT}]> "


#   show vim mode status {{{2
# ==================================================

function zle-line-init zle-keymap-select {
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

function vi_mode_prompt_info() {
  [[ $KEYMAP == 'vicmd' ]] && echo "%F{green}-- NORMAL%F{white} "
}

RPROMPT='$(vi_mode_prompt_info)'


# ===============================================================================
# Hook at chpwd and preexec     {{{1
# ===============================================================================

typeset -ga chpwd_functions
typeset -ga preexec_functions
typeset -ga precmd_functions

function _rprompt_locallib() {
  local -A locallib
  locallib="$(print_locallib 2>/dev/null)"
  if [ $? = '0' -a "${locallib}" != 'none' ]; then
      echo "(${locallib})"
  fi
}

functions _set_rprompt() {
  PROMPT="
${PROMPT_INFO_DEFAULT}%F{240}${vcs_info_msg_0_}%f
${PROMPT_TTY}"
}

functions _clear() {
  clear
}


#   exec ls if the number of files in current dir is less than 100
functions _show_ls() {
  local maxfiles=100
  nfiles=$(/bin/ls | wc -l)
  if [ $nfiles -gt 0 -a $nfiles -le $maxfiles ]; then
      ls
  fi
}

chpwd_functions+=_show_ls
chpwd_functions+=_set_rprompt

preexec_functions+=_set_rprompt
# preexec_functions+=_clear

precmd_functions+=vcs_info

# title for screen
#---------------------------------

case "${TERM}" in screen*)
  local -a shorthost
  shorthost="${HOST%%.*}:"

  # display title on screen window like 'host:dir' or 'host:$cmd'
  functions _display_host_dir() {
      echo -ne "\ek${shorthost}\$${1%% *}\e\\"
  }

  # back to 'host:dir' after exit cmd.
  functions _display_host_dir_back() {
      echo -ne "\ek${shorthost}$(basename $(pwd))\e\\"
  }

  preexec_functions+=_display_host_dir
  precmd_functions+=_display_host_dir_back
  ;;
esac


# ===============================================================================
# Functions     {{{1
# ===============================================================================

for file in ${ZSH_FUNCTIONS_DIR}/*.zsh; do
  [ -f $file ] && source $file
done

autoload mkcd namedir psg randomline rm-safe


# ===============================================================================
# Configurations     {{{1
# ===============================================================================

for file in ${ZSH_CONFIGURATIONS_DIR}/*.zsh; do
  [ -f $file ] && source $file
done


# ===============================================================================
# Plugins     {{{1
# ===============================================================================

#   auto-fu.zsh   {{{2
# ==================================================

if which auto-fu-init >/dev/null; then
  # { . $ZSH_DIR/auto-fu; auto-fu-install; }
  zstyle ':auto-fu:highlight' input bold
  zstyle ':auto-fu:highlight' completion fg=black,bold
  zstyle ':auto-fu:highlight' completion/one fg=white,bold,underline
  # zstyle ':auto-fu:var' postdisplay $'\n-azfu-'
  zstyle ':auto-fu:var' postdisplay $''
  zstyle ':auto-fu:var' track-keymap-skip opp
  zle-line-init () {auto-fu-init;}; zle -N zle-line-init
  zle -N zle-keymap-select auto-fu-zle-keymap-select
fi

#   zsh-autosuggestions.zsh   {{{2
# ==================================================

# if [ -f $ZSH_BUNDLE_DIR/zsh-autosuggestions/autosuggestions.zsh ]; then
    # source $ZSH_BUNDLE_DIR/zsh-autosuggestions/autosuggestions.zsh

    # # Enable autosuggestions automatically
    # zle-line-init() {
        # zle autosuggest-start
    # }
    # zle -N zle-line-init

    # # toggle autosuggestions
    # bindkey '^Z' autosuggest-toggle
# fi

#   zsh-autosuggestions.zsh   {{{2
# ==================================================

if which history-substring-search-up >/dev/null; then
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down
  # vi mode
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi


#   odd.zsh   {{{2
# ==================================================

if [ -f $ZSH_BUNDLE_DIR/opp.zsh/opp.zsh ]; then
  source $ZSH_BUNDLE_DIR/opp.zsh/opp.zsh
  source $ZSH_BUNDLE_DIR/opp.zsh/opp/*.zsh
fi

#   zce.zsh   {{{2
# ==================================================

if [ -f $ZSH_BUNDLE_DIR/zce.zsh/zce.zsh ]; then
  source $ZSH_BUNDLE_DIR/zce.zsh/zce.zsh
fi

# ===============================================================================
# Commands     {{{1
# ===============================================================================

#   ls
if [ -e "/etc/DIR_COLORS" ]; then
  eval `dircolors -b /etc/DIR_COLORS`
elif [ -e "$HOME/etc/sh/DIR_COLORS" ]; then
  eval `dircolors -b $HOME/etc/sh/DIR_COLORS`
fi

# less
export LESS='-nqR'

if which pygmentize 1>/dev/null 2>&1; then
  export LESSOPEN='|lessfilter %s' 
fi

# ===============================================================================
# Alias     {{{1
# ===============================================================================

# ---- a

alias ag='ag -S --stats'

# ---- c

# if we have pygments, highlighted cat
if which pygmentize 1>/dev/null 2>&1; then
  alias c='pygmentize -O style=trac -f console256 -g '    # style=monokai
else
  alias c='cat'
fi

alias cp="cp -iav"

# ---- d

#   docker
alias d="docker"
alias de="docker-destroy"
alias di="docker images"
alias dk="docker kill"
alias dp="docker ps"
alias dr="docker rm"

#   view directory history
alias dh="dirs -v"

# ---- e

alias e="echo"

# ---- f

# find
alias f="find"
function ff() {
  local dir=$1 && shift
  find "${dir}" -type f "$@"
}
function fd() { 
  local dir=$1 && shift
  find "${dir}" -type d "$@"
}
function fn() {
  local dir=$1 && shift
  local pattern=$1 && shift
  find "${dir}" -name "${pattern}" "$@"
}

# ---- g

#   git
if which hub 1>/dev/null 2>&1; then
  function git() { hub "$@" }
  function g() { hub "$@" }
else
  alias g="git"
fi
#   use the same completion as git
compdef g=git

# alias grep="grep -E"
alias grep='grep --color=auto'

# ---- h

alias h="history -30"

# ---- l

alias l="ls"
alias la="ls --color=auto -at"
alias ls="ls -F --color=auto"
alias ll="ls --color=auto -lt"
alias lla="ls --color=auto -lat"
alias llh="ls -lth"
alias lsd="ls -dt */"
alias lld="ls -l -dt */"

# ---- m

#   man
alias m="man"
alias man="LC_ALL=C LANG=C /usr/bin/man"

alias mv="mv -iv"

# ---- n

alias netmonitor="netstat G -v localhost | grep -v stream | grep -v dgram"

# ---- p

## ls | p cd
p() { peco | while read LINE; do $@ $LINE; done }

# ---- r

alias repo='cd $(ghq root)/$(ghq list | peco)'
alias repo-remote='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

alias rm="rm-safe"

# ---- s

# preserve user ENV varables and aliases on sudo
# (tail space must not be removed!)
alias sudo="sudo -E "

# ---- t

alias tree="tree -F"

# ---- x

alias x="exit"

# ---- v

alias vr="vim -R"
alias view-binary="od -t cx1 -w8"


#   suffix alias  {{{2
# ==================================================

alias -s {txt,c,cpp,h,bak}=$PAGER
alias -s {tgz,gz}=zcat
alias -s {tbz,bz2}=bzcat
alias -s zip=zipinfo


#   global alias  {{{2
# ==================================================

# ---- e
alias -g E="| nkf -e"
# ---- h
alias -g H="| head"
alias -g H20="| head -n20"
alias -g H30="| head -n30"
alias -g H50="| head -n50"
alias -g H100="| head -n100"
alias -g H500="| head -n500"
# ---- g
alias -g G="| grep -E"
# ---- j
alias -g JSON="| python -m json.tool"
alias -g JQ="| jq -C '.'"
# ---- l
alias -g L="| less -R -M"
alias -g LN=" L -N"
# ---- p
alias -g P="| p"
# ---- s
alias -g S="| nkf -s"
# ---- t
# tail
alias -g T="| tail"
alias -g T20="| tail -n20"
alias -g T30="| tail -n30"
alias -g T50="| tail -n50"
alias -g T100="| tail -n100"
alias -g T500="| tail -n500"
alias -g T1000="| tail -n1000"

alias -g TAI="| tai64nlocal"
# ---- u
alias -g U="| nkf -w"
# ---- x
alias -g X0="-print0 | xargs -0"
alias -g X0I="-print0 | xargs -0 -i"
alias -g X0G="-print0 | xargs -0 grep -E -n"
#   copy matched pathes with keeping directory structure
alias -g X0CP="-print0 | cpio -pd0 "
# ---- v
alias -g V="| vim -R -"
# ---- w
alias -g WL="| wc -l"
alias -g WW="| wc -w"

# ---- convert character encoding
alias -g SJIS="| iconv -f sjis"
alias -g EUCJP="| iconv -f euc-jp"
alias -g IS="| iconv -f sjis"
alias -g IE="| iconv -f euc-jp"
alias -g IU="| iconv -f utf8"
alias -g OS="| iconv -t sjis"
alias -g OE="| iconv -t euc-jp"
alias -g OU="| iconv -t utf8"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'


# ===============================================================================
# Local Settings    {{{1
# ===============================================================================

[ -f ~/.zshrc.local ] && source ~/.zshrc.local


# ===============================================================================
# Finalize  {{{1
# ===============================================================================

# vim: expandtab softtabstop=2 shiftwidth=2
# vim: set fdm=marker:
