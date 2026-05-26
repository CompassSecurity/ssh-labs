# Information Gathering

## Server Banner

Get the banner of some SSH servers using `ncat`. Terminate the open TCP connection via Ctrl-C (`^C`):

```shell-session
kali@kali:~$ ncat -v 10.5.23.11 22
Ncat: Version 7.95 ( https://nmap.org/ncat )
Ncat: Connected to 10.5.23.11:22.
SSH-2.0-OpenSSH_10.0p2 Debian-7
^C

kali@kali:~$ ncat -v 10.5.23.13 22
Ncat: Version 7.95 ( https://nmap.org/ncat )
Ncat: Connected to 10.5.23.13:22.
SSH-2.0-OpenSSH_10.0p2
^C
```

- The SSH protocol version is shown (`SSH-2.0`)
- The SSH server software version is shown (`OpenSSH_10.0p2`)
- Some servers show the used distribution (`Debian-7`)

Get the banner of all SSH servers using `nmap`:

```shell-session
kali@kali:~$ sudo nmap -n -Pn -p 22 --open -sV -oA nmap_ssh_banner 10.5.23.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2026-02-04 12:43 UTC

Nmap scan report for 10.5.23.11
Host is up (0.000017s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
MAC Address: 0A:EE:44:67:86:B0 (Unknown)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Nmap scan report for 10.5.23.12
Host is up (0.000022s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.0p2 (protocol 2.0)
MAC Address: 32:53:DF:C4:4E:FE (Unknown)

Nmap scan report for 10.5.23.13
Host is up (0.000035s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.0p2 (protocol 2.0)
MAC Address: 46:5A:CA:AB:FD:55 (Unknown)

Nmap scan report for 10.5.23.14
Host is up (0.00011s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
MAC Address: 42:58:0E:1F:2C:13 (Unknown)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Nmap scan report for 10.5.23.15
Host is up (0.000027s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
MAC Address: C2:D4:E2:94:FE:13 (Unknown)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Nmap scan report for 10.5.23.16
Host is up (0.000042s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.0p2 (protocol 2.0)
MAC Address: BA:26:29:C0:1C:49 (Unknown)

Nmap scan report for 10.5.23.5
Host is up (0.00012s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.2p1 Debian 2 (protocol 2.0)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 256 IP addresses (9 hosts up) scanned in 2.40 seconds
```

Get an overview:

```shell-session
kali@kali:~$ grep /open nmap_ssh_banner.gnmap | sort -V
Host: 10.5.23.5 ()	Ports: 22/open/tcp//ssh//OpenSSH 10.2p1 Debian 2 (protocol 2.0)/
Host: 10.5.23.11 ()	Ports: 22/open/tcp//ssh//OpenSSH 10.0p2 Debian 7 (protocol 2.0)/
Host: 10.5.23.12 ()	Ports: 22/open/tcp//ssh//OpenSSH 10.0p2 (protocol 2.0)/
Host: 10.5.23.13 ()	Ports: 22/open/tcp//ssh//OpenSSH 10.0p2 (protocol 2.0)/
Host: 10.5.23.14 ()	Ports: 22/open/tcp//ssh//OpenSSH 10.0p2 Debian 7 (protocol 2.0)/
Host: 10.5.23.15 ()	Ports: 22/open/tcp//ssh//OpenSSH 10.0p2 Debian 7 (protocol 2.0)/
Host: 10.5.23.16 ()	Ports: 22/open/tcp//ssh//OpenSSH 10.0p2 (protocol 2.0)/
Host: 10.5.23.17 ()	Ports: 22/open/tcp//ssh//OpenSSH 10.0p2 (protocol 2.0)/
```

- The SSH protocol version is always shown.
- The SSH server version number is always shown.
- The distribution is not always shown.

## Welcome Banner

Get the welcome banner of a system by manually connecting to it:

```shell-session
kali@kali:~$ ssh 10.5.23.12
The authenticity of host '10.5.23.12 (10.5.23.12)' can't be established.
ED25519 key fingerprint is: SHA256:IxUqu5SO4uOPc4u7ANTSQ2VWh+T22BZPdhDl602bXRY
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.5.23.12' (ED25519) to the list of known hosts.

  ###############################################################
  #                                                             #
  #                          WARNING                            #
  #                     Access Restricted                       #
  #                                                             #
  ###############################################################
  #                                                             #
  #             Unauthorized access is prohibited.              #
  #      All activities performed are logged and monitored.     #
  #  Disconnect IMMEDIATELY if you are not an authorized user!  #
  #                                                             #
  ###############################################################

kali@10.5.23.12's password: 
^C
```

- Some information about the system is shown.

## SSH Authentication Methods

Connect to some systems via SSH. If password authentication is allowed, the password prompt is shown:

```shell-session
kali@kali:~$ ssh 10.5.23.11
The authenticity of host '10.5.23.11 (10.5.23.11)' can't be established.
ED25519 key fingerprint is: SHA256:ZfgeSHj4SBktQp/rkkKncqfrrqoqIeKxbiw7tMjmPDI
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.5.23.11' (ED25519) to the list of known hosts.

  ###############################################################
  #                                                             #
  #                          WARNING                            #
  #                     Access Restricted                       #
  #                                                             #
  ###############################################################
  #                                                             #
  #             Unauthorized access is prohibited.              #
  #      All activities performed are logged and monitored.     #
  #  Disconnect IMMEDIATELY if you are not an authorized user!  #
  #                                                             #
  ###############################################################
  #                                                             #
  #          The maintainer of this system is Bob.              #
  #   Contact bob@nullbyte.internal for questions or support.   #
  #                                                             #
  ###############################################################

kali@10.5.23.11's password: 
^C
```

If only public key authentication is supported, no password prompt is shown:

```shell-session
kali@kali:~$ ssh 10.5.23.14

  ###############################################################
  #                                                             #
  #                          WARNING                            #
  #                     Access Restricted                       #
  #                                                             #
  ###############################################################
  #                                                             #
  #             Unauthorized access is prohibited.              #
  #      All activities performed are logged and monitored.     #
  #  Disconnect IMMEDIATELY if you are not an authorized user!  #
  #                                                             #
  ###############################################################

kali@10.5.23.14: Permission denied (publickey).
^C
```

Enumerate the SSH authentication methods and welcome banners of all systems:

```shell-session
kali@kali:~$ sudo nmap -n -Pn -p 22 --open --script ssh-auth-methods -oA nmap_ssh_auth_methods 10.5.23.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2026-02-04 13:11 UTC

Nmap scan report for 10.5.23.11
Host is up (0.000016s latency).

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
MAC Address: 0A:EE:44:67:86:B0 (Unknown)

Nmap scan report for 10.5.23.12
Host is up (0.000022s latency).

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
|_
MAC Address: 32:53:DF:C4:4E:FE (Unknown)

Nmap scan report for 10.5.23.13
Host is up (0.000048s latency).

PORT   STATE SERVICE
22/tcp open  ssh
| ssh-auth-methods: 
|   Supported authentication methods: 
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
|_
MAC Address: 46:5A:CA:AB:FD:55 (Unknown)

Nmap scan report for 10.5.23.14
Host is up (0.000080s latency).

PORT   STATE SERVICE
22/tcp open  ssh
| ssh-auth-methods: 
|   Supported authentication methods: 
|     publickey
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
|_
MAC Address: 42:58:0E:1F:2C:13 (Unknown)

Nmap scan report for 10.5.23.15
Host is up (0.000020s latency).

PORT   STATE SERVICE
22/tcp open  ssh
| ssh-auth-methods: 
|   Supported authentication methods: 
|     publickey
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
|_
MAC Address: C2:D4:E2:94:FE:13 (Unknown)

Nmap scan report for 10.5.23.16
Host is up (0.000031s latency).

PORT   STATE SERVICE
22/tcp open  ssh
| ssh-auth-methods: 
|   Supported authentication methods: 
|     publickey
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
|   #      This sensitive host requires 2FA authentication.       #
|   #      Please enroll 2FA first before you authenticate.       #
|   #                                                             #
|   ###############################################################
|_
MAC Address: BA:26:29:C0:1C:49 (Unknown)

Nmap scan report for 10.5.23.5
Host is up (0.000097s latency).

PORT   STATE SERVICE
22/tcp open  ssh
| ssh-auth-methods: 
|   Supported authentication methods: 
|     publickey
|     password
|   Banner:  
|   ################################################################
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
|   #    ..............                                           #
|   #                ..,;:ccc,.                                   #
|   #              ......''';lxO.                                 #
|   #    .....''''..........,:ld;                                 #
|   #               .';;;:::;,,.x,                                #
|   #          ..'''.            0Xxoc:,.  ...                    #
|   #      ....                ,ONkc;,;cokOdc',.                  #
|   #     .                   OMo           ':ddo.                #
|   #                        dMc               :OO;               #
|   #                        0M.                 .:o.             #
|   #                        ;Wd                                  #
|   #                         ;XO,                                #
|   #                           ,d0Odlc;,..                       #
|   #                               ..',;:cdOOd::,.               #
|   #                                        .:d;.':;.            #
|   #       Kali Linux                          'd,  .'           #
|   #                                             ;l   ..         #
|   #           Attacker Machine                   .o             #
|   #                                                c            #
|   #               Compass Security SSH Labs        .'           #
|   #                                                             #
|   #                                                             #
|   ###############################################################
|   #                                                             #
|   #  Login to this attacker machine via SSH:                    #
|   #                                                             #
|   #  $ ssh -p 2222 kali@127.0.0.1                               #
|   #                                                             #
|   #  Password: kali                                             #
|   #                                                             #
|   ###############################################################
|_

Nmap done: 256 IP addresses (9 hosts up) scanned in 2.31 seconds
```

- Some systems only allow `publickey` authentication.
- Some systems allow `password` authentication.
- One system discloses a potential username `bob`. 
- One systems probably requires MFA according to the welcome banner.
- The other systems do not disclose more information in the welcome banner.
- One system is your attacker machine.
