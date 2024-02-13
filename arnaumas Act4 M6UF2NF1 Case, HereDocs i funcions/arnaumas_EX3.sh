#!/bin/bash

# ENUNCIAT
# ÚS DEL HEREDOCS
# L’ús del Heredoc és una de les formes més convenients i fàcils d'executar múltiples comandes
# en un sistema remot a través de SSH. Realitza un script que demostri aquesta afirmació.
# -------------------------------------------------------------------------------------------

# Per poder realitzar aquest exercici hem fet una clonació d'una màquina virtual. Aquesta conté
# una IP dinàmica a través del DHCP del centre i té un sol adaptador en mode pont. Com que la IP
# pot variar depenent de on i quan ho executem, posarem que s'introdueixi la IP de la màquina
# per terminal per fer-ho més interactiu.
# Abans de res però, direm a l'usuari per a què serveix aquest programa.
echo "Aquest script té la funció de mostrar el funcionament de les comandes 'HereDoc'"
echo "Es farà una connexió remota a alguna màquina amb el paquet 'openssh-server'"
echo "A continuació, es demanaran els paràmetres necessaris per establir la connexió"
echo "----------------------------------------------------------------------------------"

# Aleshores, demanarem el que necessitem per realitzar la connexió.
read -p "Entra la IP de la màquina a connectar: " remote_machine_ip
read -p "Entra el nom d'usuari de la màquina remota: " remote_machine_user

# Una vegada tinguem la IP de la màquina a la que volem connectar-nos guardada, farem la connexió
# via SSH amb l'usuari que també ens han donat. Hem de tenir en compte que ens demanarà la
# contrasenya després de fer la connexió i la hem de saber segons l'usuari que posem.
clear
echo "ESTABLINT CONNEXIÓ..."
echo ""
sleep 2

# Mostrarem, dins la màquina remota, alguns valors que demostren que hem fet la connexió
# correctament, afegint el \ en les variables perquè les doni de la màquina remota i no local.
ssh ${remote_machine_user}@${remote_machine_ip} << END
	echo "Estem dins la màquina virtual remota!"
	echo ""
	echo "El hostname d'aquesta màquina és: \$HOSTNAME"
	echo "El directori de treball actual és: \$PWD"
	echo "El teu usuari és: \$USER"
	echo "El teu directori home és: \$HOME"
	echo "El shell actual és: \$SHELL"
END
