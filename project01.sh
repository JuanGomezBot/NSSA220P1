#!/bin/bash

files=$(ls | cut -d "," -f 1,2,3,4,5,6)

spawn() {
    for i in $files; do
        ./$i 129.21.141.90 &
    done
}

finish() {
        for pid in $(ps | egrep "APM" | awk '{print $1}'); do
            kill "$pid"
            echo "Killed $pid"
        done
}
