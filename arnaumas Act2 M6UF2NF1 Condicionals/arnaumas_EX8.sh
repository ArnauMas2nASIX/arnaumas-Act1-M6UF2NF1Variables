#!/bin/bash

# ENUNCIAT
# Realitza un script que rebi la ruta d'un directori a comprimir i el nom de l’arxiu
# tarball resultant (el que vulgueu).
# -------------------------------------------------------------------------------------------

# Primer, demanem el directori a comprimir
read -p "Entra la ruta absoluta d'un directori per a comprimir: " dir_path

# Comprovem si el que s'ha donat és realment un directori
if [[ -d $dir_path ]]
# Aleshores, demanem el nom que se li vol donar a l'arxiu comprimit que quedarà
then
	read -p "Entra el nom que vulguis donar a l'arxiu comprimit: " tar_name
# Finalment, fem la compressió del directori en mode silenciós afegint la extensió .tar
	tar -cvf ${tar_name}.tar $dir_path &> /dev/null
	echo "S'ha comprimit el directori correctament amb nom:" ${tar_name}.tar
# En cas que el que s'hagi entrat sigui diferent a un directori, no existeixi o no sigui correcte,
# mostrarà un missatge d'error
else
	echo "ERROR: El que s'ha donat no és un directori, no existeix o no és correcte la seva ruta"
fi
