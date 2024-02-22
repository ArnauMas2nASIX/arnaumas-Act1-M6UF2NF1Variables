#!/bin/bash

# Aquest arxiu farà una sèrie de comprovacions en el nostre servidor destí. De nou, és un script
# el qual s'ha de fer servir cada vegada per un servidor diferent. És a dir, està preparat per
# fer comprovacions en un servidor, però es pot utilitzar per qualsevol.
# -------------------------------------------------------------------------------------------

# Definirem una variable que aconsegueixi la data i una altra que agafi la hora del
# moment en que s'executa el script. Amb aquesta variable, tots els tests que es llancin,
# tindran un format diferent
date=$(date '+%Y-%m-%d')
hour=$(date '+%H:%M:%S')

# Una funció informarà a l'usuari de totes les comprovacions que es faran sobre el servidor
program_info() {
	echo "<< INFORMACIÓ >>"
	echo "Aquest programa executarà aquestes comprovacions:"
	echo "- Connectivitat amb el servidor (ping)"
	echo "- Resolució DNS inversa i directa del servidor (nslookup)"
	echo "- Escaneig de ports (nmap)"
	echo "- Segon escaneig de ports (netcat)"
	echo "- Informació dels discs (lsblk, df)"
	echo "- Estat del processador (sysbench)"
	echo "- Estat de la memòria (sysbench)"
}

# Amb una altra funció, recollirem les dades que necessitem per connectar al servidor.
# A més, farem una comprovació prèvia per veure si les proves es poden executar o no.
# Si no es poden perquè no aconsegueix connectar-se, simplement acabarem el programa.
get_server_info() {
	read -p "Introdueix la IP del servidor: " server_ip
	echo ""
	echo "ATENCIÓ: El següent paràmetre ha de coincidir amb el nom del fitxer de la clau privada"
	read -p "Introdueix el nom d'usuari del servidor: " server_username
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

# Aquesta funció verifica la connexió a internet, fent un ping als DNS públics de google.
check_internet() {
	clear
	echo "EXECUTANT PROVA DE PINGS..."
	ssh ${server_username}@${server_ip} ping -c 4 8.8.8.8 > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/internet_test_${date}_${hour}.txt
}

# Aquesta funció realitza una resolució directa i una d'inversa sobre el servidor, per veure
# si respon a les peticions.
check_dns() {
	clear
	echo "EXECUTANT PROVES DE DNS..."
	ssh ${server_username}@${server_ip} nslookup localhost > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/dns_directresol_test_${date}_${hour}.txt
	ssh ${server_username}@${server_ip} nslookup ${server_ip} > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/dns_inverseresol_test_${date}_${hour}.txt
}

# Aquesta funció realitza dos escaneig de ports amb dos mètodes diferents. D'aquesta manera
# es poden veure quins ports estan oberts i quins ports estan tancats.
check_ports() {
	clear
	echo "EXECUTANT PROVES DE PORTS..."
	ssh ${server_username}@${server_ip} nmap -p- localhost > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/ports_nmap_test_${date}_${hour}.txt
	(ssh ${server_username}@${server_ip} nc -vz localhost 1-1023 > ports.txt 2>&1) &>/dev/null
	cat ports.txt | grep "succeeded" > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/ports_netcat_tests_${date}_${hour}.txt
	rm ports.txt
}

# Aquesta funció mostra, de dues maneres diferents, els diferents discs que hi ha al servidor
# i els dispositius connectats, així com les particions existents i les dades de tot això.
check_disks() {
	clear
	echo "EXECUTANT PROVES DE DISCOS..."
	ssh ${server_username}@${server_ip} lsblk > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/lsblk_test_${date}_${hour}.txt
	ssh ${server_username}@${server_ip} df -h > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/df_test_${date}_${hour}.txt
}

# Aquesta funció treu els paràmetres sobre la CPU amb el seu estat actual i els paràmetres.
check_cpu() {
	clear
	echo "EXECUTANT PROVA DE CPU..."
	ssh ${server_username}@${server_ip} sysbench cpu run > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/cpu_test_${date}_${hour}.txt
}

# Aquesta funció fa el mateix que l'anterior però sobre la memòria RAM del servidor.
check_memory() {
	clear
	echo "EXECUTANT PROVA DE MEMÒRIA..."
	ssh ${server_username}@${server_ip} sysbench memory run > ~/server_${server_ip}_tests/executed_at_${date}_${hour}/memory_test_${date}_${hour}.txt
}

# ---------------- CODI PRINCIPAL --------------
# Avisem al usuari que per poder executar bé aquestes comprovacions es necessita anteriorment
# haver utilitza l'script instalacio_paquets.sh perquè tingui totes les aplicacions
# necessàries per a les proves.
echo "<< ADVERTÈNCIA >>"
echo "Abans de fer servir aquest script, has d'haver utilitzat l'script instalacio_paquets.sh"
echo "Aquest programa fa servir comandes de paquets necessaris en aquell script"

# Preguntarem a l'usuari si vol continuar i començar amb les comprovacions. En cas que no vulgui,
# el programa s'acabarà directament.
user_option=""
until [[ $user_option == "y" || $user_option == "n" ]]
do
	read -p "Vols continuar? [y/n]: " user_option
	user_option=${user_option,,}
done

# Depenent de l'elecció del usuari, executarem el codi o sortirem del programa
if [[ $user_option == "y" ]]
then
	sleep 1
	clear
	# Mostrarem la informació sobre el programa a través de la funció creada
	program_info
	echo ""
	# Demanarem les dades per poder accedir al servidor i fer les proves
	get_server_info
	# Si la connexió s'ha comprovat i és correcte, es faran els tests
	# Crearem una carpeta, si no existeix, que sigui dels tests del servidor amb X IP
	if [[ $connect_success = true ]]
	then
		if [[ ! -d ~/server_${server_ip}_tests ]]
		then
			mkdir ~/server_${server_ip}_tests
		fi
		# Crearem també una carpeta que agafi la data i hora actuals que hem
		# recollit a dalt de tot i crei un directori amb això, on es guardaran
		# totes les proves d'aquella execució.
		if [[ ! -d ~/server_${server_ip}_tests/executed_at_${date}_${hour} ]]
		then
			mkdir ~/server_${server_ip}_tests/executed_at_${date}_${hour}
		fi
		# Executem les funcions de cada comprovació per ordre
		check_internet
		check_dns
		check_ports
		check_disks
		check_cpu
		check_memory
	fi
fi
# En cas de que alguna de les parts doni un fall o simplement el programa acabi les comprovacions,
# ens mostrarà un missatge de fi de programa.
clear
echo ""
echo "<< FI DEL PROGRAMA >>"
