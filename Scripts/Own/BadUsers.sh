#!/bin/bash
 
t=0
has_recently_logged_in=0
 
usage="Usage: BadUser.sh [-t <period>]"
 
if [ $# -ne 0 ]; then
    if  [ $# -eq 2 ]; then
        if [ $1 == "-t" ]; then
            t=1
            index=`echo $2 | wc -c `
        firstelems=`expr $index - 2`
        time=`echo $2 | cut -c -$firstelems`
#substring handling
        lastelem=`expr $index - 1`
        param=`echo $2 | cut -c $lastelem -`
        if [ $param == "m"  ]; then
        time=`expr $time \* 31`
        echo $time
        elif [ $param != "d" ]; then
        echo $usage; exit 1
        fi
        else
            echo $usage; exit 1
        fi
    else
        echo $usage; exit 1
    fi
fi
users=`cat /etc/passwd | cut -d: -f1`
 
for user in $users; do
    home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
    if [ -d $home ]; then
        num_fich=`find $home -type f -user $user | wc -l`
    else
        num_fich=0
    fi
    if [ $num_fich -eq 0 ] ; then
        if [ $t -eq 1 ]; then
            user_proc=`ps aux --no-headers | grep "^$user\>" | wc -l`
            if [ $user_proc -eq 0 ]; then
            recent_edited_files=`find $home -mtime -$time | wc -l`
            if [ $recent_edited_files -eq 0 ]; then
                has_recently_logged_in=`lastlog -u $user -t $time | wc -l`
                if [ $has_recently_logged_in -eq 0 ]; then
                echo "$user"
                fi
           fi
 
            fi
        else
            echo "$user"
        fi
    fi    
done
