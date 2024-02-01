#!/bin/bash

# ENUNCIAT
# Preparat? Vaig néixer preparat...
# Escriu un script que rebi la ruta d'un fitxer i indiqui els permisos que té
# (escriptura, lectura, execució).
# ---------------------------------------------------------------------------------------

# Primer, com abans, demanem la ruta del fitxer
read -p "Escriu la ruta absoluta del fitxer: " file_path

# Després, comprovem si existeix
if [[ -e $file_path ]]
# Si existeix, executarem el codi que ens donarà els permisos que té
then
	echo "Els permisos del fitxer són els següents:"
	ls -la $file_path
# En cas que no existeixi, ens donarà error
else
	echo "ERROR: El fitxer donat no existeix o no s'ha trobat"
fi
