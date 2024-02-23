#!/bin/bash

# Aquest script executarà cadascun dels diferents scripts que hi ha dins el directori
# per a totes les eines de comprovacions sobre els servidors.
# -------------------------------------------------------------------------------------------

echo "S'EXECUTARÀ 'crear_copiar_claus_ssh.sh'"
user_option=""
until [[ $user_option == "y" || $user_option == "n" ]]
do
	read -p "Vols continuar? [y/n]: " user_option
	user_option=${user_option,,}
done
if [[ $user_option == "y" ]]
then
	sleep 2
	clear
	./crear_copiar_claus_ssh.sh
fi
clear

echo "S'EXECUTARÀ 'instalacio_paquets.sh'"
user_option=""
until [[ $user_option == "y" || $user_option == "n" ]]
do
	read -p "Vols continuar? [y/n]: " user_option
	user_option=${user_option,,}
done
if [[ $user_option == "y" ]]
then
	sleep 2
	clear
	./instalacio_paquets.sh
fi
clear

echo "S'EXECUTARÀ 'comprovacions.sh'"
sleep 2
clear
./comprovacions.sh
clear

echo "S'EXECUTARÀ 'passar_a_html.sh'"
sleep 2
clear
./passar_a_html.sh
clear

echo "S'EXECUTARÀ 'programar_guardat_logs.sh'"
sleep 2
clear
./programar_guardat_logs.sh
clear

echo "<< FI DEL PROGRAMA >>"
