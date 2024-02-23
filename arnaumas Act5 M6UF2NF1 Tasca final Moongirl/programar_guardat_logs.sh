#!/bin/bash

# Aquest script és complementari i no depèn dels altres (només del de la creació i còpia de les
# claus SSH per a poder accedir al servidor remot. La funció d'aquest SCRIPT és de crear un directori
# a la màquina local (si no existeix) i guardar allà els arxius de logs del servidor. A més,
# això programa perquè els logs es copiin en cert moment i a certa hora del dia, modificant el fitxer
# de cron del servidor remot.
# -------------------------------------------------------------------------------------------

# Agafarem, de nou, la data i hora actuals. Això ho farem per mostrar-ho per pantalla en l'HTML
# per avisar de quan va ser la última vegada que es va generar el mateix codi HTML.
date=$(date '+%Y-%m-%d')
hour=$(date '+%H:%M:%S')

# Guardarem la informació de l'script dins una funció
program_info() {
	echo "<< INFORMACIÓ >>"
	echo "Aquest programa crearà un directori on es guardaran els registres del servidor donat."
	echo "A més, es programaran els logs al servidor perquè es copiin en cert dia i certa hora"
	echo "cada setmana. Aquesta última part però, serà opcional per a l'usuari, ja que la"
	echo "funció principal serà copiar-los en aquell mateix moment."
}

get_server_info() {
	read -p "Introdueix la IP del servidor remot: " server_ip
	echo ""
	echo "ATENCIÓ: El següent paràmetre ha de coincidir amb el nom del fitxer de la clau privada"
	read -p "Introdueix el nom d'usuari del servidor remot: " server_username
	echo ""
	echo "ATENCIÓ: Aquest script només es podrà executar correctament amb els permisos adients."
	echo "Si l'usuari amb el que et conectes no té permisos d'administrador, no es podrà completar"
	echo "correctament."
	read -s -p "Introdueix la contrasenya de 'sudo' de l'usuari amb permisos del servidor remot: " password
	sleep 1
	clear
	connect_success=false
	if ssh ${server_username}@${server_ip} exit &>/dev/null
	then
		echo "SUCCESS: S'ha pogut establir connexió amb el servidor"
		echo ""
		echo "ATENCIÓ: Si es queda penjat el programa en aquesta part, si us plau"
		echo "executa CTRL+C, ja que la contrasenya no ha sigut acceptada."
		echo ""
		if echo $password | ssh -tt ${server_username}@${server_ip} sudo date &>/dev/null
		then
			ssh ${server_username}@${server_ip} exit &>/dev/null
			echo "La contrasenya de 'sudo' és correcte i es té permisos"
			echo "PROCEDINT..."
			connect_success=true
		else
			ssh ${server_username}@${server_ip} exit &>/dev/null
			echo "ERROR: La contrasenya de 'sudo' no és correcte o no tens permisos d'administrador."
		fi
	else
		echo "ERROR: No s'ha pogut establir connexió amb el servidor"
	fi
	sleep 2
	clear
}

# --------------- CODI PRINCIPAL --------------
program_info
echo ""
get_server_info
if [[ $connect_success = true ]]
then
	if [[ ! -d ~/server_${server_ip}_logs ]]
	then
		mkdir ~/server_${server_ip}_logs
		echo "S'ha creat el directori:" ~/server_${server_ip}_logs
	fi
	echo "Es guardaran els següents arxius al directori de logs:"
	echo "syslog"
	echo "kern.log"
	echo "bootstrap.log"
	echo "auth.log"
	echo "cloud-init.log"
	echo ""
	user_option=""
	until [[ $user_option == "y" || $user_option == "n" ]]
	do
		read -p "Vols continuar? [y/n]: " user_option
		user_option=${user_option,,}
		# Depenent de l'elecció del usuari, executarem el codi o sortirem del programa
	done
	# Si l'usuari vol continuar amb el procés, aleshores continuarem
	if [[ $user_option == "y" ]]
	then
		mkdir ~/server_${server_ip}_logs/extracted_at_${date}_${hour}
		echo "S'ha creat el directori:" ~/server_${server_ip}_logs/extracted_at_${date}_${hour}
		echo ""
		echo "COPIANT ELS ARXIUS..."
		if scp -i ~/.ssh/${server_username}.pub ${server_username}@${server_ip}:/var/log/syslog ~/server_${server_ip}_logs/extracted_at_${date}_${hour} &>/dev/null
		then
			echo "SUCCESS: S'ha copiat l'arxiu 'syslog' correctament"
		else
			echo "ERROR: No s'ha pogut copiar l'arxiu 'syslog'"
		fi
		if scp -i ~/.ssh/${server_username}.pub ${server_username}@${server_ip}:/var/log/kern.log ~/server_${server_ip}_logs/extracted_at_${date}_${hour} &>/dev/null
		then
			echo "SUCCESS: S'ha copiat l'arxiu 'kern.log' correctament"
		else
			echo "ERROR: No s'ha pogut copiar l'arxiu 'kern.log'"
		fi
		if scp -i ~/.ssh/${server_username}.pub ${server_username}@${server_ip}:/var/log/bootstrap.log ~/server_${server_ip}_logs/extracted_at_${date}_${hour} &>/dev/null
		then
			echo "SUCCESS: S'ha copiat l'arxiu 'bootstrap.log' correctament"
		else
			echo "ERROR: No s'ha pogut copiar l'arxiu 'bootstrap.log'"
		fi
		if scp -i ~/.ssh/${server_username}.pub ${server_username}@${server_ip}:/var/log/auth.log ~/server_${server_ip}_logs/extracted_at_${date}_${hour} &>/dev/null
		then
			echo "SUCCESS: S'ha copiat l'arxiu 'auth.log' correctament"
		else
			echo "ERROR: No s'ha pogut copiar l'arxiu 'auth.log'"
		fi
		if scp -i ~/.ssh/${server_username}.pub ${server_username}@${server_ip}:/var/log/cloud-init.log ~/server_${server_ip}_logs/extracted_at_${date}_${hour} &>/dev/null
		then
			echo "SUCCESS: S'ha copiat l'arxiu 'cloud-init.log' correctament"
		else
			echo "ERROR: No s'ha pogut copiar l'arxiu 'cloud-init.log'"
		fi
		echo ""
		echo "CÒPIA DELS ARXIUS FINALITZADA"
	fi
fi
sleep 2
clear
echo "Es poden programar els logs perquè es copiin en un arxiu local al servidor remot"
echo "Aquesta programació estarà feta perquè es copiin cada Diumenge a les 00:00"
echo "Es programarà dins de l'arxiu cron del servidor remot"
echo ""
user_option=""
until [[ $user_option == "y" || $user_option == "n" ]]
do
	read -p "Vols continuar? [y/n]: " user_option
	user_option=${user_option,,}
	# Depenent de l'elecció del usuari, executarem el codi o sortirem del programa
done
# Si l'usuari vol continuar amb el procés, aleshores continuarem
if [[ $user_option == "y" ]]
then
	if echo $password | ssh -tt ${server_username}@${server_ip} sudo mkdir /autosaved_logs &>/dev/null
	then
		echo "S'ha creat el directori '/autosaved_logs' al servidor remot"
	else
		echo "No s'ha creat el directori '/autosaved_logs' perquè ja existeix"
	fi
	echo ""
	ssh ${server_username}@${server_ip} &>/dev/null <<- END
		crontab -l > ${server_username}_cron
		echo "0 0 * * SUN echo ${password} | sudo cp /var/log/syslog,auth.log,kern.log,cloud-init.log,bootstra.log /autosaved_logs" >> ${server_username}_cron
		crontab ${server_username}_cron
		rm ${server_username}_cron
	END
	echo "S'ha copiat la programació a l'arxiu crontab de l'usuari ${server_username}"
	echo ""
	echo "<< ARXIU CRONTAB >>"
	ssh ${server_username}@${server_ip} crontab -l
fi
echo ""
echo "<< FI DEL PROGRAMA >>"
