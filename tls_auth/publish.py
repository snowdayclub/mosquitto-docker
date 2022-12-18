#!/usr/bin/env python3

import json
import paho.mqtt.client as mqtt
import ssl

server = "localhost"
port = 8883
topic = "my/topic"
payload = json.dumps({"key":"value"})

ca_crt = "./certs/ca.crt"               # CA certificate
client_crt = "./certs/client.crt"       # client certificate
client_key = "./certs/client.key"       # client key

username = "pub_user"
password = "pub_password"


if __name__=='__main__':
    # create a clent
    client = mqtt.Client()

    # set username and password
    client.username_pw_set(username, password)
    # use TLS
    client.tls_set(ca_crt, client_crt, client_key)

    # connect
    client.connect(server, port)

    # publish payload to the topic
    client.publish(topic, payload)

