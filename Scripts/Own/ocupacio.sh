#!/bin/bash
 
 
usage="Usage: ocupacio.sh <max_permes>"
 
if [ $# -ne 0 ]; then
    if  [ $# -eq  1 ]; then
    index=`echo $1 | wc -c `
    size=`expr $index - 2`
    lastelem=`expr $index - 1`
    param=`echo $1 | cut -c $lastelem -`
        if [ $param != "M" ]; then
        echo $usage; exit 1
        fi
    else
        echo $usage; exit 1
    fi
fi
 
users=`cat /etc/passwd | cut -d: -f1`
fitxers_size=0
for user in $users; do
    home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
    if [ -d $home ]; then
        fileSizes=`du $home | cut -f1`
    total=0
    for fileSize in $fileSizes; do
        total=`expr $total + $fileSize`
    done
    else
        total=0
    fi
    units=0
    modtotal=$total
    while [ 1024 -lt $modtotal ]; do
    modtotal=`expr $modtotal / 1024`
    units=`expr $units + 1`
    done
    unit="B"
    if [ $units == 1 ]; then
    unit="KB"
    elif [ $units == 2 ]; then
    unit="MB"
    elif [ $units == 3 ]; then
    unit="GB"
    fi
    echo $user $modtotal$unit
    if [ $total > $size ] ; then
        echo "---------" #escriure al .profile
    fi    
done
