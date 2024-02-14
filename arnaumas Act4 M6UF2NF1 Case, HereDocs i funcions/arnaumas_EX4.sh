#!/bin/bash

# ENUNCIAT
# Ens han passat aquest script en què, malauradament, no hi ha cap mena de comentari afegit
# que expliqui què fa cadascuna de les funcions incloses. Analitza’l, doncs, i afegeix els
# comentaris que siguin necessaris.
# -------------------------------------------------------------------------------------------

# Posem aquesta variable amb valor 7
USG_ERR=7

# Creem una funció anomenada max_dos. Llegirà el primer i segon paràmetres que s'introdueixin.
max_dos ( ) {
# En cas que siguin els dos paràmetres iguals, dirà per pantalla que són Iguals i sortirà de
# la funció
	if [ "$1" -eq "$2" ] ; then
		echo 'Iguals'
		exit 0
# En cas que el primer paràmetre sigui major que el segon, el guardarà dins la variable ret_val.
	elif [ "$1" -gt "$2" ] ; then
		ret_val=$1
# Com a últim cas, on entrarà només si el valor del segon paràmetre és més gran que el del primer,
# guardarà el segon dins la variable ret_val.
	else
		ret_val=$2
	fi
}

# Aquí es crea una nova funció anomenada err_str. Aquesta saltarà si no hem introduït algun
# dels dos paràmetres durant l'execució del script.
err_str ( ) {
	echo "Ús: $0 <numero1>  <numero2>"
	exit $USG_ERR
}

# Guarda els dos valors que nosaltres entrem per paràmetre cadascun en una variable.
NUM_1=$1
NUM_2=$2

# En cas que el nombre de paràmetres no sigui dos, executarà la funció err_str que ens retorna
# un missatge per pantalla d'error.
if [ $# -ne 2 ] ; then
	err_str
# En el cas de que el primer nombre sigui un número vàlid, entrarà en aquest apartat
elif [ `expr $NUM_1 : '[0-9]*'` -eq ${#NUM_1} ] ; then
	# Si el segon nombre per paràmetre també és un nombre vàlid, seguirà el programa
	if [ `expr $NUM_2 : '[0-9]*'` -eq ${#NUM_2} ] ; then
		# Es farà el càlcul a partir de la funció max_dos de quin dels dos nombres
		# és més gran. El resultat es guardarà en la variable que aquesta funció
		# retorna i es mostrarà per pantalla.
		max_dos $NUM_1 $NUM_2
		echo $ret_val
	else
		# En cas que el segon paràmetre no sigui un nombre, saltarà l'error.
		err_str
	fi
else
	# En cas que el primer paràmetre no sigui un nombre, saltarà l'error.
	err_str
fi

exit 0
