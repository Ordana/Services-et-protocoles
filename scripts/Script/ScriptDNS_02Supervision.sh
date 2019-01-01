#!/bin/bash

#Script permettant la mise a jour de l'état des serveur et des connexions

string=""				#Création d'une chaine de caractère vide, contenant à terme la ligne au format .csv

resultHTTP=$(ping -c 1 192.168.10.10 | grep -o "[0-1] received"|grep -o "[0-1]")			#Ping du serveur http et stockage de la valeur de réponse
																							# "-c 1" permet de n'effectuer qu'un seul ping
if [[ "$resultHTTP" == 1 ]]; then
	string="$string Le serveur HTTP est accessible;"										#Si une réponse est reçue c'est que le serveur HTTP est accessible
else
	string="$string Le serveur HTTP n'est pas accessible;"									#Si aucun réponse n'est reçue c'est que le serveur HTTP est innnacessible
fi


resultDNS=$(dig www.carnofluxe.fr | grep "status" | grep -o "NOERROR")						#Dig sur le domaine carnofluxe.fr et stockage de la valeur de réponse

if [ "$resultDNS" == "NOERROR" ]; then
        string="$string Le service de resolution de nom est fonctionnel;"					#Si la réponse contient le statut "NOERROR" c'est que le DNS est accessible et fonctionnel sur ce domaine
else
        string="$string Le service de resolution de nom ne fonctionne pas;"					#Si la réponse contient un autre statut c'est que le DNS est innacessible ou ne fonctionne pas sur ce domaine
fi


resultPage=$(curl -I -s "www.carnofluxe.fr" | grep "HTTP/" | grep -o "[0-9]\{3\}")								#Requete GET via la commande curl sur la page www.carnofluxe.fr
resultDelay=$(curl -I -s -w "Total time: %{time_total}\n" "www.carnofluxe.fr" | grep "Total time:")				# "-I" permet ne récupérer que le header de la réponse ; "-s" permet de ne pas afficher les requetes ;
																												# "-w" permet d'ajouter une demande d'information, ici le temps de réponse à la requête

if [ "$resultPage" -ge "200" -a "$resultPage" -le "299" ]; then
        string="$string La page http://www.carnofluxe.fr/ est accessible et fonctionnelle; $resultDelay s;"		#Si le code de statut est compris entre 200 et 299, alors la page est accessible et on peut
else																											#stocker le temps de réponse
        string="$string La page http://www.carnofluxe.fr/ n'est pas accessible;"								#Si le code n'est pas compris dans cet intervalle ou qu'il n'y a pas de code de statut dans la réponse
fi 																												#on ne stocke pas le temps de réponse et on considère la page commme innacessible

echo "$string" > /srv/supervision/supervision.csv									#On ecrit la string au format .csv dans le fichier
scp /srv/supervision/supervision.csv root@192.168.10.10:/srv/						#On copie le fichier sur le serveur HTTP pour permettre son affichage

exit 0
