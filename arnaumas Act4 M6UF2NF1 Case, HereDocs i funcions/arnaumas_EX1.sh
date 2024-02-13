#!/bin/bash

# ENUNCIAT
# ÚS DEL CASE
# Realitza un script que entri en un bucle i que no en surti fins que l’usuari triï si està
# segur de continuar avançant en l’espiral d’emocions, alegries i èxits en les que es troba
# (si continua pots fer que s’obri l’enllaç adjunt).
# -------------------------------------------------------------------------------------------

# Demanem al usuari si vol continuar dins una espiral d'emocions
read -p "Vols continuar l'espiral d'emocions [y/n]?: " emotions

# Farem que qualsevol cosa que entri l'usuari es transformi a minúscules per evitar errors
emotions=${emotions,,}

# Ara iniciarem el case que donarà una sortida depenent del que digui
case $emotions in
	"y")
		# Si l'usuari ens diu que sí està preparat, el felicitarem
		echo "Digues que sí!" ;;
	"n")
		# En cas que ens digui que no, l'animarem
		echo "Va, que tú pots!" ;;
	*)
		# Si no ens entra una resposta vàlida, l'avisarem
		echo "Tio, això no és ni una resposta!" ;;
esac

# Després d'aquest últim case, crearem un bucle que faci el mateix i repeteixi la pregunta
# Fins que l'usuari se senti preparat. Dins aquest bucle tindrem el mateix filtre que anteriorment
# per assegurar-nos que depenent del que entri correspongui amb la resposta correcte.
until [[ $emotions == "y" ]]
do
	echo ""
	read -p "Vols continuar l'espiral d'emocions [y/n]?: " emotions
	case $emotions in
	"n")
		echo "Anima't home!" ;;
	"y")
		echo "Digues que sí!" ;;
	*)
		echo "Tio, això no és ni una resposta!" ;;
	esac
done
echo ""

# Un cop l'usuari se senti preparat, el tornarem a felicitar
echo "Mai he dubtat de tu!"

# A més, després d'un parell de segons, obrirem un vídeo motivador perquè no perdi les ganes
sleep 2
firefox youtu.be/jaLDoWqIq2M &>/dev/null
