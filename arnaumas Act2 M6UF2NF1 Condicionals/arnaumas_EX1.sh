#!/bin/bash

# ENUNCIAT
# Ús de condicionals amb operadors
# Realitza un script que rebi un nombre enter per teclat i digui si és positiu o negatiu,
# comparant-ho amb zero.
# ----------------------------------------------------------------------------------------

# Demanem el nombre a l'usuari, especificant amb el paràmetre -n que és un nombre
echo -n "Entra un nombre enter: "
# El guardem en una variable
read num

# Fem la comparació amb el 0. Si és més gran, ens sortirà que és positiu. En cas contrari, que
# el nombre és negatiu i és un zero
if [[ $num -gt 0 ]]
then
	echo "El nombre és positiu"
else
	echo "El nombre és negatiu o zero"
fi
