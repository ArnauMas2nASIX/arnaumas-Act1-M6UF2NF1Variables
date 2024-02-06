#!/bin/bash

# ENUNCIAT
# Realitza un script que, inicialment, obtingui els noms de comptes d’usuari del sistema
# que continguin alguna lletra majúscula. A continuació, fes que es demani un nom d’usuari.
# Mentre el nom introduït no sigui vàlid, mostra un missatge d’error. Un cop el nom
# introduït sigui vàlid (existent), mostra TOTA la informació disponible relacionada amb
# aquest compte d’usuari del sistema.
# -------------------------------------------------------------------------------------------

# --------------- MOSTRAR USUARIS AMB ALGUNA MAJÚSCULA  ---------------
# Primer de tot, diferent del que farem després, mostrem els usuaris del sistema que el seu
# nom contingui alguna majúscula
# Per fer-ho, canviem el delimitador de cada línia per :, que és el que separa cada usuari dels
# altres camps. Aleshores, el dividim en algunes variables que cadascuna representa un dels camps.
# D'aquesta manera, podem tractar directament el nom del usuari, agafant la variable f1
echo "<< USUARIS QUE CONTENEN UNA O MÉS MAJÚSCULES >>"
while IFS=: read -r f1 f2 f3 f4 f5 f6 f7
do
	# Llegint tot el fitxer, comparem cada camp d'usuari de cada línia amb el mateix nom
	# d'usuari però en minúscules. Si són completament iguals, signifcarà que no té majúscules.
	# Aprofitant això, fem la negació amb el signe d'exclamació, per tant obtindrem el
	# resultat invers: els usuaris que SÍ tenen majúscula, que és el que volem.
	if [[ ! $f1 == ${f1,,} ]]
	then
		# En cas que contingui alguna majúscula, ho mostrem per pantalla
		echo $f1
	fi
done < "/etc/passwd"
echo ""

# --------------- MOSTRAR INFORMACIÓ DE L'USUARI  ---------------
# En el següent apartat, demanarem un nom d'usuari per mostrar la seva informació. Aprofitarem
# el modus operandi de la lectura del fitxer que hem fet anteriorment per mostrar les dades
# de dit usuari. Primer, el demanem per terminal
read -p "Entra un nom d'usuari a examinar: " username

# Després, comprovem si l'usuari existeix. Tindrem en compte majúscules i minúscules, és a dir
# que si una lletra és minúscula al nom però s'introdueix majúscula, no serà correcte
# En cada volta tornarem a comprovar si exsiteix, per saber si hem de sortir del bucle o no.
user_exists=false
while [[ $user_exists = false ]]
do
	# Llegim el fitxer usuari per usuari per comprovar si el que s'ha posat existeix
	while IFS=: read -r f1 f2 f3 f4 f5 f6 f7
	do
		if [[ "$username" == "$f1" ]]
		then
		# En cas que existeixi, posem la variable a true
			user_exists=true
		fi
	done < "/etc/passwd"
	# En cas de que no existeixi, repetim l'entrada per demanar un altre usuari correcte.
	# Això es repetirà fins que no hi posi el nom correctament.
	if [[ $user_exists = false ]]
	then
		echo "ERROR: L'usuari no existeix"
		echo "Vigila amb les majúscules i minúscules"
		echo ""
		read -p "Entra un nom d'usuari a examinar: " username
	fi
done
echo ""

# Com que només podrem arribar aquí si l'usuari és correcte, directament llegirem el fitxer
# per mostrar la informació de l'usuari introduït, tornant a buscar la coincidència i mostrant
# tots els camps aprofitant el mètode que hem utilitzat anteriorment
while IFS=: read -r f1 f2 f3 f4 f5 f6 f7
do
	if [[ "$username" == "$f1" ]]
	then
		echo "<< INFORMACIÓ SOBRE L'USUARI $username >>"
		echo "Nom d'usuari: $f1"
		echo "ID d'usuari: $f3"
		echo "Grup principal: $f4"
		echo "Informació gecos: $f5"
		echo "Directori /home: $f6"
		echo "Shell: $f7"
	fi
done < "/etc/passwd"
