#!/bin/bash

# ENUNCIAT
# Realitza un script que rebi un nombre enter per teclat i digui si és zero.
# --------------------------------------------------------------------------------

# Demanem el valor a l'usuari
echo -n "Entra un nombre: "
# Guardem el valor en una variable
read num

# Comparem amb el nombre zero i diem si ho és o no
if [[ $num -eq 0 ]]
then
	echo "El nombre és un zero"
else
	echo "El nombre no és un zero"
fi
