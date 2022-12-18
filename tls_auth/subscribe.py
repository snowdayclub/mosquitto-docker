#!/usr/bin/env python3

import json
import paho.mqtt.client as mqtt
import ssl

server = "localhost"
port = 8883
topic = "my/topic"

ca_crt = "./certs/ca.crt"
client_crt = "./certs/client.crt"
client_key = "./certs/client.key"

username = "sub_user"
password = "sub_password"

# connection callback
def on_connect(client, userdata, flags, rc):
    print("connected to the server: {}".format(rc))
    # subscribe to the topic
    client.subscribe(topic)

# message callback
def on_message(client, userdata, msg):
    print("message received: ({}) {} ".format(msg.topic, msg.payload))
    # decode payload
    try:
        data = json.loads(msg.payload)
        print("decoded: {}".format(data))
    except:
        pass


if __name__=='__main__':
    # create a client
    client = mqtt.Client()

    # register callbacks
    client.on_connect = on_connect
    client.on_message = on_message

    # set username and password
    client.username_pw_set(username, password)
    # use TLS
    client.tls_set(ca_crt, client_crt, client_key)

    # connect to the server
    client.connect(server, port)

    # remain connected
    client.loop_forever()
