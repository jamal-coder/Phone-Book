#!/bin/bash
##########################################################################################################
# Project	:	phone.sh
# Verision	:	1 Alpha
# Author	: 	Jamal Khan
# Start Date: 	01/01/2019
# End Date  :	03/01/2019
# Purpose	:	This is a database of personal contacts. Which allow you to keep record of your contacts.
# emails	: 	salma52@groups.facebook.com; sexykim@groups.facebook.com  
##########################################################################################################

#================================Variables=================================
cname=""
adder=""
phone=""
cell=""
email=""
web=""
myfile=.phone.txt

#================================Functions=================================
function wait {
	echo -ne "\t\tPress Any Key to Proceed..."
	read dump
}

function Line {
	echo "--------------------------------------------------------------------------------------------------------------------------"
}

function Inputing {
	while true; do
		read -p " Enter $2 (Max length $1)	: " input
		if [[ ${#input} -gt 0 && ${#input} -le $1 ]]; then
			break
		fi
	done
	echo $input
}

function YesNo {
	while true; do
		read -p "$1" options
		if [[ $options = [Yy] || $options = [Nn] ]]; then
			break
		fi
	done
	echo $options
}

function Searching {
	grep -i "$1" $myfile | awk -F ":" '{printf "%-20s %-30s %-13s %-13s %-20s %-20s\n", $1, $2, $3, $4, $5, $6}'
}

function Obtaining {
	case $2 in
		1) item=$(grep -i "$1" $myfile | awk -F ":" '{print $1}');;
		2) item=$(grep -i "$1" $myfile | awk -F ":" '{print $2}');;
		3) item=$(grep -i "$1" $myfile | awk -F ":" '{print $3}');;
		4) item=$(grep -i "$1" $myfile | awk -F ":" '{print $4}');;
		5) item=$(grep -i "$1" $myfile | awk -F ":" '{print $5}');;
		6) item=$(grep -i "$1" $myfile | awk -F ":" '{print $6}');;
	esac
	echo $item
}

function Updating {
	grep -iv "$1" $myfile > temp.txt
	if [[ $8 -eq 1 ]]; then
		echo "$2:$3:$4:$5:$6:$7" >> temp.txt
	fi
	sort temp.txt > $myfile
	rm temp.txt
	echo " Updating database..."
	sleep 2
}
#================================Main Program==============================
while true; do
	clear
	echo -e "\n\tMain Menu"
	echo -e "\t====^===="
	echo -e "\n 1----> Add Contact"
	echo " 2----> Edit or Delete Contact"
	echo " 3----> View Contacts"
	echo " 4----> Quit"
	echo -ne "\n Enter your Choice [1-5] : "
	read selection
	case $selection in
	1)
		while true; do
			clear
			echo -e "\n Add Contact"
			echo " ===^======="
			echo -e "\n Enter the following information"
			Line
			cname=$(Inputing 20 Name)
			adder=$(Inputing 30 Address)
			phone=$(Inputing 13 Phone) 
			cell=$(Inputing 13 Cell) 
			email=$(Inputing 20 Email)
			web=$(Inputing 20 Web)
			Line
			select=$(YesNo " Do you want to save information in the database [Y-N] : ")
			if [[ $select = [Yy] ]]; then
				echo $cname:$adder:$phone:$cell:$email:$web >> $myfile
				echo " Updating database..."
				sleep 2
			else
				echo " Information not saved"
			fi
			Line
			choice=$(YesNo " Do you want to add another contact [Y-N] : ")
			if [[ $choice = [Nn] ]]; then
				break
			fi 
		done
		;;
	2)
		while true; do
			clear
			echo -e "\n Edit Contact"
			echo " ====^======="
			echo " Select a number from menu to base search upon : "
			Line
			select choice in "Name" "Address" "Phone" "Cell" "Email" "Web" "Quit"
			do
				Line
				case $choice in
					Name) 
						choice=$(Inputing 20 Name)
						break;;
					Address)
						choice=$(Inputing 30 Address)
						break;;
					Phone)
						choice=$(Inputing 13 Phone)
						break;;
					Cell)
						choice=$(Inputing 13 Cell)
						break;;
					Email)
						choice=$(Inputing 20 Email)
						break;;
					Web)
						choice=$(Inputing 20 Web)
						break;;
					Quit)
						choice="Quit"
						break;;
					*)
						echo "Chose appropriate number [1-6]"
						;;
				esac		
			done 
			
			if [[ "$choice" = "Quit" ]]; then
				break
			fi
			clear
			echo " Search Results:-"
			Line
			Searching "$choice"	
			Line
			select=$(YesNo "Is the information correct [Y-N] : ")
		 	if [[ $select = [Yy] ]]; then
		 		cname=$(Obtaining "$choice" 1)
		 		if [[ "${#cname}" -gt 20 ]]; then
		 			Line
		 			echo "You can edit one record at a time, refine your search upto one record please."
		 			Line
		 			wait
		 			continue
		 		fi
		 		adder=$(Obtaining "$choice" 2)
		 		phone=$(Obtaining "$choice" 3)
		 		cell=$(Obtaining "$choice" 4)
		 		email=$(Obtaining "$choice" 5)
		 		web=$(Obtaining "$choice" 6)
		 		while true; do
			 		clear
			 		echo -e " \nEditable Record : "
			 		Line
		 			echo " 1) Contact Name : $cname"
		 			echo " 2) Mail Address : $adder"
			 		echo " 3) Phone Number : $phone"
		 			echo " 4) Cell Number  : $cell"
		 			echo " 5) Email Address: $email"
		 			echo " 6) Web Address  : $web"
		 			echo -e "\n 7) Confirm and Save Record"
		 			echo " 8) Delete Record"
		 			Line
		 			read -p " Select a Number to edit that field [1-7] : " select
		 			case $select in
		 				1)	cname=$(Inputing 20 Name);;
						2)	adder=$(Inputing 30 Address);;
						3)	phone=$(Inputing 13 Phone);;
						4)	cell=$(Inputing 13 Cell);;
						5)	email=$(Inputing 20 Email);;
						6)	web=$(Inputing 20 Web);;
						7)	Updating "$choice" "$cname" "$adder" "$phone" "$cell" "$email" "$web" 1
							break;;
						8) 	Updating "$choice"
							break;;
						*) echo
					esac
		 		done	
		 	fi
		done
		;;
	3)
		clear
		(echo " Contacts Details"
		Line
		awk -n -F ":" '{printf "%-20s %-30s %-13s %-13s %-20s %-20s\n", $1, $2, $3, $4, $5, $6}' $myfile
		Line) | less
		;;
	4)
		clear
		echo -e "\n\t\tAllah Hafiz, see you next time\n"
		exit
		;;
	*)
		clear
		echo -e "\n\t\tYou have selected wrong option select [1-5]"
		wait
		;;
	esac
done

