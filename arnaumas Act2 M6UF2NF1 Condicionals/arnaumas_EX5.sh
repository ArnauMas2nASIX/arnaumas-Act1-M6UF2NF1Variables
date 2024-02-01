#!/bin/bash

# ENUNCIAT
# Escriu un script que rebi la ruta d'un fitxer i indiqui si existeix.
# -------------------------------------------------------------------------

# Primer demanem la ruta del fitxer
read -p "Escriu la ruta absoluta del fitxer: " file_path

# Després, amb el paràmetre -e comprovem si existeix
if [[ -e $file_path ]]
# En cas que existeixi, ens dirà que aquest fitxer existeix
then
	echo "El fitxer existeix"
else
# Si no l'han escrit bé, la seva ruta no és correcte o hi ha qualsevol errada, ens donarà error
	echo "ERROR: El fitxer no existeix o no és correcte"
fi
