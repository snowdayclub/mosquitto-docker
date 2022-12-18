#!/usr/bin/bash

docker run -d --rm -it -p 1883:1883 -p 9001:9001 --name mosquitto \
	-v "$(pwd)/mount/mosquitto.conf:/mosquitto/config/mosquitto.conf:Z" \
	eclipse-mosquitto

