#!/bin/bash

# ENUNCIAT
# Realitza un script al que se li passarà un nom d’usuari que, amb l’inici de la seva execució,
# comprovi si s’ha passat un nom d’usuari per paràmetres i que, a continuació, ofereix tres
# opcions: Ofereix comprovar si  amb drets d’administrador, si l’usuari existeix i si la ruta
# del directori personal és vàlida (o existeix). No cal que definir funcions.
# -------------------------------------------------------------------------------------------

# NOTA IMPORTANT: Aquest programa no podrà funcionar correctament si l'usuari que executa
# el codi no té permisos d'administrador, ja que hem de llegir fitxers com /etc/sudoers
# i /etc/group. Si has de donar permisos, fes-ho abans d'executar-lo.

# Crearem una variable de tipus boolean que ens digui si hem de seguir amb el programa o
# acabar. Aquesta variable només es posarà a true si l'usuari entra un sol paràmetre.
correct_input=false

# El case que definim ara modificarà el valor d'aquesta variable si és correcte.
case $# in
	1)
		# En cas que hagi introduït un sol paràmetre, posarem la variable conforme
		# l'entrada és correcte en valor true.
		correct_input=true ;;
	0)
		# Si no ha introduit res per paràmetre, avisarem al usuari perquè sàpiga que ha
		# d'entrar un username per paràmetre en la mateixa execució del script i com
		# ho ha de fer.
		echo "ERROR: No has introduït cap paràmetre"
		echo "Per fer servir aquest programa necessites entrar el nom d'un usuari per paràmetre."
		echo "Exemple: ./programa.sh [nom usuari]" ;;
	*)
		# Si ha entrat qualsevol altre nombre de paràmetres (si no és 0 o 1 han de ser més)
		# avisem sobre l'error i donem el mateix missatge amb instruccions que abans.
		echo "ERROR: Has entrat masses paràmetres"
		echo "Per fer servir aquest programa necessites entrar el nom d'un usuari per paràmetre."
		echo "Exemple: ./programa.sh [nom usuari]" ;;
esac

# Aleshores, depenent de si tenim aquesta variable en true o false, executarem el codi corresponent
echo ""
if [[ $correct_input = true ]]
then
	# Guardem el nom d'usuari en una variable més còmode
	username="$1"

	# Si l'entrada és correcte, donarem les tres opcions al usuari
	echo "SUCCESS: Entrada correcte"
	echo ""
	echo "--------------------------------------------------"
	echo "1- Comprovar permisos d'administrador de l'usuari"
	echo "2- Comprovar si l'usuari existeix"
	echo "3- Comprovar si té directori /home"
	echo "--------------------------------------------------"
	# Una vegada mostrem les tres opcions donarem la possibilitat d'escollir
	read -p "Selecciona una de les opcions: " option

	# Depenent del que el usuari decideixi executarem l'ordre corresponent
	echo ""
	case $option in
		1)
			# Per mirar si un usuari té permisos d'administrador, hem de revisar el
			# fitxer sudoers i a més, revisar els membres dels grups admin i sudo, els
			# quals també tenen permisos d'administrador.
			# Iniciarem una variable que només posarem a true si l'usuari té permisos
			# d'administrador segons les comprovacions que fem.
			user_admin=false

			# Aleshores, realitzem les comprovacions.
			if sudo cat /etc/sudoers | grep "$username" &> /dev/null
			then
				# Si de la comanda anterior rebem alguna cosa per pantalla, significa
				# que l'usuari donat està dins del fitxer sudoers i, per tant,
				# té permisos d'administrador, per lo que posem la variable a true.
				user_admin=true
			fi

			# Llegim també els grups de l'usuari que ens han donat
			for line in $((groups $username) &> /dev/null)
			do
				# Si en alguna de les línies apareix el grup lpadmin o sudo, que són
				# els grups de permisos d'administrador, aleshores significa que
				# l'usuari té aquests permisos. Per tant, posem la variable a true.
				if [[ $line == "lpadmin" || $line == "sudo" ]]
				then
					user_admin=true
				fi
			done
			# Depenent del valor de la variable, donem una resposta o altra
			case $user_admin in
				true)
					echo "L'usuari [$username] SÍ té permisos d'administrador" ;;
				false)
					echo "L'usuari [$username] NO té permisos d'administrador" ;;
			esac ;;
		2)
			# Iniciem la variable de true/false per saber què fer després
			user_exists=false

			# En aquesta opció comprovarem si aquest usuari existeix. Per fer-ho
			# és tan simple com filtrar el fitxer /etc/passwd i veure si aquest
			# usuari correspon a algun primer valor d'alguna línia.
			while IFS=: read -r f1 f2 f3 f4 f5 f6 f7
			do
				if [[ $f1 == $username ]]
				then
					# Si troba aquest usuari, posarem la variable a true
					user_exists=true
				fi
			done < "/etc/passwd"
			# Depenent del valor de la variable, donem una resposta o altra
			if [[ $user_exists = true ]]
			then
				echo "L'usuari [$username] SÍ existeix"
			else
				echo "L'usuari [$username] NO existeix"
			fi ;;
		3)
			# Per veure si el seu directori /home existeix, llistarem el directori /home
			# i buscarem algun directori que tingui el nom de l'usuari
			if (ls -la /home | grep "$username") &> /dev/null
			then
				# Si existeix, ho direm per pantalla
				echo "El directori /home de l'usuari [$username] SÍ existeix"
			else
				# En cas que no existeixi, li direm a l'usuari
				echo "El directori /home de l'usuari [$username] NO existeix"

			fi ;;
		*)
			# En cas que no entri cap de les opcions possibles, donarem un missatge d'error
			echo "ERROR: No és una opció vàlida" ;;
	esac
fi
