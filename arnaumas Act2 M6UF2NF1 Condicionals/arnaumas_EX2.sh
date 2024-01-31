#!/bin/bash

# ENUNCIAT
# Fes un script que rebi un nombre enter per teclat i digui si és negatiu.
# ---------------------------------------------------------------------------

# Demanem el nombre a l'usuari. Com que diu que sigui nombre enter, no tindrem
# en compte nombres decimals, donem per fet que no els posaran
echo -n "Entra un nombre: "
# Guardem el que ens ha donat en una variable
read num

# El número que tenim, el comparem amb el 0, per saber si és negatiu
if [[ $num -gt 0 ]]
then
	echo "El nombre no és negatiu"
else
	echo "El nombre és negatiu"
fi
