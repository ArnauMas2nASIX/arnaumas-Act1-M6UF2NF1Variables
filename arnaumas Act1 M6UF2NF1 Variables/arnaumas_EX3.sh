#!/bin/bash

# ENUNCIAT
# Realitza un script que mostri un a un (un per línia) - no cal validar-los -
# els arguments que has introduït i quants s’han introduït.
# Pot rebre tants arguments com TU vulguis.
# ----------------------------------------------------------------------------------

# Mostrem els arguments que hem demanat
echo "Has introduït aquest número d'arguments:" $#
echo "Aquests són els arguments que has introduït:"
for argument in "$@"
do
	echo "- $argument"
done
