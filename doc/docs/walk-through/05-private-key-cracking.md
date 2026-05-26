# Private Key Cracking

## Prepare Cracking

Convert the key to a form which is suitable for the the password cracking tool John the Ripper (`john`):

```shell-session
kali@kali:~$ ssh2john id_ed25519 > id_ed25519.john

kali@kali:~$ cat id_ed25519.john 
id_ed25519:$sshng$6$16$0aef5e809b66d5b47433f652a5ab89ea$290$6f70656e7373682d6b65792d7631000000000a6165733235362d6374720000000662637279707400000018000000100aef5e809b66d5b47433f652a5ab89ea0000001800000001000000330000000b7373682d65643235353139000000206e7bafb0c0e5d72abfc6f7f77037bf857f8389ff7975028030cd694a1bc0d2ab000000a048bcf2105613042ac5005104901ce5f7a3f5b699175c3fc39be24398fc964818833c90f434a5d98d85da8f0cdefa03f4e995ecc2c068c9867f441b74b189cad1f62ff6658ecfce8c028b7cdd6c88947fec1ec610564d1006c83a25f0584cc1efe7d0549be974b69a7afc11aad7fd31f0990830508f40254a2e00445d0b9f3050efe64ad06819c357428323e59037ed8714590302e53d33aae8fca04a93d863a5$24$130
```

## Crack the Key

Crack the passphrase:

```shell-session
kali@kali:~$ john -wordlist=/usr/share/ncrack/default.pwd id_ed25519.john 
Loaded 1 password hash (SSH, SSH private key [RSA/DSA/EC/OPENSSH 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 2 for all loaded hashes
Cost 2 (iteration count) is 24 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
brandon1         (id_ed25519)     
1g 0:00:00:19 DONE (2025-09-10 14:57) 0.05159g/s 29.72p/s 29.72c/s 29.72C/s sporting..motorola
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 
```

- The passphrase is `brandon1`.
- The passphrase was found after `19` seconds.
- `john` could try about 30 passwords / second.
- This is about 15 times faster than the online brute-force attack.

The cracking speed of course depends on your system performance. A dedicated cracking system with several GPUs and optimized software like `hashcat` would be much faster.