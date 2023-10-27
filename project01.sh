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
sys_metrics(){


#Collects memory utilities
#It install the sysstat which is necessary for the iostat and to remove all the output it will use -q and -y to authorize it
sudo yum install -q -y sysstat

# read network bandwith {I use the ifstat on the ens33 and make it read only the 4th field and move it to netbandwith.txt it will find the
ifstat -t 1 | grep ens33 | awk '{print  $7 ","  $9}' >> ens33_netbandwidth.csv

#Uses iostat to read the hard disk access rate in kb/s and redirect it to sda_metrics
iostat -k  | grep sda | awk '{print $4}' >> sda_hard_disk_access_metrics.csv
# 
ps  | grep 'APM' | awk '{print $2 "," $3 "," $4}' >> "process_metrics/process_metrics.csv"

df / -m | tail -n 1 | awk '{print  $3 }' >> hard_disk_available_metrics.csv

sleep 5
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
        
        sys_metrics
        sleep 5
        ((count++))
        secs=$(( $count * 5 ))
        echo "$secs seconds have passed"
        echo "$count sample(s) have been taken"
        
        if [ $secs -eq 900 ]; then
        break
        fi
    done
}

spawn
collect
finish
