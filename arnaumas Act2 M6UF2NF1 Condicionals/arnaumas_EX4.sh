#!/bin/bash

# ENUNCIAT
# Ús de condicionals amb pas de paràmetres
# Escriu un script que comprovi si el nombre de paràmetres introduït és igual a 3.
# En el cas que no sigui així, ha de mostrar per pantalla un missatge d'error.
# -------------------------------------------------------------------------------------

# Guardem el nombre de paràmetres introduïts
NUM_PARAM=$#

# Fem la comparació per veure si s'han introduït tres paràmetres
# En cas que els hagi introduït, donarà el primer resultat. En cas contrari, el segon (else)
if [[ $NUM_PARAM -eq 3 ]]
then
	echo "El nombre de paràmetres és correcte (és 3)"
else
	echo "ERROR: No has introduït tres paràmetres"
fi
