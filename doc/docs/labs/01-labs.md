# Labs

## Introduction

![Servers](../images/lightbulb.svg){width="100" align=right}

By working through the labs, you will get an insight into different areas of SSH
security, including:

- Information Gathering: Discover SSH services int the network and get more information like the banners or supported authentication mechanisms.
- Brute-force attacks against passwords and SSH keys.
- Sniffing passwords and reuse them on other systems.
- Compromising an SSH User CA and create arbitrary SSH keys to login on other systems.
- Lateral movement techniques by abusing insecurely used SSH features like SSH agent forwarding or connection multiplexing.

## System Requirements

![Whale](../images/whale.svg){width="100" align=right}

The labs can be started on your local system using a Docker Compose file. You
need a system where Docker and Docker Compose is installed. Check out the
[Docker documentation](https://docs.docker.com/engine/install/) for installation
instructions or read the documentation of your Linux distribution.

## Learning-Style

![Servers](../images/learning.svg){width="100" align=right}

You can approach the SSH labs in several ways, depending on your experience, available time, and preferred learning style.

### CTF

If you already understand how SSH works, have watched the companion SSH video and have the time and motivation, you can attempt the labs in a [CTF-style format](02-ctf-style.html) without any guidance.

Start by accessing the attacker machine. Your task is to retrieve the contents of `/flag.txt` from every Linux server on the network that is running an SSH service.

The flag format is `ssh-labs{...}`.

### Hints

If you try the CTF approach and get stuck, or if you’d like some hints without seeing full solutions, you can check out the [hints](03-hints.html) showing you the steps required to complete the lab.

### Walk-Through

If you are completely stuck in the CTF, if SSH is completely new to you or if
you have only limited time,  you can follow the full
[walk-through](/walk-through/00-walk-through.html) with step by step
instructions.