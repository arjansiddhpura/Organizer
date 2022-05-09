#! /bin/bash

: ' 
possible variations to organize
    ./organize photos/           using date of last modification
    ./organize -m photos/        using date of last modification
    ./organize -c photos/        using date of creation

'

# dolm = date of last modification is default opt
using_dolm=true; 

# check directory
function check_dir()
{
    # check if directory provided
    if [ "$DIRECTORY" = "" ]
    then 
        echo "no directory provided"
        exit 1

    # check if directory is a directory
    elif ! [ -d "$DIRECTORY" ]
    then
        echo "$DIRECTORY is not a directory";
        exit 1
    fi
}

# look for -c and -m opts
while getopts "cm" opt; do 
    case $opt in
        # -c opt organizes using creation date
        c) DIRECTORY="$2"; using_dolm=false; check_dir; echo "organizing using date of creation...";;
        # -m opt organizes using last modified date
        m) DIRECTORY="$2"; check_dir; echo "organizing using date of last modification...";;
    esac
done

# if no flags provided, proceeed with default opt
if (( $OPTIND == 1 )); then
    DIRECTORY=$1
    check_dir
    echo "organizing using date of last modification..."
fi

# count number of files organized
counter=1

if [ $using_dolm == true ]
then
    # organizing using date of last modification
    for photo in "$DIRECTORY"*.[jJ][pP][gG] "$DIRECTORY"*.[jJ][pP][eE][gG] "$DIRECTORY"*.[pP][nN][gG]; do    
        d=$(date -r "$photo" +%Y-%m)
        dirname="${DIRECTORY}${d}"
        mkdir -p -- "$dirname"
        mv -- "$photo" "$dirname/"
        ((counter++))
    done
    echo "$counter files organized using date of last modification"
    exit 0

else
    # organizing using date of last creation
    for photo in "$DIRECTORY"*.[jJ][pP][gG] "$DIRECTORY"*.[jJ][pP][eE][gG] "$DIRECTORY"*.[pP][nN][gG]; do
        d=$(stat -f %SB -t %Y-%m "$photo")
        dirname="${DIRECTORY}${d}"
        mkdir -p -- "$dirname"
        mv -- "$photo" "$dirname/"
        ((counter++))
    done
    echo "$counter files organized using date of creation"
    exit 0
fi