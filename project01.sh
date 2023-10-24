#!/bin/bash

files=$(ls | egrep "APM" | cut -d "," -f 1,2,3,4,5,6)

spawn() {
    for i in $files; do
        ./$i 129.21.141.90 &
    done
}

finish() {
    for pid in $(ps | egrep "APM" | awk '{print $1}'); do
        kill $pid
    done
}

collect() {
    #keep processes running and collect data and increment sampling using sleep
    count=0
    while (true); do
        if [[ $count = 180 ]]
        then
            echo "Collection done"
            break
        fi

        iostat
        sleep 5
        ((count++))
        secs=$(( $count * 5 ))
        echo "$secs seconds have passed"
        echo "$count sample(s) have been taken"
    done
}

spawn
collect
finish