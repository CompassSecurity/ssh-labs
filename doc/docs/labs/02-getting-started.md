# Getting Started

## Starting the Lab

As a prerequisite, you need to have Docker installed on your system. See the official Docker [install instructions](https://docs.docker.com/engine/install/).

Download the SSH labs Docker compose file:

```{.bash .copy}
curl -O https://raw.githubusercontent.com/CompassSecurity/ssh-labs/refs/heads/main/compose.yml
```

Start the labs:

```
docker compose up
```


Wait until the images are built and started.

## Accessing the Attacker's Machine

The attacker container is a Kali Linux and exposes the SSH service on port `2222/tcp` on your system's loopback interface:

```shell-session
$ sudo ss -ltpn | grep 2222
LISTEN 0      4096       127.0.0.1:2222      0.0.0.0:*    users:(("docker-proxy",pid=309855,fd=7))
```

Perform a login with the username `kali` and password `kali`:

```shell-session
$ ssh -p 2222 kali@127.0.0.1
The authenticity of host '[127.0.0.1]:2222 ([127.0.0.1]:2222)' can't be established.
ED25519 key fingerprint is SHA256:x6DqaqX5LPrg2zPvppatVu2BYO0UqBwVoFlWlDwIk+0.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[127.0.0.1]:2222' (ED25519) to the list of known hosts.
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
  #    ..............                                           #
  #                ..,;:ccc,.                                   #
  #              ......''';lxO.                                 #
  #    .....''''..........,:ld;                                 #
  #               .';;;:::;,,.x,                                #
  #          ..'''.            0Xxoc:,.  ...                    #
  #      ....                ,ONkc;,;cokOdc',.                  #
  #     .                   OMo           ':ddo.                #
  #                        dMc               :OO;               #
  #                        0M.                 .:o.             #
  #                        ;Wd                                  #
  #                         ;XO,                                #
  #                           ,d0Odlc;,..                       #
  #                               ..',;:cdOOd::,.               #
  #                                        .:d;.':;.            #
  #       Kali Linux                          'd,  .'           #
  #                                             ;l   ..         #
  #           Attacker Machine                   .o             #
  #                                                c            #
  #               Compass Security SSH Labs        .'           #
  #                                                             #
  #                                                             #
  ###############################################################
  #                                                             #
  #  Login to this attacker machine via SSH:                    #
  #                                                             #
  #  $ ssh -p 2222 kali@127.0.0.1                               #
  #                                                             #
  #  Password: kali                                             #
  #                                                             #
  ###############################################################

kali@127.0.0.1's password:

kali@kali:~$
```

You can now use the attacker machine:

```shell-session
kali@kali:~$ id
uid=1000(kali) gid=1000(kali) groups=1000(kali),27(sudo)

kali@kali:~$ hostname
kali
```

![Alice](../images/alice.svg){width="100"}

You are now ready to start the lab. Have fun!

## Stopping the Lab

Press Ctrl-C in the terminal where you started the labs to stop it.