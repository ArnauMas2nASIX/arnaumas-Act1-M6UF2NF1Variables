Tots aquests arxius han sigut fets per l'Arnau Mas Consuegra, cursant 2n d'ASIX el curs 2023-2024.
El conjunt d'scripts que hi ha en aquest directori té com a funció principal la gestió d'un o més servidors als quals hi hagi accés.
Cada script té una tasca diferent. Aquestes són les principals de cadascun:

1- L'script "crear_copiar_claus_ssh.sh" fa, com indica el seu nom, la creació d'un conjunt de claus privada-pública. Després de crear-les,
en fa una còpia al servidor que s'hagi donat en els inputs. Aquest procés és necessari per poder executar els altres scripts i és opcional
(si ja es tenen les claus). De fet, en el mateix script, es comprova si les claus de l'usuari que ha cridat l'script ja existeixen si li
donem a la opció de crear-les per no tornar-les a crear i després tenir errors. El programa també té una altra funció, que és copiar la
clau dins el servidor remot, per després poder accedir a través de SSH sense necessitat de contrasenya i que tots els scripts s'executin
correctament. Aquest pas és 100% necessari abans dels altres si no s'ha executat en cap moment anterior per aquell servidor.

2- L'script "instalacio_paquets.sh" realitza la instal·lació de diversos programes que són necessaris per a les comprovacions posteriors.
Si s'executa quan els programes ja estan instal·lats, simplement els actualitzarà. Cada vegada que s'executa, abans de res, realitza
un "apt-get update" per assegurar que no hi ha problemes de paquets en cap moment.

3- L'script "comprovacions.sh" és l'arxiu que realitza tots els tests sobre un servidor determinat. Totes les proves es creen en
una carpeta local dins l'ordinador des del qual s'executa i guarda cada comanda de comprovacions en un arxiu diferent. Es crea
també una carpeta on es guardaran totes les dades de les proves de totes les vegades que s'executi l'script i, de fet, cada vegada
que s'executa l'script, agafa la data i hora del moment, de manera que crea un segon directori que conté tots els arxius d'aquella
data i hora determinada. D'aquesta manera, si s'executa l'script en dos dies diferents, totes les dades quedaran guardades sense
substituïr-ne d'anteriors.

4- L'script "passar_a_html.sh", com indica el seu nom, té la funció de passar les dades seleccionades a format HTML per passar-ho
al servidor. L'script demana un servidor Apache al que pujar els arxius i després, el directori d'on estan guardades les dades per,
posteriorment, demanar quines dades exactes vol (de quin directori a X hora executada vol treure els .txt amb les dades de les comprovacions).
Aquest és independent del servidor que s'hagin tret les dades, però com en cada cas, es necessitarà accés per SSH sense contrasenya
(haver executat crear_copiar_claus_ssh.sh prèviament vaja).

5- L'script "programar_guardat_logs.sh" està fet com a complementari i no és 100% necessari d'utilitzar, però sí útil. El que fa aquest
script és preguntar-te si vols copiar les dades de diferents arxius de logs del sistema en el teu ordinador local des d'on executes l'script.
En cas de voler fer-ho, crea una estructura de directoris similar a la de "comprovacions.sh" i guarda allà els logs que s'indiquin. També,
després d'aquesta part (que pots decidir si fer la còpia o no i et seguirà preguntant el següent apartat), et permet crear un arxiu de crontab
per al usuari que estigui executant l'script i es connecti al servidor amb una comanda que realitza una còpia en local (al mateix servidor remot)
dels arxius de logs. Aquest està programat per fer-se cada Diumenge a les 12 de la nit, és a dir, a les 0:00. També és opcional, donat que si es
diu que no es vol fer, no ho fa.

6- L'script "EXECUTE_ALL.sh" està preparat per executar tots els scripts anteriorment comentats en ordre per no haver d'anar executant-los un a un.
D'aquesta manera és més fàcil gestionar-ho tot alhora sense haver d'anar pas per pas. Et deixa escollir si vols executar la creació i còpia de
claus SSH i també la d'instal·lar/actualitzar paquets, ja que aquesta no sempre s'ha d'utilitzar si no és necessari. Després executa totes les altres
de manera automàtica demanant en cada cas els paràmetres de cada script.
