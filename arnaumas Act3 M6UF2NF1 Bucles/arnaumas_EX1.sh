#!/bin/bash

# ENUNCIAT
# Realitza un script que tregui els comentaris (aquells que comencen per # i arriben fins
# al final de la línia) de l’arxiu. Un cop els comentaris ja estiguin eliminats, demana
# si una paraula/frase existeix dins d’un arxiu. I un cop feta aquesta comprovació,
# demana que s’afegeixi una frase al final de l’arxiu (és obligatori que s’introdueixi).
# -------------------------------------------------------------------------------------------

# Primer demanem l'arxiu a eliminar comentaris
read -p "Entra l'arxiu a treure els comentaris: " file_path

# Comprovem que l'arxiu existeixi, abans que res
if [[ -f $file_path ]]
then
	# ------------ ELIMINAR COMENTARIS  -------------
	# Per poder llegir l'arxiu amb un bucle de For, hem de modificar el separador de les línies
	IFS=$'\n'
	# Aleshores, el llegirem línia per línia
	for line in $(cat $file_path)
	do
		# Cada vegada que trobem un hasthag amb contingut després, esborrarem la línia
		if [[ $line == "#"* ]]
		then
		# A més, escriurem dins un arxiu totes les línies que eliminem
			echo $line >> comentaris_eliminats.txt
			# Fem l'eliminació de la linia, filtrant per el contingut de la mateixa
			sed -i "/$line/d" $file_path
		fi
	done
	# Si no ha saltat cap error, donarem els següents missatges
	echo ""
	echo "S'ha creat l'arxiu comentaris_eliminats.txt amb el contingut que s'ha eliminat de l'arxiu"
	echo "SUCCESS: Els comentaris s'han eliminat correctament"
	echo ""

	# ------------- DEMANAR UNA CADENA PER BUSCAR  -------------
	# Ara demanarem una paraula o frase a buscar dins l'arxiu
	read -p "Entra una paraula o paraules per revisar si hi és a l'arxiu: " string_search
	# Creem una variable per comprovar si aquesta paraula o frase s'ha trobat en algun cop
	found_string=false
	# Tornem a llegir tot l'arxiu sencer per fer la revisió
	for line in $(cat $file_path)
	do
		# Busquem, a cada línia, el que ens han donat
		if [[ $line == *"$string_search"* ]]
		then
			# Si s'ha trobat alguna coincidència, la variable anterior serà true
			found_string=true
			# Mostrem la línia que ho conté
			echo "TROBAT: $line"
			echo ""
		fi
	done
	# Després, hem de mostrar un missatge en cas que no s'hagi trobat alguna coincidència
	if [[ $found_string = false ]]
	then
		echo "NO TROBAT: No s'ha trobat aquesta paraula o frase dins l'arxiu"
		echo ""
	fi

	# ------------- DEMANAR UNA CADENA PER AFEGIR  -------------
	# Iniciem una variable per saber si l'usuari ha introduït contingut correcte
	correct_string=false
	# Fem que, mentre no sigui una entrada correcte (és a dir, sigui true), demani una cadena a l'usuari
	while [[ $correct_string = false ]]
	do
		read -p "Entra una frase a afegir a l'arxiu (obligatori): " add_string
		# Comprovem si l'usuari no ha entrat res meś que espais o està buit totalment
		if [[ $add_string != *[!\ ]* || $add_string == "" ]]
		then
			# L'avisem en cas que no sigui vàlid el que ha escrit
			echo "No has introduït res..."
		else
			# Si el contingut és vàlid, canviem el valor de la variable per sortir del bucle
			correct_string=true
		fi
	done
	# Finalment, quan ja sabem que ha introdüit contingut vàlid, ho afegim a l'arxiu
	echo $add_string >> $file_path
else
	# En cas que no el trobi per qualsevol motiu, donarem un error
	echo "ERROR: No s'ha trobat l'arxiu"
fi
