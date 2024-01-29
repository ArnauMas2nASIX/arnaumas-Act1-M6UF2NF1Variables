#!/bin/bash

# ENUNCIAT
# Realitza un script que rebi diversos arguments per, a continuació, mostrar (i explicar)
# la diferència entre utilitzar $* i $@.
# -------------------------------------------------------------------------------------------

# Els arguments els passarem directament al executar l'script, posats tots
# des d'allà (ja que si ho fem amb read no llegirà quants hi ha passats)

# Aleshores, a partir dels arguments posats, definim què fa cada variable com ens demana,
# Explicant en cada cas com funcionen
echo "Si utilitzem el mètode de dollar + asterisc, mostrarem els arguments dins d'una sola string"
echo "-" $*
echo ""
echo "Si utilitzem el mètode dollar + arroba, els arguments estaran dins d'una array"
echo "-" $@
echo ""

# Mostrem les Conclusions per pantalla
echo "Com es pot comprovar, a l'hora de mostrar-los per pantalla es veuen igual,"
echo "però els scripts ho tracten de manera diferent a l'hora de processar-los"
