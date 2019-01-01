#!/bin/bash

#Script permettant la sauvegarde de la configuration du serveur HTTP

date=$(date +%Y%m)														#Récupération de la date du jour
dateOld=$(date -d "3 months ago" +%Y%m)									#Récupération de la date d'il y a 3 cycles de sauvegarde

if [ -d "/etc/apache2" ]; then
	ssh root@192.168.10.6 mkdir /srv/save/configHTTP/$date				#Creation du dossier devant contenir les fichiers
	ssh root@192.168.10.6 rm -r /srv/save/configHTTP/$dateOld			#Suppression de l'ancien fichier

	scp -r /etc/apache2 root@192.168.10.6:/srv/save/configHTTP/$date		#Copie du dossier Apache 2 dans le nouveau dossier
else
	exit 1
fi

exit 0