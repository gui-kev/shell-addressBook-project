#!/bin/sh

enter_user_address()
{
	echo "Enter user information"
	echo "Name : \c"
	read userName
	name="$userName"
	echo "Phone : \c"
	read userPhone
	phone="$userPhone"
	echo "Email : \c"
	read userEmail
	email="$userEmail"
}


search_address() #seacrh address book
{
	enter_user_address $name $phone $email
	if  [ -n "$name" ] && [ -n "$phone" ] && [ -n "$email" ]; then	
		user="$name:" + "$phone:" + "$email:"; echo "$user"

		for i in "$name" "$phone" "$email"
		do
			userExist=userExist + `grep -i "$name" AddressBook.txt` + ":"
		done

		if [ "$user"="$userExist" ]; then 
			return `echo "$user"` 
		else
			echo "User $name does not exist in the AddressBook"
			return 1
		fi
	else 
		echo "User informations cant not be empty." 
		search_address $name $phone $email
	fi 
}


add_address() # add address in the book
{
	search_address $name $phone $email
	resultSearchUser=$?
	if [ resultSearchUser -eq 1 ]; then
		echo "$name:$phone:$email:" >> AddressBook.txt
		resultAddUser=$?
		if [ "$resultAddUser" -eq "0" ]; then
			echo "Adding user success"	
			return 0
		fi
	else 
		echo "User already exist, do you want to edit (y/n)? \c "
		read inputString
		if [ "$inputString" = "y" ] || [ "$inputString" = "Y" ]; then
			enter_user_address
			echo "Feed the new value of user informations"
			echo "$name:$phone:$email:" >> AddressBook.txt
		fi
	fi
}


edit_address() # edit address in the book
{
	search_address $name $phone $email
	resultSearchUser=$?
	if [ resultSearchUser -eq 1 ]; then
		echo "User does not exist"
	else 
		echo "Feed the new value of user informations"
		enter_user_address $name $phone $email
	fi
}

remove_address() # remonve address in the book
{
	search_address $name $phone $email
	resultSearchUser=$?
	if [ resultSearchUser -ne 1 ]; then
		echo "User $name does not exist in the AddressBook"
		return 1
	else 
		if [ -n "$name" ]; then
			sed -i '/${name}/d' AddressBook.txt
		elif [ -n "$phone" ]; then
			sed -i '/${phone}/d' AddressBook.txt
		else 
			sed -i '/${email}/d' AddressBook.txt
		fi

		resultRemoveUser=$?
		if [ "$resultRemoveUser" -eq "0" ]; then
			echo "Removing user success"	
			return 0
		fi
	fi
}

display_address()
{
	search_address $name $phone $email
	resultSearchUser=$?
	if [ resultSearchUser -ne 1 ]; then
		echo "User $name does not exist in the AddressBook"
		return 1
	else 
		echo " User found : $userExist"
		return 0
	fi
}


touch AddressBook.txt
name=""; phone=""; email=""; userExist=""


while :
do 
	echo "Type a numbr to select an action : "
	echo "	1 : Search address book"
	echo "	2 : Add user address in the boo"
	echo "	3 : Edit a user in the book"
	echo "	4 : Remove a user in the book"
	echo " Your choice : \c"
	read inputNumber

	if [ "$inputNumber" -ge "1" ] && [ "$inputNumber" -le "4" ]; then
		case $inputNumber in
			1 )	search_address	;;
			2 )	add_address	;;
			3 )	edit_address	;;
			4 )	remove_address	;;
			* )	echo "Enter a number between 1, 2, 3 and 4"
				break			;;
		esac
	fi

	echo "Do you want to continue (y) or exit (n) ? \c"
	read inputString
	if [ "$inputString" = "y" ] || [ "$inputString" = "Y" ]; then 
		exit
	fi
done