#!/bin/bash
# *******************************************************************************************
# Script Name: Master
#
# Description: This script is designed to delete messages from Zimbra servers. It has been
# developed with the intention to assist system administrators in managing their Zimbra
# server environments more effectively.
#
# Disclaimer: While this script has been thoroughly tested and is intended for productive use,
# it is provided "AS IS" without warranty of any kind, express or implied. The author or
# contributors shall not be held liable for any direct, indirect, incidental, special,
# exemplary, or consequential damages (including, but not limited to, procurement of
# substitute goods or services; loss of use, data, or profits; or business interruption)
# however caused and on any theory of liability, whether in contract, strict liability, or
# tort (including negligence or otherwise) arising in any way out of the use of this script,
# even if advised of the possibility of such damage.
#
# It is the responsibility of the end-user (you) to fully test and validate the functionality
# of this script in your own environment before putting it into production. By using this
# script, you agree to take full responsibility for its execution and any consequences that
# may arise.
#
# Usage: Please refer to the documentation within the script for detailed usage instructions.
# Always ensure you have a backup of your data before executing scripts that modify or delete
# data.
#
# Author: Jhonnas Iriarte
# Date: 03/21/2024
# *******************************************************************************************

tryagain=0
zaccount=""
greenC="\\e[0;32m\\033[1m"
endC="\\033[0m\\e[0m"
redC="\\e[0;31m\\033[1m"
var=0
blueC="\\e[0;34m\\033[1m"
yellowC="\\e[0;33m\\033[1m"
purpleC="\\e[0;35m\\033[1m"
turquoiseC="\\e[0;36m\\033[1m"
grayC="\\e[0;37m\\033[1m"
sender=""
subject=""
zaccount=""
delete_by_subject() {
		echo -e "\n${yellowC}[+]${endC} ${grayC}Delete messages by subject${endC}"
		sleep 2
		read -p "[+] Enter Zimbra account ('all' for all accounts): " zaccount
		read -p "[+] Enter message SUBJECT: " subject
		sleep 1
		echo -e "\n${yellowC}[!]${endC} Deleting messages from account ${grayC}$zaccount${endC}with subject${grayC} $subject ${endC}"
		echo -e "${yellowC}[!]${endC} You have 5 senconds to cancel this operation\n"
		sleep 5
			if [ $zaccount == "all" ]; then
				echo -e "\n${yellowC}[!]${endC} Deleting messages from account ${grayC}$zaccount${endC}with subject${grayC} $subject ${endC}"
				echo -e "${yellowC}[!]${endC} You have 5 senconds to cancel this operation\n"
				sleep 5
				for user in `zmprov -l gaa`
				do
					echo -e "\n${yellowC}[!]${endC}Searching and destroying selected messages for user ${grayC} $user ${endC}..."
					echo""
					for msg in `zmmailbox -z -m  "$user" s -l 999 -t message "subject:$subject"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
					do
						touch messages_by_subject.txt
						echo $msg >> messages_by_subject.txt
						zmmailbox -z -m $user dm $msg

						echo -e "Found ----> Deleted!"
					done
				done
			exit 0
			fi
		#script here to delete by subject
		echo -e "\n${yellowC}[!]${endC} Searching and destroying selected messages..."
		for msg in `zmmailbox -z -m  "$zaccount" s -l 999 -t message "subject:$subject"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
		do
		touch messages_by_subject.txt
		echo $msg >> messages_by_subject.txt
		zmmailbox -z -m $zaccount dm $msg
		echo -e "Found ----> Deleted!"
		done
		exit 0
}
validation(){
	if [ -n "$option" ]; then
		if [ $option == "1" ]; then
			echo -e "\nConfirm ${grayC}'DELETE MESSAGE BY SUBJECT'${endC}"
			sleep 2
			confirm_options
			if [ "$tryagain" == "1" ] ; then
				echo -e "\nMake sure to respond correctly!"
				echo -e "\nExiting..."
				exit 0
			fi
			delete_by_subject
		elif [ $option == "2" ]; then
			echo -e ""
			echo -e "\nConfirm $grayC'DELETE MESSAGE BY SENDER'${endC}"
			sleep 2
			confirm_options
			if [ "$tryagain" == "1" ]; then
				echo -e "\nMake sure to respond correctly!"
				echo -e "\nExiting..."
				exit 0
			fi
			delete_by_sender
		elif [ $option == "3" ]; then
			echo -e ""
			echo -e "\nConfirm $grayC'DELETE MESSAGE BY SENDER AND SUBJECT'${endC}"
			sleep 2
			confirm_options
			if [ "$tryagain" == "1" ]; then
				echo -e "\nMake sure to respond correctly!"
				echo -e "\nExiting..."
				exit 0
			fi
			delete_by_sender_and_subject
		else
			echo -e "\n${redC}[X]${endC} PLease select a valid option!!! ${yellowC} ('$option' is not a valid opntion.).${endC}\n"
			echo -e "                    ...exit."
			sleep 1
			echo "exiting..."
			exit 0
		fi
	else
		let "var+=1"
		echo -e "${redC}[X]${endC}you have to make a choice to continue!${redC}[X]${endC} ${grayC}╮(●︿●)╭${endC}\n"
		if [ "$var" == "3" ]; then
			echo -e "\nbye"
			exit 0
		else
			prompt
		fi
	echo -e "\nPlease call me when you're ready to select one option \n${grayC}╰(•́ ꞈ •̀)╯${endC}  ...bye"
	exit 0
	fi
}
delete_by_sender() {
	echo -e "\n${yellowC}[+]${endC} ${grayC}Delete messages by sender${endC}"
	sleep 2
	read -p "Enter Zimbra account: ('all' for all accounts) " zaccount
	read -p "Enter message SENDER: " sender
	sleep 1
	echo -e "\n${yellowC}[!]${endC} Deleting messages from ${grayC}$zaccount${endC}, with sender${grayC} $sender ${endC}."
	echo -e ""
	echo -e "${yellowC}[!]${endC} You have 5 senconds to cancel this operation"
	sleep 5
	if [ $zaccount == "all" ]; then

		for user in `zmprov -l gaa`
		do
			echo -e "\n${yellowC}[!]${endC} Searching and destroying selected messages for $user..."
			echo""
			for msg in `zmmailbox -z -m  "$user" s -l 999 -t message "from:$sender"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
			do
				touch messages_by_sender.txt
				echo $msg >> messages_by_sender.txt
				zmmailbox -z -m $user dm $msg
				echo -e "Found ----> Deleted!"
			done
		done
		exit 0
	fi
	echo -e "\n${yellowC}[!]${endC} Searching and destroying selected messages..."
	echo""
	for msg in `zmmailbox -z -m  "$zaccount" s -l 999 -t message "from:$sender"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
	do
		touch messages_by_sender.txt
		echo $msg >> messages.txt
		zmmailbox -z -m $zaccount dm $msg
		echo -e "Found ----> Deleted!"
	done
	exit 0
}
delete_by_sender_and_subject() {
	echo -e "\n${yellowC}[+]${endC} ${grayC}Delete messages by sender and subject${endC}"
	sleep 2
	read -p "Enter Zimbra account: ('all' for all accounts) " zaccount
	read -p "Enter message SENDER: " sender
	read -p "Enter message SUBJECT: " subject
	sleep 1
	echo -e "\n${yellowC}[!]${endC} Deleting messages from $zaccount account, with sender=$sender subject=$subject"
	echo -e ""
	echo -e "${yellowC}[!]${endC} You have 5 senconds to cancel this operation"
	sleep 5
	if [ $zaccount == "all" ]; then
		for user in `zmprov -l gaa`
		do
			echo -e "\n${yellowC}[!]${endC} Searching and destroying selected messages for $user..."
			echo""
			for msg in `zmmailbox -z -m  "$user" s -l 999 -t message "from:$sender subject:$subject"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
			do
				touch messages_by_sender.txt
				echo $msg >> messages_by_sender.txt
				zmmailbox -z -m $user dm $msg
				echo -e "Found ----> Deleted!"
			done
		done
		exit 0
	fi
	echo -e "\n${yellowC}[!]${endC} Searching and destroying selected messages..."
	echo""
	for msg in `zmmailbox -z -m  "$zaccount" s -l 999 -t message "from:$sender subject:$subject"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
	do
		touch messages_bysubject.txt
		echo $msg >> messages.txt
		zmmailbox -z -m $zaccount dm $msg
		echo -e "Found ----> Deleted!"
	done
	exit 0
}
confirm_options(){
read -p "type 'y' for 'yes. Type 'n' for no: " confirm
	if [ ${confirm} ]; then
		if [ $confirm != "y" ] && [ $confirm != "n" ]; then
			echo -e "\n${redC}[X]${endC} Please type 'y' or 'n' to confirm or not"
			echo -e ""
			tryagain=1
		elif [ $confirm == "y" ]; then
			echo -e "${blueC}[-]${endC}${grayC} You have confirmed and understand what you're doing.${endC} \n"

		elif [ $confirm == 'n' ]; then
			echo -e "\n${yellowC}[!]${endC} Not confirmed!"
			sleep 1
			echo -e "${yellowC}[!]${endC} The operation has been canceled!"
			sleep 1
			exit 0
		fi
	else
		echo -e "\n${redC}[X]${endC} Please select a valid option!!!"
		exit 0
	fi
}
prompt() {
echo -e "$yellowC[!] WARNING!${endC} ${blueC}CHOOSE WISELY!${endC}"
echo -e "${yellowC}1${endC} - Delete messages ${grayC}by subject${endC}.    ${yellowC}2${endC} - Delete messages ${grayC}by sender${endC}.    ${yellowC}3${endC} - Delete messages by ${grayC}sender and subject${endC}"
read -p "(1, 2, or 3): " option
}
#sleep 1
prompt
validation
#EOF
