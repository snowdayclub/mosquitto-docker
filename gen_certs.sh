#!/bin/bash

while :
do
	echo -e "\n\tSelect menu (x for exit)\n"
	echo -e "\t  (1) Generate CA private key (ca.key)"
	echo -e "\t  (2) Generate CA signing request (ca.csr)"
	echo -e "\t  (3) Generate CA certificate (ca.crt)"
	echo -e ""
	echo -e "\t  (4) Generate server private key (server.key)"
	echo -e "\t  (5) Generate server signing request (server.csr)"
	echo -e "\t  (6) Generate server certificate (server.crt)"
	echo -e ""
	echo -e "\t  (7) Generate client private key (client.key)"
	echo -e "\t  (8) Generate client signing request (client.csr)"
	echo -e "\t  (9) Generate client certificate (client.crt)"

	read selection

	case $selection in
		1) openssl genpkey -out ca.key -algorithm RSA -des3 -pkeyopt rsa_keygen_bits:2048
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -f ca.key
			else
				echo -e "\n\tCA key"
				cat ca.key
			fi ;;
		2) openssl req -out ca.csr -new -key ca.key -sha256
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -f ca.csr
			else
				echo -e "\n\tCA signing request"
				cat ca.csr
			fi ;;
		3) openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt -days 365 -sha256
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -f ca.crt
			else
				echo -e "\n\tCA certificate"
				cat ca.crt
			fi ;;
		4) openssl genpkey -out server.key -algorithm RSA -des3 -pkeyopt rsa_keygen_bits:2048
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -f server.key
			else
				echo -e "\n\tServer key"
				cat server.key
			fi ;;
		5) openssl req -out server.csr -new -key server.key -sha256
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -rf server.csr
			else
				echo -e "\n\tServer signing request"
				cat server.csr
			fi ;;
		6) openssl x509 -req -out server.crt -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -days 365 -sha256
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -rf server.crt
			else
				echo -e "\n\tServer certificate"
				cat server.crt
			fi ;;
		7) openssl genpkey -out client.key -algorithm RSA -des3 -pkeyopt rsa_keygen_bits:2048
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -f client.key
			else
				echo -e "\n\tClient key"
				cat client.key
			fi ;;
		8) openssl req -out client.csr -new -key client.key -sha256
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -rf client.csr
			else
				echo -e "\n\tClient signing request"
				cat client.csr
			fi ;;
		9) openssl x509 -req -out client.crt -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -days 365 -sha256
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				rm -rf client.crt
			else
				echo -e "\n\tClient certificate"
				cat client.crt
			fi ;;
		x) exit;;
	esac
done


