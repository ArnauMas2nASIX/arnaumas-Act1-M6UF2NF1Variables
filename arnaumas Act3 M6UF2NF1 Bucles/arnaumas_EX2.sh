#!/bin/bash

# ENUNCIAT
# Realitza un script que rebi una cadena de nombres enters per teclat i compti
# quants són zero.
# -------------------------------------------------------------------------------------------

# Primer, demanarem la cadena de nombres enters a l'usuari
read -p "Entra diferents nombres enters: " numbers

# Iniciem una variable que comptarà quantes vegades surt el zero
occurrences_of_zero=0

# Aleshores, llegirem tota la cadena, caràcter per caràcter
for character in $numbers
do
	# Filtrarem per buscar els zeros (tenint en compte que volem veure si és un zero aïllat, no si un nombre conté el zero
	if [[ $character == "0" ]]
	then
		# Cada vegada que hi hagi un zero, sumarem 1 a la variable iniciada abans
		((occurrences_of_zero++))
	fi
done
# Finalment, direm a l'usuari quantes vegades surt un zero a la cadena que ens ha donat
echo "Has introduït un zero aquest número de vegades: $occurrences_of_zero"
