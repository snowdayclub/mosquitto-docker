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


if __name__=='__main__':
    # create a client
    client = mqtt.Client()

    # use TLS
    client.tls_set(ca_crt, client_crt, client_key)

    # connect
    client.connect(server, port)

    # publish payload to the topic
    client.publish(topic, payload)

