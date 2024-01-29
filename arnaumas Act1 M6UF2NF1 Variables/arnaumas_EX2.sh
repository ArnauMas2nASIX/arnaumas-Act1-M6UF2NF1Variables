#!/bin/bash

# ENUNCIAT
# Els arguments/paràmetres de l’usuari
# Realitza un script que rebi 5 arguments (no cal validar-los) passats per l’usuari i els mostri.
# Per últim, s’haurà de mostrar el nom de l’script.

# -----------------------------------------------------------------------------------------------

# Demanem els 5 valors a l'usuari, un per un
read -p "Escriu el primer argument: " valor1
read -p "Escriu el segon argument: " valor2
read -p "Escriu el tercer argument: " valor3
read -p "Escriu el quart argument: " valor4
read -p "Escriu el cinquè argument: " valor5

echo "Els valors que has escrit són:"
echo "Primer:" $valor1
echo "Segon:" $valor2
echo "Tercer:" $valor3
echo "Quart:" $valor4
echo "Cinquè:" $valor5
echo "El nom d'aquest script és:" $0
