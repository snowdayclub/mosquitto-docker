#!/usr/bin/env python3

import json
import paho.mqtt.client as mqtt

server = "localhost"
port = 1883
topic = "my/topic"
payload = json.dumps({"key":"value"})


if __name__=='__main__':
    # create a client
    client = mqtt.Client()

    # connect
    client.connect(server, port)

    # publish payload to the topic
    client.publish(topic, payload)

