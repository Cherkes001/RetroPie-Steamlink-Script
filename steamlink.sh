#!/bin/bash

echo -e "\n****************************************************************"
echo -e "Welcome to the Steamlink Installer Script for RetroPie v0.1"
echo -e "****************************************************************\n"
echo -e "Select an option:"
echo -e " * 1: Install Steamlink"
echo -e " * 2: Exit"

read NUM
case $NUM in
	1)
		echo -e "\nStep One: Update"
		echo -e "****************************************\n"
        sudo apt update
        echo -e "\n**** Step One Complete! ****"
        echo -e "\nStep Two: Install Steamlink"
		echo -e "*****************************\n"
		sudo apt install steamlink

        echo -e "\nStep Three: Create Steamlink Menu for RetroPie"
		echo -e "*****************************************\n"
		
		if [ -f /home/pi/.emulationstation/es_systems.cfg ]
		then	
			echo -e "Removing Duplicate Systems File"
			rm /home/pi/.emulationstation/es_systems.cfg
		fi
		
		echo -e "Copying Systems Config File"
		cp /etc/emulationstation/es_systems.cfg /home/pi/.emulationstation/es_systems.cfg
			
		if grep -q "<platform>steam</platform>" /home/pi/.emulationstation/es_systems.cfg; then
			echo -e "NOTE: Steam Entry Exists - Skipping"
		else
			echo -e "Adding Steamlink to Systems"
			sudo sed -i -e 's|</systemList>|  <system>\n    <name>steamlink</name>\n    <fullname>SteamLink</fullname>\n    <path>~/RetroPie/roms/steamlink</path>\n    <extension>.sh .SH</extension>\n    <command>bash %ROM%</command>\n    <platform>steam</platform>\n    <theme>steam</theme>\n  </system>\n</systemList>|g' /home/pi/.emulationstation/es_systems.cfg
		fi
		echo -e "\n**** Step Three Cmplete! ****"
        echo -e "\nStep Four: Launch Scripts for RetroPie"
		echo -e "**********************************************************\n"
		
		echo -e "Create Script Folder"
		mkdir -p /home/pi/RetroPie/roms/steamlink
		cd /home/pi/RetroPie/roms/steamlink
		
		echo -e "Create Scripts"
		if [ -f /home/pi/RetroPie/roms/steamlink/steamlinkstart.sh ]; then
			echo -e "Done!"
        echo -e "NOTE: steamlinkstart script"
        fi
			echo "#!/bin/bash" > steamlinkstart.sh
			echo "steamlink "$ip"" >>  steamlinkstart.sh
        
        echo -e "Make Scripts Executable"
		chmod +x steamlinkstart.sh
        echo -e "\n**** Step Four Complete!!!! ****"

        echo -e "\nStep Five :)"
		echo -e "******************************************\n"
		
		echo -e "Changing File Permissions"
		chown -R pi:pi /home/pi/RetroPie/roms/steamlink/
		chown pi:pi /home/pi/.emulationstation/es_systems.cfg
        		echo -e "\n**** Step Five Complete!!!! ****\n"
		echo -e "Everything should now be installed and setup correctly."
		echo -e "To be safe, it's recommended that you perform a reboot now."
		echo -e "\nIf you don't want to reboot now, press N\n"
		
		read -p "Reboot Now (y/n)?" choice
		case "$choice" in 
		  y|Y ) shutdown -r now;;
		  n|N ) cd /home/pi
		  ./moonlight.sh
		  ;;
		  * ) echo "invalid";;
		esac
    ;;

    2)  exit 1 ;;
esac