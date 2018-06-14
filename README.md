# Docker alpine-ext images

Alpine Linux Docker image with additional stuff included

## Tags
* 1.2-rich (based on alpine:3.7 - with edge repositories)
* 1.3-rich (based on alpine:3.7 - with edge repositories)

### About the *-rich tags
Alpine Linux with following packages installed:
* `bash`
* `dropbear`
* `openssh`
* `sudo`
* `iptables`
* `openjdk8`
* `rsync`
* `dstat`
* `curl`
* `procps`

The **[dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html)** is a lightweight SSH server and client.

The image uses a new `/docker-entrypoint.sh` script to configure and start the SSH server.

The OpenSSH server is not started in the default configuration. The package is installed mainly to provide `scp` and `sftp-server`
functionality to the `dropbear`.

The image adds new `alpine` user which has entry in `sudoers` file.
Password for the user  is generated and stored in `/tmp/password.alpine`. The root's password is also stored on filesystem (`/tmp/password.root`) and in case it's not provided by environment variable it's newly generated.

#### Environment variables
The environment variables can be used to configure SSH server

| Variable      | Default | Description |
| ------------- | ------- |---------|
| SSH_PORT      | 22      | TCP port on which SSH server will be started |
| ROOT_PASSWORD |         | root's password |
| ROOT_AUTHORIZED_KEY |   | entry to be added to /root/.ssh/authorized_keys |
| USER_PASSWORD |         | alpine user's password |
| USER_AUTHORIZED_KEY |   | entry to be added to /home/alpine/.ssh/authorized_keys |

## Sample usage

Start the container with root's password configured to `"alpine"`.
The dropbear SSH server will run on foreground.

```bash
docker run -e "ROOT_PASSWORD=alpine" -it kwart/alpine
```

Start the container with SSH private key authentication configured.
The `dropbear` SSH server will run on background and `bash` on foreground

```bash
docker run -e "ROOT_AUTHORIZED_KEY=`cat ~/.ssh/id_rsa.pub`" -it kwart/alpine /bin/bash
```
