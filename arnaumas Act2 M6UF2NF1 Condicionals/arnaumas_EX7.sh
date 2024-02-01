#!/bin/bash

# ENUNCIAT
# Crea un script que rebi la ruta d'un fitxer i indiqui si és un directori o fitxer i,
# en el cas que sigui un arxiu, exposa quina és la seva extensió.
# -----------------------------------------------------------------------------------

# Primer, demanem la ruta del fitxer
read -p "Entra la ruta absoluta del fitxer: " file_path

# Comprovem si el fitxer existeix
if [[ -f $file_path ]]
# En cas que existeixi i que sigui un fitxer, mostrem la seva extensió
then
	echo "L'extensió del fitxer és:" ${file_path#*.}
# En cas que no sigui un fitxer, comprovem si és un directori
else
	if [[ -d $file_path ]]
# En cas que sigui un directori, mostrarà aquest resultat
	then
		echo "El que s'ha donat és un directori"
# Si no és un directori ni un fitxer, saltarà un error
	else
		echo "ERROR: No és un fitxer ni tampoc un directori"
	fi
fi
