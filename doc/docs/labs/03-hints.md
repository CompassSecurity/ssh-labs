# Hints

![Hints](../images/signpost.svg){width="100" align=right}

Here are some hints which guide you through the labs.

## On the attacker machine `kali`

- [ ] Perform service discovery in the network to identify all systems having an SSH server running.
- [ ] Identify the server which leaks a potential username in the welcome banner.
- [ ] Check if this system accepts password authentication.
- [ ] Brute-force the password of the potential user and perform a login to get the flag 1.

## On the server `linux-srv-01`

- [ ] Find the SSH private key.
- [ ] Figure out on which system this private key can be used to perform a login.
- [ ] This can be done manually or using an nmap script on the attacker host.
- [ ] Crack the passphrase of the used key.
- [ ] The necessary tools are on your attacker machine.
- [ ] Login on the system where the key can be used to login to get flag 2.

## On the server `linux-srv-02`

- [ ] Check if there are other user accounts on the system.
- [ ] Check for activities of other users on the system.
- [ ] Sniff the password of the user who logs in from time to time.
- [ ] Check where this user logged in before.
- [ ] Verify if the user reuses their password.
- [ ] Login on the system where the password is reused to get flag 3.

## On the server `linux-srv-03`

- [ ] Check your privileges.
- [ ] Check if there are other user accounts on the system.
- [ ] Check if this user has sensitive files which could be helpful.
- [ ] Find the user CA private key and the information where the user CA is already installed.
- [ ] Create a new SSH key pair.
- [ ] Sign the key pair with the CA private key.
- [ ] Login on the system where the CA is trusted to get flag 4.

## On the server `linux-srv-04`

- [ ] Check for other users on the system.
- [ ] Check where they logged in before.
- [ ] Check for interesting files on the system.
- [ ] Search for a socket file on the system.
- [ ] Use the socket file for authentication.
- [ ] Use the socket file for SSH agent hijacking to login on the next server to get flag 5.

## On the server `linux-srv-05`

- [ ] Check for other users on the system.
- [ ] Check the files of the other users.
- [ ] Check if the private key is password protected.
- [ ] Check if you can use the private key for authentication.
- [ ] Check if there are special SSH configuration of the user you can exploit.
- [ ] Search for a socket file on the system.
- [ ] Use the socket file to bypass authentication.
- [ ] Use the socket file for SSH session multiplexing hijacking to login on the next server to get flag 6.

## On the server `linux-srv-06`

- [ ] Search for interesting files on the system.
- [ ] Check if the private key is password protected.
- [ ] Check if you can find the required information for authentication.
- [ ] Generate a valid OTP.
- [ ] Use the private key and OTP to login on the next server to get flag 7.

## On the server `linux-srv-07`

- [ ] Read the final flag. Congratz, you are done 🐡.
