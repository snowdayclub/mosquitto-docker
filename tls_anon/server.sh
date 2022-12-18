#!/usr/bin/bash

docker run -d --rm -it -p 8883:8883 -p 9001:9001 --name mosquitto \
	-v "$(pwd)/mount/mosquitto.conf:/mosquitto/config/mosquitto.conf:Z" \
	-v "$(pwd)/mount/certs:/mosquitto/certs:Z" \
	eclipse-mosquitto

