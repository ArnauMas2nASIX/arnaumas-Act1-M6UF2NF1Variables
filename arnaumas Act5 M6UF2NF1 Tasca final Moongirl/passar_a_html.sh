#!/bin/bash

# Aquest arxiu passa totes les dades al servidor, posant-les dins un HTML. Això permet veure
# tots els resultats dels test en el mateix servidor. Encara així, aquest script només mostrarà
# les dades de el últim test que s'hagi fet, mentre que les dades de la resta dels tests estaran
# als directoris corresponents (explicat al README).
# -------------------------------------------------------------------------------------------

# Agafarem, de nou, la data i hora actuals. Això ho farem per mostrar-ho per pantalla en l'HTML
# per avisar de quan va ser la última vegada que es va generar el mateix codi HTML.
date=$(date '+%Y-%m-%d')
hour=$(date '+%H:%M:%S')

# Guardarem la informació de l'script dins una funció
program_info() {
	echo "<< INFORMACIÓ >>"
	echo "Aquest programa pujarà les proves seleccionades al servidor que tingui un Apache com a arxiu HTML"
	echo "El servidor amb Apache es dona per paràmetre durant el programa"
	echo "ATENCIÓ: Les dades de la última prova es substituiran en l'arxiu HTML"
	echo "per les noves. Encara així no s'esborraran del directori a on hi són."
}

# Amb una altra funció, recollirem les dades que necessitem per connectar al servidor.
# A més, farem una comprovació prèvia per veure si les proves es poden executar o no.
# Si no es poden perquè no aconsegueix connectar-se, simplement acabarem el programa.
get_server_info() {
	read -p "Introdueix la IP del servidor amb Apache: " server_ip
	echo ""
	echo "ATENCIÓ: El següent paràmetre ha de coincidir amb el nom del fitxer de la clau privada"
	read -p "Introdueix el nom d'usuari del servidor Apache: " server_username
	sleep 1
	clear
	connect_success=false
	if ssh ${server_username}@${server_ip} exit &>/dev/null
	then
		echo "SUCCESS: S'ha pogut establir connexió amb el servidor"
		connect_success=true
	else
		echo "ERROR: No s'ha pogut establir connexió amb el servidor"
	fi
	sleep 1
	clear
}

# Aquesta funció buscarà el directori del que volem extreure les dades que correspon a un servidor
# del qual hem fet comprovacions anteriorment. Si no existís perquè es dona malament o perquè
# no hem fet proves d'aquell servidor, donarà un error i acabarà el programa.
show_server_test_dirs() {
	read -p "Introdueix la IP del servidor del que vols pujar les dades: " server_tests_ip
	echo ""
	if [[ -d ~/server_${server_tests_ip}_tests ]]
	then
		# Mostrarem al usuari tots els directoris de conjunts dep roves que s'han fet
		# i que existeixen actualment perquè esculli del que vol pujar les dades.
		ls -l ~/server_${server_tests_ip}_tests
	else
		echo "ERROR: No hi ha dades guardades sobre aquest servidor"
	fi
}

# Aquesta senzilla funció farà la feina de llegir l'arxiu de dades del directori que haguem
# especificat i muntar dins l'HTML cada línia del fitxer amb un una etiqueta <p>, de manera
# que tot quedo millor llegible.
read_file() {
	while read -r line
	do
		echo "<p>$line</p>"
	done < $1
}
# ----------------------- CODI PRINCIPAL -------------------------
program_info
echo ""
user_option=""
until [[ $user_option == "y" || $user_option == "n" ]]
do
	read -p "Vols continuar? [y/n]: " user_option
	user_option=${user_option,,}
	# Depenent de l'elecció del usuari, executarem el codi o sortirem del programa
done

# Si l'usuari vol continuar amb el procés, aleshores continuarem
if [[ $user_option == "y" ]]
then
	sleep 1
	clear
	get_server_info
	# Només continuarem amb el programa si tenim connexió correcte amb el servidor
	# apache on volem pujar les dades.
	if [[ $connect_success = true ]]
	then
		# Mostrem els directoris de dades al usuari perquè escrigui el que ell
		# vulgui
		show_server_test_dirs
		echo ""
		read -p "Introdueix el directori del que vols extreure les dades: " server_dir_path
		clear
		echo "PROCESSANT..."
		sleep 1
		# Comprovarem si existeix el directori que ens han donat. Si existeix, aleshores
		# continuarem. En cas contrari, sortirem del programa.
		if [[ -d ~/server_${server_tests_ip}_tests/${server_dir_path} ]]
		then
			# Establim una ruta absoluta del directori i la guardem en una variable
			dir_path=~/server_${server_tests_ip}_tests/${server_dir_path}

			# Definim la ruta de tots els arxius a llegir. Això ho fem perquè
			# les comprovacions sempre existiran les mateixes i, tenint totes
			# una part de l'arxiu que és única per cada prova, els filtrarem així.
			# D'aquesta manera podrem agafar la ruta absoluta de tots els fitxers
			# que existeixen de proves d'aquell directori.
			cpu_path="${dir_path}/$(ls ${dir_path} | grep 'cpu')"
			df_path="${dir_path}/$(ls ${dir_path} | grep 'df')"
			dnsdir_path="${dir_path}/$(ls ${dir_path} | grep 'directresol')"
			dnsinv_path="${dir_path}/$(ls ${dir_path} | grep 'inverseresol')"
			ping_path="${dir_path}/$(ls ${dir_path} | grep 'internet')"
			lsblk_path="${dir_path}/$(ls ${dir_path} | grep 'lsblk')"
			memory_path="${dir_path}/$(ls ${dir_path} | grep 'memory')"
			netcat_path="${dir_path}/$(ls ${dir_path} | grep 'netcat')"
			nmap_path="${dir_path}/$(ls ${dir_path} | grep 'nmap')"

			# Després, escrivim l'arxiu HTML, que es farà de manera manual fins la part
			# de guardar les proves, on cadascuna es llegeix per la funció read_file()
			# que imprimeix les dades del fitxer amb línies <p> al HTML.
			cat <<- END > ~/index.html
				<!DOCTYPE html>
				<html>
					<head>
						<meta charset="utf-8">
						<title>SERVER STATUS</title>
					</head>
					<style>
						* {
							font-family: Verdana, sans-serif
						}
						article {
							padding: 10px;
							border: 2px solid black;
							margin-bottom: 10px;
						}
					</style>
					<body>
						<header><h1>SERVER STATUS</h1></header>
						<h2>Última actualització: $date $hour</h2>
						<article>
							<h3>CPU TEST</h3>
							$(read_file $cpu_path)
						</article>
						<article>
							<h3>MEMORY TEST</h3>
							$(read_file $memory_path)
						</article>
						<article>
							<h3>DISK-1 TEST</h3>
							$(read_file $df_path)
						</article>
						<article>
							<h3>DISK-2 TEST</h3>
							$(read_file $lsblk_path)
						</article>
						<article>
							<h3>DNS-1 TEST</h3>
							$(read_file $dnsdir_path)
						</article>
						<article>
							<h3>DNS-2 TEST</h3>
							$(read_file $dnsinv_path)
						</article>
						<article>
							<h3>INTERNET TEST</h3>
							$(read_file $ping_path)
						</article>
						<article>
							<h3>PORTS-1 TEST</h3>
							$(read_file $netcat_path)
						</article>
						<article>
							<h3>PORTS-2 TEST</h3>
							$(read_file $nmap_path)
						</article>
					</body>
				</html>
			END
			# Aquest arxiu HTML l'hem creat de manera local per fer la feina més
			# fàcil. Així doncs, utilitzant la clau SSH per accedir sense contrasenya,
			# accedirem al servidor per pujar-lo i substituir l'index.html que ja
			# estigués (ja hem avisat al principi que funcionava així al usuari).
			if scp -i ~/.ssh/${server_username}.pub ~/index.html ${server_username}@${server_ip}:/var/www/html &>/dev/null
			then
				echo "SUCCESS: S'ha pujat l'arxiu HTML correctament"
			else
				# Si hi ha qualsevol error durant la còpia dels arxius,
				# avisarem al usuari i li donarem una possibilitat de l'error
				# que hagi saltat que segurament sigui el més comú.
				echo "ERROR: No s'ha pogut pujar l'arxiu"
				echo "Vigila els permisos del directori /var/www/html perquè l'usuari del servidor al que conectes pugui escriure en ell"
			fi
			# Després esborrarem l'arxiu HTML de la màquina local.
			rm ~/index.html
		else
			echo "ERROR: No s'ha trobat el directori"
		fi
	else
		echo "ERROR: No s'ha pogut establir la connexió amb el servidor"
	fi

fi
# Si la resposta de l'usuari és que no vol continuar o el programa en sí ja ha acabat, ho
# avisarem per pantalla.
echo ""
echo "<< FI DEL PROGRAMA >>"
