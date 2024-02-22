Tots aquests arxius han sigut fets per l'Arnau Mas Consuegra, cursant 2n d'ASIX el curs 2023-2024.
El conjunt d'scripts que hi ha en aquest directori té com a funció principal la gestió d'un o més servidors als quals hi hagi accés.
Cada script té una tasca diferent. Aquestes són les principals de cadascun:

1- L'script "crear_copiar_claus_ssh.sh" fa, com indica el seu nom, la creació d'un conjunt de claus privada-pública. Després de crear-les, en fa una còpia al servidor que s'hagi
donat en els inputs. Aquest procés és necessari per poder executar els altres scripts i és opcional (si ja es tenen les claus). De fet, en el mateix script, es comprova si les claus
de l'usuari que ha cridat l'script ja existeixen i, si és el cas, acaba el programa sense fer-hi res. Fins i tot durant el programa tú mateix pots cancel·lar-ho abans de fer les claus.

2- L'script "instalacio_paquets.sh" realitza la instal·lació de diversos programes que són necessaris per a les comprovacions posteriors. Si s'executa quan els programes ja estan instal·lats,
simplement els actualitzarà. Cada vegada que s'executa, abans de res, realitza un "apt-get update" per assegurar que no hi ha problemes de paquets en cap moment.

3- L'script "comprovacions.sh" és l'arxiu que realitza tots els tests sobre un servidor determinat. Totes les proves es creen en una carpeta local dins l'ordinador des del qual s'executa i
guarda cada comanda de comprovacions en un arxiu diferent. Es crea també una carpeta on es guardaran totes les dades de les proves de totes les vegades que s'executi l'script i, de fet,
cada vegada que s'executa l'script, agafa la data i hora del moment, de manera que crea un segon directori que conté tots els arxius d'aquella data i hora determinada. D'aquesta manera,
si s'executa l'script en dos dies diferents, totes les dades quedaran guardades sense substituïr-ne d'anteriors.
