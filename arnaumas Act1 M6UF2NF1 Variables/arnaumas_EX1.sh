#!/bin/bash

# ENUNCIAT
# Realitza un script que mostri per pantalla pes principals variables globals i els,
# tots els arguments del Shell, el valor retornat per la darrera funció o comanda
# i el PID de la Shell actual.
# --------------------------------------------------------------------------------------

# Mostrem la variable que ens diu a quin directori HOME treballem
echo "El teu directori HOME és:" $HOME

# Mostrem la variable que ens diu a quins directoris buscarà aquest script
# els diferents arxius que hauria d'executar
echo "El directori on l'script buscarà fitxers per executar és:" $PATH

# Mostrem la SHELL en la que estem treballant
echo "La teva SHELL és:" $SHELL

# Mostrem el nom d'usuari
echo "El teu nom d'usuari és:" $USERNAME

# Mostrem el directori actual de l'usuari
echo "El teu directori actual és:" $PWD
