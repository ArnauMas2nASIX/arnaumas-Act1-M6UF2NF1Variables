#!/bin/bash

# ENUNCIAT
# PREPARAT? VAIG NÉIXER PREPARAT...
# Elabora un script per jugar al joc de pedra, paper o tisores contra la màquina.
# L’usuari ha de tenir la possibilitat de tornar a jugar tants cops com vulgui.
# -------------------------------------------------------------------------------------------

# Per poder jugar a pedra paper o tisores, hem de tenir en compte que la màquina ha d'escollir
# de manera aleatòria una de les opcions. Per fer-ho, necessitarem utilitzar una variable global
# anomenada RANDOM, la qual ens seleccionarà un número aleatorientre 0 i 32767.
# A partir d'aquest nombre, farem una sèrie de operacions que ens permetran agafar un índex
# que existeixi de l'array que fem amb les opcions del joc (per tant, entre 0 i 2), el qual
# definirà el que escollirà la màquina. Aleshores, podem dependre d'un element aleatori, gràcies
# a la variable RANDOM

# Tot el contingut del programa es repetirà fins que l'usuari no indiqui que vol parar de jugar.
# Per tant, crearem un bucle que depengui d'una variable que contingui si es segueix o no, el qual
# modificarem a cada volta tornant a preguntar si es vol jugar de nou.
keep_playing=true
until [[ $keep_playing = false ]]
do
	# -------------------- ELECCIÓ DE LA MÀQUINA ---------------------
	# Primer, creem les opcions que pot treure la màquina en una array
	rock_paper_scissors=("pedra" "paper" "tisores")

	# Fem les accions necessàries per a la generació de la resposta aleatòria
	size=${#rock_paper_scissors[@]}
	choice=$(($RANDOM % $size))
	# La elecció que aconseguim, la guardem en una variable per no perdre-ho
	IA_choice=${rock_paper_scissors[$choice]}

	# -------------------- ELECCIÓ DEL JUGADOR ---------------------
	# A partir d'aquí, ja tenim la opció de jugada de la màquina. Per tant, només ens queda
	# preguntar a l'usuari la seva i validar dita opció perquè sigui correcte.
	# Començarem preguntant la opció a l'usuari. Iniciarem també una variable de confirmació.

	valid_choice=false
	read -p "Quina opció jugues? [pedra/paper/tisores]: " player_choice
	player_choice=${player_choice,,}

	# Procedim a evaluar la opció que ha jugat l'usuari. En cas que no sigui correcte,
	# la preguntarem de manera seguida fins que posi una jugada correcte.
	if [[ $player_choice != "pedra" && $player_choice != "paper" && $player_choice != "tisores" ]]
	then
		# El bucle s'executarà fins que la variable es posi a true. A cada volta, evaluarà
		# que la opció sigui una de les tres correctes, independentment de que el que hagin
		# posat estigui en majúscules o minúscules, ja que ho transformem tot a minúscules.
		until [[ $valid_choice = true ]]
		do
			echo ""
			echo "ERROR: La opció no és vàlida"
			read -p "Quina opció jugues? [pedra/paper/tisores]: " player_choice
			player_choice=${player_choice,,}
			if [[ $player_choice == "pedra" || $player_choice == "paper" || $player_choice == "tisores" ]]
			then
				valid_choice=true
			fi
		done
	fi

	# -------------------- RESULTAT DE LA JUGADA ---------------------
	# Ara que ja tenim l'elecció que han fet usuari i màquina, depenent del que tingui cadascun,
	# guanyarà un o l'altre.
	# Mostrem el que han escollit el jugador i la màquina
	echo ""
	echo "La màquina ha escollit: $IA_choice"
	echo "El jugador ha escollit: $player_choice"
	echo ""
	# Aleshores, evaluem el resultat per veure qui guanya o si hi ha empat
	# Depenent de les eleccions, s'executarà una part del codi corresponent,
	# donant el missatge del resultat corresponent
	echo "<< RESULTAT DE LA JUGADA >>"
	if [[ ($IA_choice == "pedra" && $player_choice == "tisores") || ($IA_choice == "paper" && $player_choice == "pedra") || ($IA_choice == "tisores" && $player_choice == "paper") ]]
	then
		echo "Ha guanyat la màquina! Has perdut!"
	elif [[ $IA_choice == $player_choice ]]
	then
		echo "Empat!"
	else
		echo "Has guanyat! Enhorabona!"
	fi

	# -------------------- REPETIR JOC ---------------------
	# Preguntarem, al final de cada jugada, si vol seguir jugant, al jugador
	echo ""
	read -p "Vols tornar a jugar? [si/no]: " player_keep_playing
	player_keep_playing=${player_keep_playing,,}
	# En cas que no ens entri una opció vàlida (podrà entrar-ho combinant majúscules
	# i minúscules ja que tornem a convertir l'entrada a tot minúscules per evaluar-la)
	# seguirà preguntant-li el programa
	until [[ $player_keep_playing == "si" || $player_keep_playing == "no" ]]
	do
		echo ""
		echo "ERROR: No has donat una opció vàlida"
		read -p "Vols tornar a jugar? [si/no]: " player_keep_playing
		player_keep_playing=${player_keep_playing,,}
	done
	# Quan ja tinguem una opció vàlida, l'evaluarem per saber si hem de tornar a executar
	# el programa del bucle o no. Si marca que no, canviarem la variable que hem creat
	# al principi per sortir-ne. Si ens diu que sí vol seguir jugant, no farem res, per tant
	# la variable seguirà sent true i el bucle tornarà a executar-se.
	if [[ $player_keep_playing == "no" ]]
	then
		keep_playing=false
	fi
	# Perquè quedi més neta la pantalla durant les diferents partides, executarem una
	# neteja de la terminal a cada ronda
	clear
done
# Quan el jugador s'hagi cansat de jugar, li agraïrem per haver dedicat el seu temps
# a fer unes partides amb nosaltres.
echo ""
echo "Gràcies per jugar!"
