#!/usr/bin/env sh
mosquitto_pub -d -h localhost -t 'my/topic' -m 'hello, subscriber'
