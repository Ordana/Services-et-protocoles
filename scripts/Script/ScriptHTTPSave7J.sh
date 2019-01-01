#!/bin/bash

#Script permettant la sauvegarde des sites internets sur le serveur HTTP

date=$(date +%Y%m%d)												#Récupération de la date du jour
dateOld=$(date -d "49 days ago" +%Y%m%d)							#Récupération de la date d'il y a 7 cycles de sauvegarde

if [ -d "/var/www" ]; then
	ssh root@192.168.10.6 mkdir /srv/save/fichiersHTTP/$date			#Creation du dossier devant contenir les fichiers
	ssh root@192.168.10.6 rm -r /srv/save/fichiersHTTP/$dateOld		#Suppression de l'ancien dossier

	scp -r /var/www root@192.168.10.6:/srv/save/fichiersHTTP/$date	#Copie du dossier WWW dans le nouveau dossier
else
	exit 1
fi

exit 0