#!/bin/bash

# ENUNCIAT
# ÚS DEL BUCLE UNTIL
# Realitza un script que comprovi si el nombre de valors (o paràmetres) introduït és igual a 3.
# En el cas que no sigui així, ha de mostrar per pantalla un missatge d'error.
# -------------------------------------------------------------------------------------------

# Primer, inicialitzarem una variable a 0. Aquesta serà la que tindrà en compte, després
# de la execució del script,  si s'han introduït tres valors
parameters=0

# Aleshores, farem un bucle el qual no deixi de repetir-se (o directament no entri) mentre el
# nombre de paràmetres introduïts no sigui de tres.
until [[ $# == 3 || ${#parameters[@]} == 3 ]]
do
	# Si no hi ha tres paràmetres, repetirem la pregunta dels valors
	echo ""
	echo "ERROR: No has introduït tres valors, torna a intentar-ho"
	# El que ens posi l'usuari en aquest apartat, ho guardarem com un array. Això ens permetrà
	# després poder comptar el nombre de valors que hi ha dins d'aquesta per, al final,
	# tornar a calcular el nombre de paràmetres introduïts.
	read -a parameters
done
# Si hem arribat aquí és perquè hem introudït tres paràmetres, no hi ha altre forma. Per tant,
# mostrarem el missatge de que el programa s'ha executat correctament per acabar.
echo ""
echo "SUCCESS: Has introduït tres valors, ben fet"
