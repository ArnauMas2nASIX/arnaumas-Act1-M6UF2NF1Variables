#!/bin/bash

# ENUNCIAT
# Crea un script que comprovi si hi ha connexió amb la pàgina web de l'institut per Internet.
# Mentre no hi hagi connexió es mostrarà un missatge advertint a l’usuari que no hi ha
# connexió a Internet i esperarà 5 segons per tornar a comprovar si hi ha connexió.
# Un cop ja hi hagi connexió, l’script obrirà el navegador Firefox (o el que tu prefereixis)
# amb la pàgina principal de l’Institut.
# -------------------------------------------------------------------------------------------

# Aprofitarem una facilitat que ens donen les comandes de prova de connexió, que és que
# si donen un resultat operatiu, tenim un valor equivalent al true i, en cas de fallar la
# connexió, ens retornen false. Per tant, evalurem les diferents proves a través d'això.
# Totes les proves es faran amb un temps intermig de 5 segons en conjunt, és a dir:
# cada 5 segons, si no tenim connexió correcte, tornarem a fer les proves.
# Cada prova constarà d'una variable pròpia i només donarem el resultat per positiu
# si totes elles estan a true. Si una de sola està a false i per tant hi ha hagut
# algun error de connexió, ho donarem per erroni.
conn_success=false
conn_test1=false
conn_test2=false
conn_test3=false
while [[ $conn_success = false ]]
do
	# --------------- PROVA DE CONNEXIÓ 1 ---------------
	if nc -zw1 frontal.ies-sabadell.cat 443 &>/dev/null
	then
		conn_test1=true
		echo "TEST 1 = SUCCESS"
	else
		echo "TEST 1 = FAILED"
	fi
	# --------------- PROVA DE CONNEXIÓ 2 ---------------
	if ping frontal.ies-sabadell.cat -c 2 &>/dev/null
	then
		conn_test2=true
		echo "TEST 2 = SUCCESS"
	else
		echo "TEST 2 = FAILED"
	fi

	# --------------- PROVA DE CONNEXIÓ 3 ---------------
	if nslookup frontal.ies-sabadell.cat &>/dev/null
	then
		conn_test3=true
		echo "TEST 3 = SUCCESS"
	else
		echo "TEST 3 = FAILED"
	fi

	# --------------- CONFIRMACIÓ DE CONNEXIÓ ---------------
	# En cas que totes les proves hagin sigut concluents, donarem un missatge per pantalla
	# i posarem la variable conn_success en valor true.
	# Si en algun cas ha fallat alguna, ho avisarem per pantalla i tornarem a provar després
	# de que hagin passat 5 segons.
	if [[ $conn_test1 = true && $conn_test2 = true && $conn_test3 = true ]]
	then
		echo "CONNEXIÓ ESTABLERTA CORRECTAMENT"
		echo ""
		conn_success=true
	else
		# Donem l'espera de 5 segons informant a al usuari
		echo "ERROR DE CONNEXIÓ"
		echo "REANUDANT PROVES EN 5 SEGONS..."
		sleep 1
		echo "REANUDANT PROVES EN 4 SEGONS..."
		sleep 1
		echo "REANUDANT PROVES EN 3 SEGONS..."
		sleep 1
		echo "REANUDANT PROVES EN 2 SEGONS..."
		sleep 1
		echo "REANUDANT PROVES EN 1 SEGONS..."
		sleep 1
		echo "REANUDANT PROVES..."
		echo ""
	fi
done

# A partir d'aquest punt només podem arribar si els tests han funcionat correctament.
# Per tant, avisarem al usuari que s'obrirà el navegador de Firefox. Donarem
# un temps de marge de 5 segons de nou, per si l'usuari no vol fer-ho.

echo "OBRINT WEB DE L'INSTITUT SABADELL (frontal.ies-sabadell.cat)..."
sleep 5

# Aleshores, obrirem el navegador la pàgina de l'institut
# La comanda obrirà la URL que escrivim a través de Firefox i no donarà res per pantalla,
# a més de que ho farà en background i no farà falta mantenir la terminal oberta
# si no volem que es tanqui Firefox.
firefox frontal.ies-sabadell.cat &>/dev/null
