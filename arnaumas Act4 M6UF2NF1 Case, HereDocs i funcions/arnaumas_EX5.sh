#!/bin/bash

# ENUNCIAT
# PREPARAT? VAIG NÉIXER PREPARAT...
# Escriu un script que comprovi l'estat d’un ventall de servidors remots, que es comprovi
# l'estat de cada servidor i que es registri el resultat en un arxiu. S’ha
# d'optimitzar el contingut de l’script a partir de l’ús de funcions. Opcionalment,
# pots usar Here-Docs i el Case.
# -------------------------------------------------------------------------------------------

# Gestionarem un fitxer que recollirà les dades sobre les proves dels servidor
create_file () {
	# Si no es troba aquest fitxer en el directori, simplement es crearà
	if [[ ! -f server_tests.txt ]]
	then
		touch server_tests.txt
	else
		# En cas que l'arxiu ja existeixi, li comunicarem al usuari
		echo ""
		option=""
		echo "Ja existeix un arxiu [server_tests.txt]"
		# Li donarem la opció de crear-lo de nou i tenir-lo net o seguir escrivint
		# en el fitxer sense esborrar les dades que hi havien abans.
		# Ens assegurarem també que ens dona una entrada vàlida.
		until [[ $option == "y" || $option == "n" ]]
		do
			read -p "Vols sobreescriure'l? [y/n]: " option
			option=${option,,}
			if [[ $option == "y" ]]
			then
				rm server_tests.txt
				touch server_tests.txt
				echo "S'ha buidat el contingut de l'arxiu [server_tests.txt]"
			elif [[ $option == "n" ]]
			then
				echo "S'introduiran les noves dades a l'arxiu [server_tests.txt] ja existent"
				echo "--------------------------------------------------------------------------" >> server_tests.txt
				echo "" >> server_tests.txt
			else
				echo "ERROR: Entrada no vàlida, respon sí o no"
			fi
		done
		# Al acabar la gestió del fitxer, netejarem la pantalla.
		sleep 3
		clear
	fi
}

# Farem una funció que executi les comprovacions del servidor donat. És possible que a la part
# de l'escaneig de ports no faci res i es pengi, però ja avisem al usuari que si passa massa temps
# sense fer res, faci un CTRL+C
check_server () {
	# A cada prova que realitzem, netejarem la pantalla per més comoditat i espererem un temps
	# abans d'executar la següent comanda perquè es tingui temps de visualitzar-la.
	# Totes les dades que surtin per pantalla seran també guardades dins el fitxer que
	# anteriorment hem creat. Estaran separades perquè visualment sigui més còmode de
	# llegir.

	# Part de la prova de pings
	echo "<< EXECUTANT PROVES DE PING >>"
	ping -c 4 $1 >> server_tests.txt
	if ping -c 4 $1
	then
		echo ""
		echo "SUCCESS: PING AL SERVIDOR"
	else
		echo ""
		echo "FAILED: PING AL SERVIDOR"
	fi
	sleep 3
	clear

	# Part de les proves de nslookup
	echo "<< EXECUTANT PROVES DE NSLOOKUP >>"
	nslookup $1 >> server_tests.txt
	sleep 1
	if nslookup $1
	then
		echo ""
		echo "SUCCESS: RESOLUCIÓ DNS AMB EL SERVIDOR"
	else
		echo ""
		echo "FAILED: RESOLUCIÓ DNS AMB EL SERVIDOR"
	fi
	sleep 3
	clear

	# Part de les proves de comanda dig
	echo "<< EXECUTANT PROVES ADDICIONALS DE DNS AMB 'dig' >>"
	dig $1 >> server_tests.txt
	sleep 1
	if dig $1
	then
		echo ""
		echo "SUCCESS: COMANDA DIG COMPLETADA"
	else
		echo ""
		echo "FAILED: COMANDA DIG ERRÒNIA"
	fi
	sleep 3
	clear

	# Part de les proves de connexió a ports
	echo "<< EXECUTANT PROVES DE CONNEXIÓ DE PORTS >>"
	echo "Espera uns segons... (si passa massa estona, si us plau pressiona CTRL+C per interrompre l'execució)"
	echo ""
	(nc -vz $1 1-1023 > ports.txt 2>&1) &>/dev/null
	cat ports.txt | grep "succeeded"
	cat ports.txt | grep "succeeded" >> server_tests.txt
	rm ports.txt
	echo ""
	echo "SUCCESS: PROVES DE PORTS FINALITZADES"
	sleep 3
	clear
}

# ------------------------------- CODI PRINCIPAL ----------------------------------
# El codi principal constarà d'informació per al usuari i una execució de les diferents funcions
# que hem establert abans. En aquestes es tindrà en compte el servidor que es vol evaluar amb les proves.
# Dins l'arxiu que es crea amb els servidors que el usuari vol evaluar, llegirem cada cas un per un
# i executarem les proves corresponents.
echo " << PROVES DE CONNEXIÓ A SERVIDORS >>"
echo "Aquest codi està preparat per realitzar diferents proves a diferents servidors"
echo "És possible que en algun moment l'script es pari perquè algun servidor no respongui peticions"
echo "Si és el cas, si us plau para l'script amb CTRL+C per sortir-hi i tornar a provar-ho"
echo ""
echo "Si us plau, entra un per un els servidors dels que vols fer proves"
echo "Quan hagis acabat, si us plau escriu la paraula [end] en minúscules"
server=""
# Fins que l'usuari no escrigui [end] se seguiran demanant servidors per fer proves.
until [[ $server == "end" ]]
do
	read -p "Introdueix el servidor a inspeccionar: " server
	if [[ $server != "end" ]]
	then
		# Si introdueix un servidor vàlid, l'escriurem dins un fitxer temporal.
		echo "$server" >> servers_to_test.txt
	fi
done
# Farem la creació del fitxer que recollirà les dades amb la funció que hem fet abans.
create_file

# A partir del fitxer que hem creat anteriorment amb el servidors a provar, anirem fent les proves
# d'un per un.
echo "INICI DE LES PROVES ALS SERVIDORS"
while read -r server
do
	# Per cada servidor del qual fem una prova, l'especificarem al fitxer. Això farà que sigui
	# millor llegible per l'usuari i que estiguin separats debidament.
	echo "[[[ PROVES DEL SERVIDOR $server ]]]" >> server_tests.txt
	# S'executaran totes les proves que hi ha dins la funció sobre aquell servidor.
	check_server $server
	# Quan acabi de fer les proves, deixarà dues línies en blanc per separar-lo del següent.
	echo "" >> server_tests.txt
	echo "" >> server_tests.txt
done < servers_to_test.txt

# Una vegada hem acabat, esborrarem el fitxer temporal que recollia els noms dels servidors.
rm servers_to_test.txt

# Finalment, direm a l'usuari que el programa ha acabat.
echo "La recollida de dades ha finalitzat correctament."

# Per saber les dades recollides, en qualsevol moment, l'usuari podrà veure el fitxer que
# hem creat amb dites dades [server_tests.txt] el qual, si torna a executar el programa,
# pot decidir si sobreescriure'l o deixar-lo com està i afegir dades noves més abaix.
