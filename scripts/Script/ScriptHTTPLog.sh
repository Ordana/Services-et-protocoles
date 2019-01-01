#!bin/bash

DAYOFMONTH=$(date -d "1 hour ago" +%d)						#Déclaration des variables
MONTH=$(date -d "1 hour ago" +%b)
YEAR=$(date -d "1 hour ago" +%Y)
HOURS=$(date -d "1 hour ago" +%H)
LOG_APACHE="/var/log/access.log"
FILETEMP="/srv/temp.txt"
VARTEMP=""

touch "/srv/temp.txt"						#Création d'un fichier temp

grep -E '$DAYOFMONTH/$MONTH/$YEAR:$MONTH:.*carnofluxe.fr' $LOG_APACHE > $FILETEMP		#Sélection des lignes avec des ip qui se sont connectées lors de la dernière heure
grep -E '^(25[0–5]|2[0–4][0–9]|[01]?[0–9][0–9]?).(25[0–5]|2[0–4][0–9]|[01]?[0–9][0–9]?).(25[0–5]|2[0–4][0–9]|[01]?[0–9][0–9]?).(25[0–5]|2[0–4][0–9]|[01]?[0–9][0–9]?)$' $FILETEMP > $FILETEMP		#Permet d'épurer la sélection pour ne garder que les ip des lignes selectionnées

while read line								#Permet de parcourir le fichier ligne par ligne
do
   $VARTEMP = "$line\n"						#Sélection l'ip de la ligne
   curl http://ip-api.com/csv/$VARTEMP >> "/srv/log.csv"	#Exécute un requete avec l'ip pour avoir des informations sur cette dernière au format CSV
done

rm /srv/temp.txt							#Supprime le fichier temp

exit 0
