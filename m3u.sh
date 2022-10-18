#!/bin/bash

if [[ $1 = "help" ]]; then
  echo "./m3u.sh <path>               # create playlist.m3u files in <path> subfolders, when needed"
  echo "./m3u.sh help                 # show usage"
  exit
fi

if [ $# -eq 0 ]
  then
    echo 'Missing path. Usage: ./m3u.sh <path>'
    exit 2
fi
FILEPATH=$1

function m3u()
{
    # apply m3u on subfolders of current directory
    readarray -t dirs < <(find "$1" -maxdepth 1 -type d -not -path "*/.*" -printf '%P\n')
    for dir in "${dirs[@]}"; do
        if [ ! -z "$dir" ]
        then
            m3u "$1/$dir"
        fi
    done

    # if playlist.m3u exists, skip
    if [ -f "$1/playlist.m3u" ]
    then
        return
    fi

    # get audio files for current directory
    readarray -t tmp < <(find "$1" -maxdepth 1 -type f \( -iname \*.mp3 -o -iname \*.wav -o -iname \*flac -o -iname \*loss -o -iname \*aiff -o -iname \*aif \) -not -path "*/.*" -printf '%P\n')
    readarray -t files < <(printf '%s\n' "${tmp[@]}" | sort)
    if [ ! -z "$files" ]
    then
        for file in "${files[@]}"; do
            if [ ! -z "$file" ]
            then
                echo $file >> "$1/playlist.m3u"
            fi
        done
        echo "Created: $1/playlist.m3u"
    fi
}

m3u $1
