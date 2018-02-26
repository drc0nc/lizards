#!/bin/bash

CYAN='\033[1;36m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' 

if (whiptail --title "Installation" --yesno "do you want to start the installation ?" --yes-button "yes" --no-button "no" 10 60) then
	echo ""
	printf "%b\n" "   ${GREEN}////////////////////////////////////////////////\n   ${YELLOW}//      Start of the installation program      //\n   ${RED}////////////////////////////////////////////////${NC}\n"
	echo ""
	echo ""
	printf "%b\n" "${BLUE}     ********************************\n     *   Updating the Raspberry   *\n     ********************************${NC}\n"
	echo ""
	printf "%b\n" "${CYAN}"
	apt-get update && apt-get upgrade -y
	echo ""
	echo ""
	printf "%b\n" "${BLUE}     *************************************************\n     *   build installation, python, git and pip   *\n     *************************************************${NC}\n"
	echo ""
	printf "%b\n" "${CYAN}"
	apt-get install apt-transport-https -y && apt-get install build-essential python-dev python-openssl git python-pip -y
	echo ""
	printf "%b\n" "${BLUE}     ***************************************************\n     *   installation of the python library 'ephem'   *\n     ***************************************************${NC}\n"
	echo ""
	printf "%b\n" "${CYAN}"
	pip install ephem 
	echo ""
	printf "%b\n" "${BLUE}     *****************************************************************\n     *   installation of adafruit libraries to read probes   *\n     *****************************************************************${NC}\n"
	echo ""
	printf "%b\n" "${CYAN}"
	cd /home/pi
	git clone https://github.com/adafruit/Adafruit_Python_DHT.git
	cd Adafruit_Python_DHT
	python setup.py install
	echo ""
	printf "%b\n" "${BLUE}     ********************************************************************\n     *   installation of libraries to communicate with the LCD screen  *\n     ********************************************************************${NC}\n"
	echo ""
	printf "%b\n" "${CYAN}"
	cd /home/pi
	git clone https://github.com/dbrgn/RPLCD
	cd RPLCD
	python setup.py install
	echo ""
	printf "%b\n" "${BLUE}     ************************************************************\n     *   installation of LAMP (linux apache mysql phpmyadmin)   *\n     ************************************************************${NC}\n"
	echo ""
	printf "${YELLOW}You will need to set a mysql root password here,\nfor phpmyadmin choose apache$\ndefine a password for phpmyadmin (put the same as mysql it's easier)${NC})\n"
	echo ""
	echo "press the enter key to continue"
	read a
	printf "%b\n" "${CYAN}"
	apt-get install mysql-server python-mysqldb apache2 php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-gd php7.0-opcache php7.0-curl phpmyadmin shellinabox -y
	echo ""
	printf "%b\n" "${BLUE}     *************************************\n     *   creation of the database   *\n     *************************************${NC}\n"
	echo ""
	dbname="Terrarium"
	echo""		
    mdproot=$(whiptail --title "Password of root Mysql" --passwordbox "Enter the password for root mysql :" 10 60 3>&1 1>&2 2>&3) 
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
		mysql -uroot -p${mdproot} -e "CREATE DATABASE ${dbname};"    
	else
		echo "Canceled"
	fi
	echo ""	
	printf "${BLUE} list of mysql database, the Terrarium database must be present${NC}\n"
	echo ""
	printf "%b\n" "${CYAN}"
	mysql -uroot -p${mdproot} -e "show databases;"
	echo ""
	loginbdd=$(whiptail --title "Login user mysql" --inputbox "Choose a username for MySQL :" 10 60 3>&1 1>&2 2>&3)
	exitstatus2=$?
	if [ $exitstatus2 = 0 ]; then 
		echo "ok"
	else
		echo "Canceled"
	fi
	echo ""	
	mdpbdd=$(whiptail --title "Password user Mysql" --passwordbox "Choose a password for this user :" 10 60 3>&1 1>&2 2>&3) 
	exitstatus3=$?
	if [ $exitstatus3 = 0 ]; then
		mysql -hlocalhost -uroot -p${mdproot} -e "CREATE USER ${loginbdd}@localhost IDENTIFIED BY '${mdpbdd}';"
		mysql -hlocalhost -uroot -p${mdproot} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${loginbdd}'@'localhost';"
		mysql -hlocalhost -uroot -p${mdproot} -e "FLUSH PRIVILEGES;"
	else
		echo "Canceled"
	fi	
	echo ""	
	echo "We create the table sensordata"
	mysql -u${loginbdd} -p${mdpbdd} -hlocalhost -D${dbname} -e "CREATE TABLE sensordata (dateandtime DATETIME, tempF DOUBLE, humF DOUBLE, tempC DOUBLE, humC DOUBLE);"
	echo ""						   
	echo "We create the table config"
	echo ""
	mysql -u${loginbdd} -p${mdpbdd} -hlocalhost -D${dbname} -e "CREATE TABLE config (dateandtime DATETIME, loginadmin VARCHAR(32), mdpadmin VARCHAR(32), longitude FLOAT, latitude FLOAT, altitude INT, lowlimit INT, highlimit INT, day INT, night INT, warmpi INT, sender VARCHAR(32), mdpsender VARCHAR(32), reciever VARCHAR(32), ip VARCHAR(32), Time_summer_winter INT);"
	echo ""
	echo "on redémarre mysql "
	echo ""
	/etc/init.d/mysql restart
	echo ""
	printf "%b\n" "${BLUE}   *******************************************************************\n   *   download and installation of terrarium-Raspberry-pi   *\n   *******************************************************************${NC}\n"
	echo ""
	printf "%b\n" "${CYAN}"
	cd /var/www/html/
	rm index.html
	rm -R terraspi	
	chown -R www-data:pi /var/www/html/
	chmod -R 770 /var/www/html/
	echo ""
	cd /home/pi
	git clone https://github.com/weedmanu/terrarium-Raspberry-pi.git
	cd /home/pi/terrarium-Raspberry-pi
	mv terraspi -t /var/www/html/
	chown -R www-data:pi /var/www/html/
	chmod -R 770 /var/www/html/
	cd /var/www/html/terraspi/csv/
	echo ""
	printf "%b\n" "${BLUE}    **************\n    *    MySQL   *\n    **************\n"
	echo ""
	printf "%b\n" "${CYAN}"
	echo "login mysql"
	echo ""	
	sed -i "s/loginbdd/${loginbdd}/g" bdd.json
	echo "ok"
	echo ""	
	echo "mot de passe mysql"
	echo ""
	sed -i "s/mdpbdd/${mdpbdd}/g" bdd.json
	echo "ok"		
	echo ""
	printf "%b\n" "${BLUE}    ******************\n    *     Admin      *\n    ******************${NC}\n"
	echo ""
	loginadmin=$(whiptail --title "Configuration" --inputbox" Choose a user name for the admin page :" 10 60 3>&1 1>&2 2>&3)
	exitstatus4=$?
	if [ $exitstatus4 = 0 ]; then 
		echo "ok"
	else
		echo "Canceled"
	fi
	mdpadmin=$(whiptail --title "Configuration" --passwordbox "Choose a password for this user :" 10 60 3>&1 1>&2 2>&3) 
	exitstatus5=$?
	if [ $exitstatus5 = 0 ]; then
		echo "ok"
	else
		echo "Canceled"
	fi
	echo ""	
	printf "%b\n" "${BLUE}    ***************\n    *     IP      *\n    ***************${NC}\n"
	echo ""
	function valid_ip()
	{
		local  ip=$1
		local  stat=1

		if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
			OIFS=$IFS
			IFS='.'
			ip=($ip)
			IFS=$OIFS
			[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
				&& ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
			stat=$?
		fi
		return $stat
		
	}
	ip=$(whiptail --title "Configuration" --inputbox "What is the IP address of your Raspberry pi ?" 10 60 3>&1 1>&2 2>&3)
	exitstatus6=$?
	if [ $exitstatus6 = 1 ]; then 
		echo "Canceled"
	fi
	until valid_ip $ip
	do
		ip=$(whiptail --title "Configuration" --inputbox "A valid ip address !!! :" 10 60 3>&1 1>&2 2>&3)
		exitstatus7=$?
		if [ $exitstatus7 = 1 ]; then 
			echo "Canceled"
		fi		
	done
	echo ""	
	echo ""
	dateandtime=$(date +%Y%m%d%H%M%S)
	echo ""
	echo ""
	mysql -uroot -p${mdproot} -hlocalhost -D${dbname} -e "INSERT INTO config (dateandtime, loginadmin, mdpadmin, ip) VALUES ( '$dateandtime', '$loginadmin', '$mdpadmin', '$ip' )";
	echo ""
	cd /home/pi/
	rm -R terrarium-Raspberry-pi
	crontab -upi -l > tachecron
	echo "* * * * * python /var/www/html/terraspi/prog/terra.py > /dev/null 2>&1" >> tachecron	
	crontab -upi tachecron
	rm tachecron
	cp /etc/rc.local /home/pi/test
	sed -i '$d' test
	echo "python /var/www/html/terraspi/prog/lcd.py" >> test
	echo "" >> test
	echo "exit 0" >> test
	mv test /etc/rc.local
	python /var/www/html/terraspi/prog/lcd.py &
	echo ""
	printf "%b\n" "${GREEN}           ********************************\n           ********************************\n${YELLOW}           **    END of the installation   **\n${RED}           ********************************\n           ********************************${NC}\n"
	echo ""
	echo "then :"
	printf "%b\n" "${BLUE}"
	printf "           http://${ip}:4200"
	printf "%b\n" "${NC}"
	printf "%b\n" "${YELLOW}"
	echo " Open this link above in your browser, it will switch to https, you must add a security execption by clicking on advanced "
	echo " Check mark permanently, and you will come across the pi's terminal. close the page. "
	printf "%b\n" "${NC}"
	echo "Press the enter key to continue"
	read a
	printf "%b\n" "${YELLOW}"
	echo "Open this link below in your internet browser then enter your login for the admin page and set the last parameters of the terrarium"
	printf "%b\n" "${BLUE}"
	echo "   http://${ip}/terraspi/admin/"
	printf "%b\n" "${NC}"
	echo ""
	printf "%b\n" "${GREEN}powered ${YELLOW}by ${RED}weedmanu${NC}\n"
	echo ""
else
	whiptail --title "Installation" --msgbox "Installation Canceled !!!" 10 60
fi
echo ""
exit
