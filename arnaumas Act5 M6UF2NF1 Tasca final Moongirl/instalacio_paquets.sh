#!/bin/bash

# Aquest arxiu recull les diferents comandes d'instal·lació de paquets a les diferents màquines
# virtuals. Cal destacar que, anteriorment, hem d'haver configurat el servidor remot amb el fitxer
# crear_claus_ssh.sh l'accés a les màquines virtuals amb certificat privat/públic.
# -------------------------------------------------------------------------------------------

echo "<< ADVERTÈNCIA >>"
echo "Aquest programa instal·larà/actualitzarà els següents programes al servidor: "
echo "-----------------"
echo "nmap"
echo "open-ssh server"
echo "smartmontools"
echo "-----------------"
echo ""

# Preguntarem a l'usuari si vol instal·lar els programes que hi ha a la llista.
# Com que si ja existeixen només els actualitzarà, tirarem endavant sense problema
# i sense necessitat de veure si ja han estat instal·lats.
valid_option=false
# Farem que la pregunta al usuari sigui a prova d'errors
until [[ $valid_option = true ]]
do
	read -p "Vols continuar? [y/n]: " user_option
	user_option=${user_option,,}
	if [[ $user_option != "n" && $user_option != "y" ]]
	then
		echo "ERROR: Opció no vàlida"
	else
		valid_option=true
	fi
done

# En cas que l'usuari hagi dit que sí, aleshores farem la instal·lació de dits programes
# al servidor remot. Per tant, necessitarem que ens doni les dades per accedir-hi abans que res.
if [[ $user_option == "y" ]]
then
	echo "S'instal·laran/actualitzaran els programes de la llista al servidor remot"
	echo ""
	read -p "Entra la IP del servidor: " server_ip
	echo ""
	# Com que la creació de claus SSH la fem a partir del nom d'usuari, aquest ha de coincidir
	# amb el nom de la clau (és a dir, al servidor hi ha d'haver el mateix usuari que existeix
	# a la màquina on es té la clau privada. Avisem al usuari d'això.
	echo "ATENCIÓ: El següent paràmetre ha de coincidir amb el nom del fitxer de la clau privada"
	read -p "Entra l'usuari del servidor: " server_username
	sleep 1
	clear

	# Farem una comprovació fàcil on es realitzarà una connexió SSH. Aquesta no ha de demanar
	# clau, ja que es fa a través de clau pública/privada. Dita connexió surt directament
	# del servidor. Si no es pot executar, aleshores significarà que les credencials no són
	# correctes i s'avisarà al usuari en aquest cas.
	if [[ ! -f ~/.ssh/${server_username} ]]
	then
		echo "ERROR: No hi ha claus per aquest usuari"
	else
		if ssh ${server_username}@${server_ip} exit &>/dev/null
		then
			echo "SUCCESS: S'ha pogut establir connexió amb el servidor"
			# Necessitarem una contrasenya per accedir als permisos de l'usuari
			# per executar les comandes d'instal·lació. Com que només ho demanarà
			# una sola vegada, la posarem dins del apt-get update i les demés simplement
			# les executarem amb el sudo. Aquesta contrasenya se li demanarà al
			# usuari. Per tant, si no la té o no és correcte, no es faran les comandes
			# al servidor.
			read -s -p "Entra la contrasenya de 'sudo' del servidor: " password
			sleep 1
			clear
			ssh ${server_username}@${server_ip} <<- END
				echo $password | sudo -S apt-get update &>/dev/null
				echo "S'HAN ACTUALITZAT ELS REPOSITORIS"
				echo ""
				sudo apt-get install -y nmap &>/dev/null
				echo "S'HA INSTAL·LAT/ACTUALITZAT nmap"
				echo ""
				sudo apt-get install -y openssh-server &>/dev/null
				echo "S'HA INSTAL·LAT/ACTUALITZAT open-ssh server"
				echo ""
				sudo apt-get install -y smartmontools &>/dev/null
				echo "S'HA INSTAL·LAT/ACTUALITZAT smartmontools"
			END
		else
			echo "ERROR: No es pot accedir al servidor"
		fi
	fi
else
	echo "No s'instal·larà ni actualitzarà cap programa al servidor remot"
fi
echo ""
echo "<< FI DEL PROGRAMA >>"
