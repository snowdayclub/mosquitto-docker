# Mosquitto on Docker Container

This repo provides sample configurations for eclipse-mosquitto on docker with
following settings:

* No Encryption + No Authentication
* TLS + No Authentication
* TLS + Password Authentication

# Notes

* It works with both `podman` and `docker` (need sudo).
* `:Z` suffix in the path was added for SELinux labeling.
* It is not tested under Windows or MacOS.
* Server certificate included in this example is created with `localhost`
as its `common name`. This should match with the url that the clients
connect to.  If you want to deploy the broker on machines other than
`localhost`, you need to recreate the server certificate.


# Directories and Files

* `/cleartext` : No encryption, no client authentication
* `/tls_annn` : TLS encyrption, no client authentication
* `/tls_auth` : TLS encryption, password authentication

Each directory contains

* `server.sh`: run server with docker
* `docker-compose.yml`: run server with docker-compose
* `mqtt_pub.sh`: mosquitto client for a publisher role
* `mqtt_sub.sh`: mosquitto client for a subscriber role
* `publish.py`: python client for a publisher role
* `subscribe.py`: python client for a subscriber role
* `mount/mosquitto.conf`: configuration file mounted to the container

Following files are used when applicable

* `mount/certs`: server certificates
* `mount/passwd`: password file
* `certs/`: client certificates

## Certificate files required by server

* `ca.crt`: CA certificate
* `server.crt`: server certificate
* `server.key`: server key

## Certificate files required by client

* `ca.crt`: CA certificate
* `client.crt`: client certificate
* `client.key`: client key


# Prerequisites

## eclipse-mosquitto docker image
```
docker pull eclipse-mosquitto:latest
```

## eclipse-mosquitto clients

* Debian based
```
sudo apt install mosquitto-clients
```

* Redhat based (**Be sure to disable the bare-metal mosquitto server!!**)
```
sudo dnf install mosquitto
sudo systemctl disable mosquitto.service
```


## Python paho-mqtt client
```
pip3 install paho-mqtt
```


# Testing

* Run the server as a daemon (docker users may need sudo)
```
./server.sh
```

* Listen to the topic at the background
```
./subscribe.py &
```

* Publish data to the topic
```
./publish.py
```

* Kill the background process
```
ps
kill -9 <process no>
```

* Shutdown the server daemon
```
docker container stop mosquitto
```


# Certificates

* DO NOT use [THE SAME INFORMATION](https://mosquitto.org/man/mosquitto-tls-7.html)
for creating certificates.
* DO NOT use passphrase when generating server.key and client.key if it is not
feasible to provide it when running the server or the client
(e.g. mosquitt on docker or client on embedded device)


## CA

* Create a CA key
```
openssl genrsa -des3 -out ca.key 2048
```

* Create a signing request for the CA: enter org name, but
**do not enter common name** for CA.
```
openssl req -new -key ca.key -out ca.csr -sha256
```

* Create a CA root certificate using the CA key
```
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt -days 365 -sha256
```

## Server

* Create a server key
```
openssl genrsa -out server.key 2048
```

* Create a server certificate request: do not omit the org name and
the  **common name** (`localhost` or FQDN)
```
openssl req -new -key server.key -out server.csr -sha256
```

* Create a server certificate with the CA key
```
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 360
```

## Client

* Create a client key
```
openssl genrsa -out client.key 2048
```

* Create a client certificate request: in this case **common name** can be
used as a username if `use_identity_as_username` is set true in
`mostquitto.conf`. Otherwise you can leave it empty.
```
openssl req -new -key client.key -out client.csr -sha256
```

* Create a client certificiate with CA key
```
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 360
```

# Password File

You can use username / password authentication in place of X509 certificate
method. To do this, set `use_identity_as_username` as `false` and specify
`password_file` in `mosquitto.conf`

* Create a password file with an initial user
```
mosquitto_passwd -c <passwd file> <username>
```

* Add a new user to the existing password file
```
mosquitto_passwd -b <password file> <new user> <password>
```

The sample file (`passwd`) has three entries.
```
user        password
sub_user    sub_password
pub_user    pub_password
```


# References

* [mosquitto-tls manpage](https://mosquitto.org/man/mosquitto-tls-7.html)
* [mosquitto.conf manpage](https://mosquitto.org/man/mosquitto-conf-5.html)
* [mosquitto_passwd manpage](https://mosquitto.org/man/mosquitto_passwd-1.html)
* [mosquitto_pub manpage](https://mosquitto.org/man/mosquitto_pub-1.html)
* [mosquitto_sub manpage](https://mosquitto.org/man/mosquitto_sub-1.html)
* [mosquitto.conf](https://github.com/eclipse/mosquitto/blob/master/mosquitto.conf)
* [openssl manpage](https://www.openssl.org/docs/man1.0.2/man1/openssl.html)
* [openssl req manpage](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html)
* [openssl x509 manpage](https://www.openssl.org/docs/man1.0.2/man1/x509.html)
* [CONNACK return code](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csd02/mqtt-v3.1.1-csd02.html#_Table_3.1_-)
* [stackoverflow: Mqtt TLS certificate verify failed](https://stackoverflow.com/questions/70110392/mqtt-tls-certificate-verify-failed-self-signed-certificate)

