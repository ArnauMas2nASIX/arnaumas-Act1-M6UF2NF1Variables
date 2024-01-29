#!/bin/bash

# ENUNCIAT
# Conscients del teu potencial programant scripts en Bash, els teus companys i companyes de
# l’Institut consideren que és necessari vital que els ajudis a identificar en què
# consisteixen els paràmetres d’expansió i quines tasques ens faciliten aquests tipus
# de paràmetres dins de l’script següent.

CRACK=oriolorioloriol
echo CRCKMAQUINAFIERAJEFE=$CRACK
# Identifica què fa el paràmetre ##*
echo 'El resultat de ##*ori és' ${CRACK##*ori}
# Identifica què fa el paràmetre #*
echo 'El resultat of #*ori és' ${CRACK#*ori}
# Identifica què fa el paràmetre %% i/amb el * final
echo 'El resultat of %%ol* és' ${CRACK%%ol*}
# Proposta de canvi del vostre company i veí Joel
# Identifica què fa el paràmetre % i/amb el * final
echo 'El resultat of %ori* és' ${CRACK%ori*}


# En què ens pot beneficiar l’ús dels paràmetres d’expansió? Quin ús els hi puc donar a
# l’hora de programar Bash scripts?
# ----------------------------------------------------------------------------------------
echo "" # Línia en blanc per a l'estètica de la sortida per pantalla
echo "En el primer cas, elimina des de la part ESQUERRA de la variable la cadena" \
"més CURTA des de la primera ocurrència de -ori-"
echo "En el segon cas, elimina des de la part ESQUERRA de la variable la cadena" \
"més LLARGA des de la primera ocurrència de -ori-"
echo "En el tercer cas, elimina des de la part DRETA de la variable la cadena" \
"més CURTA des de la primera ocurrència de -ol-"
echo "En el quart cas, elimina des de la part DRETA de la variable la cadena" \
"més LLARGA des de la primera ocurrència de -ori-"
