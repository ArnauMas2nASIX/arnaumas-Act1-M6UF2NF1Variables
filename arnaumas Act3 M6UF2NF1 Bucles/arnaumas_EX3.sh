#!/bin/bash

# ENUNCIAT
# ÚS DEL BUCLE WHILE
# Realitza un script que llegeixi paraules i les guardi en un arxiu fins que s’escrigui
# “:>”. No oblidis que has de comprovar que hi ha un arxiu on emmagatzemar les paraules.
# -------------------------------------------------------------------------------------------

# Primer de tot, comprovem si existeix un arxiu on escriurem el contingut
if [[ ! -f fitxer_EX3_amb_strings.txt ]]
then
	# Si no existeix, el creem nosaltres
	touch fitxer_EX3_amb_strings.txt
else
	# En cas que existeixi (per haver-ho executat anteriorment), preguntarem a l'usuari
	# si el vol esborrar o vol afegir el contingut al que ja existeix sense esborrar res
	echo "El fitxer on s'escriurà el contingut ja existeix, el vols eliminar i crear un de nou?"
	read -p "[Y]/N: " user_decision
	# Si no s'ha introduït una resposta vàlida, tornarà a preguntar-ho en bucle
	while [[ $user_decision != "" && $user_decision != "Y" && $user_decision != "y" && $user_decision != "N" && $user_decision != "n" ]]
	do
		echo "ERROR: Si us plau, introdueix Y/y o N/n"
		read -p "[Y]/N: " user_decision
	done
	# Quan ja hi hagi una entrada vàlida per al script, l'evaluarem i actuarem depenent del que hagi dit el usuari
	if [[ $user_decision == "Y" || $user_decision == "y" || $user_decision == "" ]]
	then
		# Si la resposta és SÍ, esborrem l'arxiu i el tornem a crear
		rm fitxer_EX3_amb_strings.txt
		touch fitxer_EX3_amb_strings.txt
		echo "S'ha eliminat i tornat a crear el fitxer 'fitxer_EX3_amb_strings.txt'"
	else
		# Si la resposta és NO, no fem cap actuació
		echo "El contingut a continuació s'afegirà al fitxer sense esborrar el que ja hi ha"
	fi
fi
echo ""

# Farem un bucle que comprovi el que ens introdueix l'usuari i que, mentre no sigui
# la combinació de caràcters :> , no pari de demanar-ne cada vegada
user_string=""
while [[ $user_string != ":>" ]]
do
	# Demanem el text a introduïr al fitxer
	read -p "Text per afegir al fitxer (per parar escriu ':>'): " user_string
	# Si el que ens dona no són els caràcters per parar el bucle, ho afegim
	if [[ $user_string != ":>" ]]
	then
		# Afegim el contingut al fitxer
		echo $user_string >> fitxer_EX3_amb_strings.txt
	fi
done
