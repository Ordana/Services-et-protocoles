#!bin/bash

LOG_CSV = "/srv/log.csv"					#Création des variables
STATE_CSV = "/srv/supervision.csv"

LOG_HTML = "/var/www/supervision/log.html"
STATE_HTML = "/var/www/supervision/state.html"

csv2html $LOG_CSV -d \; -c > $LOG_HTML		#Tranfosrmation du csv en html
csv2html $STATE_CSV -d \; -c > $STATE_HTML	# le "d" permet de définir le délimiteur
											# le "c" permet de générer un fichier html complet

exit 0