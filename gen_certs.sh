#!/bin/bash

RED='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m'

while :
do
	echo -e "\n\n\tSelect menu (x for exit)\n"
	echo -e "\t  (1) Generate a CA certificate and key (ca.crt and ca.key)"
	echo -e ""
	echo -e "\t  (2) Generate server private key (server.key)"
	echo -e "\t  (3) Generate server private key (server.key) W/O passphrase "
	echo -e "\t  (4) Generate server signing request (server.csr)"
	echo -e "\t  (5) Generate server certificate (server.crt)"
	echo -e ""
	echo -e "\t  (6) Generate client private key (client.key)"
	echo -e "\t  (7) Generate client private key (client.key) W/O passphrase"
	echo -e "\t  (8) Generate client signing request (client.csr)"
	echo -e "\t  (9) Generate client certificate (client.crt)"

	read selection

	case $selection in
		1) openssl req -new -x509 -days 365 -extensions v3_ca -keyout ca.key -out ca.crt
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate CA key and certificate${NC}"
				rm -f ca.key ca.crt
			else
				echo -e "\n\t${GRN}CA key and certificate generated${NC}"
			fi ;;
		2) openssl genrsa -des3 -out server.key 2048
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate server key${NC}"
				rm -f server.key
			else
				echo -e "\n\t${GRN}Server key generated${NC}"
			fi ;;
		3) openssl genrsa -out server.key 2048
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate server key${NC}"
				rm -f server.key
			else
				echo -e "\n\t${GRN}Server key generated${NC}"
			fi ;;
		4) openssl req -out server.csr -key server.key -new
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate server signing request${NC}"
				rm -rf server.csr
			else
				echo -e "\n\t${GRN}server signing request generated${NC}"
			fi ;;
		5) openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate server certificate${NC}"
				rm -rf server.crt
			else
				echo -e "\n\t${GRN}server certificate generated${NC}"
			fi ;;
		6) openssl genrsa -des3 -out client.key 2048
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate client key${NC}"
				rm -f client.key
			else
				echo -e "\n\t${GRN}client key generated${NC}"
			fi ;;
		7) openssl genrsa -out client.key 2048
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate client key${NC}"
				rm -f client.key
			else
				echo -e "\n\t${GRN}client key generated${NC}"
			fi ;;
		8) openssl req -out client.csr -key client.key -new
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate client signing request${NC}"
				rm -rf client.csr
			else
				echo -e "\n\t${GRN}client signing request generated${NC}"
			fi ;;
		9) openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365
			ret_code=$?
			if [ $ret_code != 0 ]
			then
				echo -e "\n\t${RED}failed to generate client certificate${NC}"
				rm -rf client.crt
			else
				echo -e "\n\t${GRN}client certificate generated${NC}"
			fi ;;
		x) exit;;
	esac
done


