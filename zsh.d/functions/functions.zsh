#!/bin/zsh
# emulate -RL zsh


# usage: pop 3 "args"
function pop() {
    local count=1
    [[ $1 == <-> ]] && {
        count=$1
        shift
    }

    for name in $*; do
        repeat $count do
            eval $name'[$#'$name']=()'
        done
    done
}


function history-all { history -E 1 }


function cleanup-vim-swapfiles {
    local target="$1"
    if [ ! $target ]; then
        target="."
    fi
    find $target -type f \( -name ".*.swo" -o -name ".*.swp" \) -print | while read i
    do
        echo "delete " $i
        /bin/rm $i
    done
}


function backup {
    local BACKUP_DIR="$HOME/backup"
    local FILENAME_PREFIX=""

    while getopts "p:d:" OPT
    do
        case $OPT in
            d) if [ -d $OPTARG ]; then
                   BACKUP_DIR=$OPTARG
               fi
               ;;
            p) FILENAME_PREFIX=$OPTARG
               ;;
            \?) echo "Usage: $0 [-d diretory] [-p prefix] filename.." 1>&2
                exit 1
               ;;
        esac
    done
    shift `expr $OPTIND - 1`

    for FILEPATH in "$@"
    do
        cleanup-vim-swapfiles ${FILEPATH}

        FILENAME=`basename ${FILEPATH}`
        BASEDIR=`dirname ${FILEPATH}`
        if [ -d $BACKUP_DIR ]; then
            mkdir -p $BACKUP_DIR
        fi
        BACKUPFILE=$BACKUP_DIR/${FILENAME_PREFIX}${FILENAME}-`date "+%y%m%d%H%M"`.tar.gz 
        tar zcvf $BACKUPFILE -C $BASEDIR $FILENAME
        echo ${FILEPATH} has  backed up to ${BACKUPFILE}
    done
}


function _do_backup {
    local cmd=$1; shift 1
    args=($@)

    last_arg=${args[$#]}
    # expand tilda
    last_arg=`eval echo $last_arg`

    # if last argument is directory, use backup directory
    dest_dir=""
    if [ -d $last_arg ]; then
        dest_dir="$last_arg"
        pop 1 "args"
    fi

    for filename in $args
    do
        d=""
        if [ dest_dir = "" ]; then
            d=`dirname $filename` "/"
        else
            d="${dest_dir}/"
        fi

        ext=`date '+%Y%m%d'`
        backupfile="${d}${filename}.${ext}"
        echo $backupfile
        if [ ! -e $backupfile ]; then
            ${(z)cmd} ${filename} ${backupfile}
            continue
        fi

        for i in {1..100}
        do
            newbackupfile=${backupfile}.${i}
            if [ ! -e $newbackupfile ]; then
                ${(z)cmd} ${filename} ${newbackupfile}
                continue 2
            fi
        done
    done
}

function mv-backup {
    _do_backup "mv -v" "$@"
}

function cp-backup {
    _do_backup "cp -av" "$@"
}


#   move to the root directory of the current git repository.
function _git_root() {
    if [[ -e $1/.git ]]; then
        echo $1
    # why check inode ? I guess it would be enought to check '$1 -eq "/"'
    elif [[ $(stat --printf "%i" $1) == $(stat --printf "%i" "/") ]]; then
        echo .
    else
        _git_root $1/..
    fi
}

function git_root() {
    cd $(_git_root ".")
}


function repeat-echo {
    local n=$1
    local message=$2

    for i in {1..$n}
    do
        echo $message
    done
}
