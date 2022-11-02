#!/bin/sh

search_address() #seacrh address book
{
	echo "Enter user information"
	echo " Name : \c"; read name
	echo " Phone : \c"; read phone
	echo " Email : \c"; read email
	user="$name:$phone:$email"; echo "$user"
	userExist=""
	if  [ "$user" = "::" ]; then
		echo "User informations can not be empty." 			
	else 
		echo "$user" > AddressBook.tmp
		addressBookExist=`find -name AddressBook`
		[ -z "$addressBookExist" ] && touch AddressBook.txt
		username=`cut -d: -f1 AddressBook.tmp`
		userphone=`cut -d: -f2 AddressBook.tmp`
		useremail=`cut -d: -f3 AddressBook.tmp`

		j=1
		for i in $username $userphone $useremail
		do
			search=`grep -i "$i" AddressBook.txt | cut -d: -f${j}`
			j=`expr $j + 1`
			#echo "search = $search & \$i = $i & \$j = $j"; echo "$i"
			if [ "$i" = "$search" ]; then
				userExist=`grep -i "$i" AddressBook.txt`
				echo "User found : \c"
				echo "$userExist"
				return 0
			fi
		done
		if [ -z "$userExist" ]; then 
			echo "User $username does not exist in the AddressBook"
			return 1
		fi
	fi 
}

add_address() # add address in the book
{
	search_address
	resultSearchUser=$?
	if [ "$resultSearchUser" -eq "1" ]; then
		cat AddressBook.tmp >> AddressBook.txt
		resultAddUser=$?
		[ "$resultAddUser" -eq "0" ] && echo "Adding user succeed" || echo "Adding user failed"
		exit
	fi
}

edit_address() # edit address in the book
{
	search_address
	resultSearchUser=$?
	if [ "$resultSearchUser" -eq "0" ]; then
		oldUser=`cat AddressBook.tmp`
		echo "Enter the new value"
		echo " Name : \c"; read name
		echo " Phone : \c"; read phone
		echo " Email : \c"; read email
		echo "$name:$phone:$email" >> AddressBook.txt
		sed -i /${oldUser}/d AddressBook.txt
	fi
}

remove_address() # remonve address in the book
{
	search_address
	resultSearchUser=$?
	if [ "$resultSearchUser" -eq "0" ]; then
		removeUser=`cat AddressBook.tmp`
		sed -i /${removeUser}/d AddressBook.txt
		resultRemoveUser=$?
		[ "$resultRemoveUser" -eq "0" ] && echo "Removing succeed" || echo "Removing failed"
	fi
}

address_book()
{
	if [ "$1" = "q" ] || [ "$1" = "Q" ]; then
		exit
	elif [ "$1" -ge "1" ] && [ "$1" -le "4" ]; then
		case $1 in
			1 )	search_address
				break	;;
			2 )	add_address
				break	;;
			3 )	edit_address
				break	;;
			4 )	remove_address
				break	;;
		esac
	else 
		echo "Enter a number between 1, 2, 3 and 4 (^c or q to quit) : \c"
		return 1
	fi
}


echo "	1 : Search address book"
echo "	2 : Add user address in the boo"
echo "	3 : Edit a user in the book"
echo "	4 : Remove a user in the book"
echo "Type a number to select an action (^c or q to quit): \c"
read input

address_book $input
resultAddressBook=$?

if [ "$resultAddressBook" -eq "1" ]; then
	read input
	address_book $input
fi

echo "Address list"
cat AddressBook.txt
#rm AddressBook.tmp
