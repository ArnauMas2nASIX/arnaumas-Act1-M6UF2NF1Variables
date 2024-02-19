#!/bin/bash

# Aquest serà el primer fitxer que farem servir en la primera utilització dels scripts. Ens
# servirà per fer la connexió a una altra màquina. Ens preguntarà la IP i l'usuari del servidor
# en el que volem connectar i crearà les claus pública i privada per poder connectar-nos sense
# necessitat de contrasenya.
# -------------------------------------------------------------------------------------------

# Demanarem si l'usuari vol crear les noves claus. En cas que no vulgui perquè ja les té creades,
# no executarem la comanda per fer-les de nou i simplement continuarem. Aquesta és una possibilitat,
# ja que no estem fent una llista dels servidors on volem tenir la clau pública, sinó que estem
# fent-ho un per un.
# Primer de tot, generarem un parell de claus pública/privada per a configurar l'accés al servidor.
# Preguntarem a l'usuari si vol crear una de nova o utilitzar una ja creada.
create_new_keys=""
valid_input=false

until [[ $valid_input = true ]]
do
	if [[ $create_new_keys == "" ]]
	then
		read -p "Vols crear noves claus pública/privada? [y/n]: " create_new_keys
		create_new_keys=${create_new_keys,,}
	else
		echo "ERROR: Resposta no vàlida"
		read -p "Vols crear noves claus pública/privada? [y/n]: " create_new_keys
		create_new_keys=${create_new_keys,,}
	fi
	if [[ $create_new_keys == "y" || $create_new_keys == "n" ]]
	then
		valid_input=true
	fi
done
sleep 1
clear

# Després de fer les comprovacions amb la resposta de l'usuari, evlauem si ens ha dit
# que vol crear noves claus o si no ho vol fer. Depenent de la seva resposta doncs, executarem
# el codi que les genera o anirem directament a preguntar el nom de la clau i seguir amb el programa.
if [[ $create_new_keys == "y" ]]
then
	echo "Es procedirà a la creació de les claus pública/privada"
	# Per crear les claus, demanarem al usuari que posi el seu nom amb el que s'identificarà a la
	# màquina remota.
	read -p "Entra el teu nom per posar-li a la clau: " key_name

	# Abans de continuar, comprovarem si ja existeixen claus pública/privada per aquest usuari.
	if [[ -f ~/.ssh/${key_name}.pub && -f ~/.ssh/${key_name} ]]
	then
		# Si les claus pública/privada ja existeixen, donarem un missatge i no les crearem
		echo "Ja existeix un parell de claus per aquest usuari"
		echo "ABORT: No s'han creat noves claus"
	else
		# En cas que existeixi només alguna de les dues, el que farem serà generar de noves
		# igualment. Per no tenir errors, esborrarem el que ja existeixi abans de la creació
		# de les noves.
		if [[ -f ~/.ssh/${key_name}.pub ]]
		then
			rm ~/.ssh/${key_name}.pub
		elif [[ -f ~/.ssh/${key_name} ]]
		then
			rm ~/.ssh/${key_name}
		fi

		# Acabada la part d'assegurar-nos que no tenim errors, farem la creació de les claus
		echo ""
		ssh-keygen -t rsa -f ~/.ssh/${key_name} -C ${key_name}
		echo ""
		echo "SUCCESS: S'ha creat la clau pública/privada al següent directori: "
		ls -la ~/.ssh
	fi
else
	# En cas que no vulgui crear-ne de nou, haurem d'utilitzar unes ja existents. Per tant,
	# comprovarem si dites claus existeixen.
	key_name=""
	until [[ -f ~/.ssh/${key_name} ]]
	do
		if [[ $key_name == "" ]]
		then
			read -p "Introdueix l'usuari de la clau pública/privada: " key_name
		else
			echo "ERROR: Aquesta clau no existeix"
			echo "Si vols avortar, fes CTRL+C"
			echo ""
			read -p "Introdueix l'usuari de la clau pública/privada: " key_name
		fi
	done
fi

# Farem després una neteja de la pantalla per la següent part de l'script
sleep 3
clear

# Avisarem al usuari que, abans de crear les claus SSH, haurem d'accedir sí o sí a través del
# mètode usuari contrasenya. Per tant, al entrar a la màquina servidor, ens demanarà dita
# contrasenya.
echo ""
echo "<< ADVERTÈNCIA >>"
echo "Per entrar dins aquest servidor i fer les accions necessàries, necessitaràs la contrasenya de l'usuari amb el que entraràs"
echo "Hauràs d'entrar amb un usuari que tingui permisos d'administrador"
echo "Si no poses un usuari administrador, no es podrà continuar amb les accions correctament"
echo ""

# Primer de tot, demanem la IP amb la que connectarem al servidor.
read -p "Entra la IP del servidor: " server_ip

# Demanem el nom d'usuari amb el que entrar a la màquina servidor
read -p "Entra el nom d'usuari per entrar al servidor: " server_username
sleep 1
clear

# Una vegada tinguem usuari i IP del servidor per accedir-hi, farem el procediment per
# copiar la clau pública.
if ssh-copy-id ${server_username}@${server_ip}
then
	echo ""
	echo "S'ha copiat la clau pública al servidor correctament"
	echo "Està localitzada al directori: /home/${server_username}/.ssh/authorized_keys"
else
	echo ""
	echo "ERROR: Hi ha hagut algun error durant el procés"
fi
echo ""
echo "<< FI DEL PROGRAMA >>"
