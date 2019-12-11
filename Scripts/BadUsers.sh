#!/bin/bash
p=0
ti=0
usage="Usage: BadUser.sh [-p]"
# detecció de opcions d'entrada: només son vàlids: sense paràmetres i -p
while getopts ":t:p" o; do
case "${o}" in
t)
t=${OPTARG}
ti=1
;;
p)
p=1
;;
esac
done
shift $((OPTIND-1))
if [ -z "${s}" ] || [ -z "${p}" ]; then
echo ${usage}
fi
t1="-${t:0:1}"
t2=${t:1:1}
if [ "$t2" == "d" ]; then
t3="'${t1} day'"
t4="${t1}"
fi
if [ "$t2" == "m" ]; then
t3="'${t1} month'"
t4=$(($t1 * 30))
fi
if [ "$t2" == "y" ]; then
t3="'${t1} year'"
t4=$(($t1 * 365))
fi
echo "t = ${t}"
echo "p = ${p}"
echo "t1 = ${t1}"
echo "t2 = ${t4}"
# afegiu una comanda per llegir el fitxer de password i només agafar el camp de # nom de
l'usuari
for user in `cut -d : -f 1 /etc/passwd`; do
home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
if [ -d $home ]; then
num_fich=`find $home -type f -user $user | wc -l`else
num_fich=0
fi
if [ $num_fich -eq 0 ] ; then
if [ $p -eq 1 ]; then
# afegiu una comanda per detectar si l'usuari te processos en execució,
# si no te ningú la variable $user_proc ha de ser 0
user_proc=`ps -u $user | wc -l`
if [ $user_proc -eq 0 ]; then
echo "$user"
fi
else
echo "$user"
fi
fi
if [ $ti -eq 1 ]; then
user_proc=`ps -u $user | wc -l`
if [ $user_proc -eq 0 ]; then
ultimlog =`last -s $t3 | grep $user`
if [[ $ultimlog ]]; then
ultimmodif =`find $home -mtime $t4`
if [[ $ultimmodif ]]; then
echo "$user"
fi
fi
fi
fi
done