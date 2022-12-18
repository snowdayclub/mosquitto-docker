#!/usr/bin/env sh
mosquitto_sub -d -h localhost -p 8883 --cafile ./certs/ca.crt \
    --cert ./certs/client.crt --key ./certs/client.key \
    -t 'my/topic' &
