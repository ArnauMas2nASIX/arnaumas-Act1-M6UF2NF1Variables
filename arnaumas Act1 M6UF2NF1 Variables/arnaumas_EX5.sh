#!/bin/bash

# ENUNCIAT
# Crea un script que demani a l’usuari que introdueixi un nom d’usuari i una contrasenya per,
# a continuació, mostrar-ho tot en una sola línia.
# Quan l’usuari introdueixi la seva contrasenya, aquesta no ha d’aparèixer.
# ---------------------------------------------------------------------------------------------

# Demanem el nom d'usuari
read -p "Introdueix el nom d'usuari: " name_user
read -s -p "Introdueix la contrasenya: " pass_user

# I després, ho mostrem per pantalla, però només el nom d'usuari
echo "" # Per afegir un salt de línia
echo "" # Per afegir una línia en blanc per a més estètica de l'output
echo "Nom d'usuari nou:" $name_user
echo "Contrasenya:" $pass_user
