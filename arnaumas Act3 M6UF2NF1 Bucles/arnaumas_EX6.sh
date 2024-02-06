#!/bin/bash

# ENUNCIAT
# Escriu un script que demani la ruta d’un directori per teclat i ens digui quins permisos té,
# quants arxius i quantes carpetes hi ha a dins i quins són els noms dels arxius i de les carpetes.
# -------------------------------------------------------------------------------------------

# Per aquest exercici he fet servir la comanda tree. En cas de no tenir-la instal·lada al teu
# sistema operatiu, aquest script et fa la instal·lació automàticament. Estan comentades per
# defecte. Perquè s'executi, les hem de descomentar.

#sudo apt-get update &>/dev/null
#sudo apt-get install tree -y &>/dev/null


# Primer, demanarem la ruta del directori a l'usuari, el qual ho farem a través de un bucle
# que no deixi de demanar-ho fins que el trobi al sistema, és a dir: fins que sigui correcte
dir_path=""
read -p "Entra una ruta de directori: " dir_path

# Creem un bucle que ens demani un directori i que es repeteixi fins que el que s'introdueïx
# sigui realment un directori i la ruta sigui correcte
until [[ -d $dir_path ]]
do
	# Farem que si el directori no és correcte, doni un missatge d'error
	echo ""
	echo "ERROR: El directori no existeix o no és un directori"

	# Després tornarem a demanar la ruta del directori
	read -p "Entra una ruta de directori: " dir_path
done
echo ""

# Un cop sortim del bucle on ens assegurem que el path sigui cap a un directori que existeix,
# donarem les dades que ens demanen
# Primer, mostrem els permisos
echo "<< PERMISOS DEL DIRECTORI >>"
ls -ld $dir_path

# Després, mostrem quants arxius i directoris hi ha, amb la comanda tree i filtrant-ho
echo ""
echo "<< NOMBRE D'ARXIUS I DIRECTORIS >>"
tree -L 1 $dir_path | grep "directories"

# Ara mostrem els arxius del directori
echo ""
echo "<< CONTINGUT DEL DIRECTORI >>"
echo "< ARXIUS >"
ls -pla $dir_path | grep -v /

# Per acabar, fem el mateix però amb els directoris
echo ""
echo "< DIRECTORIS >"
ls -la $dir_path | grep "^d"
