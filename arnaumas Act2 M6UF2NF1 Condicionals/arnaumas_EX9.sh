#!/bin/bash

# ENUNCIAT
# Fes un script que compti quants cops s’han establert connexions d’un determinat protocol a
# partir d’un arxiu TXT/CSV de captures del programari Wireshark passat per paràmetres.
# ---------------------------------------------------------------------------------------------

# Primer, demanem la ruta de l'arxiu a carregar
read -p "Entra la ruta absoluta de l'arxiu de Wireshark: " w_file

# Iniciem una variable per comptar el nombre de vegades que ha sortit el protocol

TIMES_SHOWN=0

# Després, comprovem si realment és un arxiu. En cas que no ho sigui, saltarà un error
if [[ -f $w_file ]]
then
	# Fem que el protocol que ens entri es guardi en majúscules, per si de cas
	declare -u protocol
	# Posteriorment, demanem el protocol
	read -p "Entra el protocol que vols buscar: " protocol

	# Llegim el fitxer línia per línia per comptar el nombre de vegades que surt el protocol
	while read -r line
	do
		# Cada vegada que surti el protocol a la línia, sumarem 1 a la variable
		if [[ $line == *"$protocol"* ]]
		then
			((TIMES_SHOWN++))
		fi
	# Al final del bucle, passem per paràmetre l'arxiu que ens han donat
	done < $w_file
	echo "El nombre de vegades que ha sortit el protocol $protocol és: $TIMES_SHOWN"
else
	echo "ERROR: El que s'ha donat no és un arxiu o la ruta no és correcte"
fi
