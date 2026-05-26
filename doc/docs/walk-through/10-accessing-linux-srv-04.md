# Accessing `linux-srv-04`

## Login as `trent`

We are still logged in on `linux-srv-04` as `trent`:

```shell-session
trent@linux-srv-04:~$ hostname
linux-srv-04.nullbyte.internal
trent@linux-srv-04:~$ id
uid=1001(trent) gid=1001(trent) groups=1001(trent),27(sudo)
```

## Flag

Get the flag:

```shell-session
trent@linux-srv-04:~$ cat /flag.txt 
ssh-labs{trent-should-not-be-trusted}
```

## Information Gathering User `carol`

Start a shell as `root`:

```shell-session
trent@linux-srv-04:~$ sudo -i

root@linux-srv-04:~# id
uid=0(root) gid=0(root) groups=0(root)
```

Check which processes are running from which users:

```shell-session
root@linux-srv-04:~# ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 Feb04 ?        00:00:00 bash /srv/entrypoint
root           8       1  0 Feb04 ?        00:00:00 sshd: /usr/sbin/sshd -E /var/log/sshd [listener]
root           9       1  0 Feb04 ?        00:00:06 tail -f /dev/null
root          10       8  0 Feb04 ?        00:00:00 sshd-session: carol [priv]
carol         15      10  0 Feb04 ?        00:00:00 sshd-session: carol@pts/0
carol         16      15  0 Feb04 pts/0    00:00:00 -bash
root          22       0  0 07:28 pts/1    00:00:00 sh
root          28      22  0 07:28 pts/1    00:00:00 bash -i
root          36      28  0 07:28 pts/1    00:00:00 sudo -i
root          38      36  0 07:28 pts/2    00:00:00 sudo -i
root          39      38  0 07:28 pts/2    00:00:00 -bash
root          76       8  0 07:36 ?        00:00:00 sshd-session: trent [priv]
trent         81      76  0 07:36 ?        00:00:00 sshd-session: trent@pts/3
trent         82      81  0 07:36 pts/3    00:00:00 -bash
root         105      82  0 07:42 pts/3    00:00:00 sudo -i
root         107     105  0 07:42 pts/4    00:00:00 sudo -i
root         108     107  0 07:42 pts/4    00:00:00 -bash
root         125     108  0 07:43 pts/4    00:00:00 ps -ef
```

- The user `carol` is logged in via SSH

Check the files of carol:

```shell-session
root@linux-srv-04:~# cd /home/carol/

root@linux-srv-04:/home/carol# ls -la
total 40
drwx------ 1 carol carol 4096 Sep  9 18:33 .
drwxr-xr-x 1 root  root  4096 Sep  9 18:33 ..
-rw------- 1 carol carol 2009 Sep  9 18:29 .bash_history
-rw-r--r-- 1 carol carol  220 Jul 30 19:28 .bash_logout
-rw-r--r-- 1 carol carol 3526 Jul 30 19:28 .bashrc
-rw-r--r-- 1 carol carol  807 Jul 30 19:28 .profile
drwx------ 1 carol carol 4096 Sep  9 18:22 .ssh

root@linux-srv-04:/home/carol# ls -l .ssh
total 8
-rw------- 1 carol carol 595 Sep  9 18:01 authorized_keys
-rw------- 1 carol carol 151 Sep  9 17:49 known_hosts
```

- No private keys available.

Check the known hosts file:

```shell-session
root@linux-srv-04:/home/carol# cat .ssh/known_hosts 
#
# ~/.ssh/known_hosts
#

linux-srv-05.nullbyte.internal,linux-srv-05 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlig98MUDupb6CqSd4gvYPIw8EvMzH7TMe2ere2o/W6
```

- `carol` probably logged in on `linux-srv-05`.

Verify in the bash history, if this system was accessed:

```shell-session
root@linux-srv-04:/home/carol# grep ssh .bash_history 
ssh linux-srv-05
```

- This confirms our conclusion.

## Authentication Configuration of `linux-srv-05`


Connect to `linux-srv-05` as `carol`:

```shell-session
root@linux-srv-04:/home/carol# ssh -v carol@linux-srv-05
[...]

debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
[...]
debug1: No more authentication methods to try.
carol@linux-srv-05: Permission denied (publickey).
```

- This system does only support public key authentication and no password authentication.
- No SSH keys of `carol` were found.

According to the bash history, `carol` performed a login to `linux-srv-05` from this system. The login must have been performed using public keys, because the server only supports this method. The keys must therefore be stored on another system. Maybe `carol` used SSH agent forwarding.

## Searching for Sockets

Search for sockets on the file system:

```shell-session
root@linux-srv-04:/home/carol# find / -type s -ls 2>/dev/null
  5029187      0 srwxrwxr-x   1 carol    carol           0 Sep 10 13:30 /tmp/ssh-Wl1006hh94/agent.16
```

- There is a socket `/tmp/ssh-Wl1006hh94/agent.16` (the directory and file name is different every time a new lab is started).
- The ownership of the socket tells that this is a socket of `carol`.
- The socket name indicates that this could be an SSH agent socket.
