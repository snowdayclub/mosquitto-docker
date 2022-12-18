#!/usr/bin/env sh
mosquitto_sub -d -h localhost -t 'my/topic' &
