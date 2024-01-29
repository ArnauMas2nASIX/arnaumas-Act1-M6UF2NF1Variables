#!/bin/bash

# ENUNCIAT
# Ús de condicionals amb operadors
# Realitza un script que rebi un nombre enter per teclat i digui si és positiu o negatiu,
# comparant-ho amb zero.
# ----------------------------------------------------------------------------------------

# Demanem el nombre a l'usuari
echo -n "Entra un nombre enter: "
read num
if [[ $num -gt 0 ]]
then
	echo "El nombre és positiu"
else
	echo "El nombre és negatiu o zero"
fi
