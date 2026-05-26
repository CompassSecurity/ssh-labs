# Service Discovery

## Get Network Information

Check in which network your attacker machine:

```shell-session
kali@kali:~$ ip addr list
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host proto kernel_lo 
       valid_lft forever preferred_lft forever
2: eth0@if284: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 06:b8:56:c8:a0:15 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.5.23.5/24 brd 10.5.23.255 scope global eth0
       valid_lft forever preferred_lft forever

kali@kali:~$ ip route
default via 10.5.23.1 dev eth0 
10.5.23.0/24 dev eth0 proto kernel scope link src 10.5.23.5 
```

- The network is `10.5.23.0/24`

All other SSH servers will be in the same network.

## Portscan

Perform a TCP SYN scan using `nmap` on port `22/tcp` to detect running SSH services. You can use `/24` to speed up the scanning process. The servers should be in this range:

```shell-session
kali@kali:~$ sudo nmap -n -Pn -p 22 --open --reason -oA nmap_ssh 10.5.23.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2026-02-03 15:51 UTC

Nmap scan report for 10.5.23.11
Host is up, received arp-response (0.000043s latency).

PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 64
MAC Address: A6:0E:C2:C2:18:7E (Unknown)

Nmap scan report for 10.5.23.12
Host is up, received arp-response (0.000024s latency).

PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 64
MAC Address: 06:A1:82:B8:8E:ED (Unknown)

Nmap scan report for 10.5.23.14
Host is up, received arp-response (0.000075s latency).

PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 64
MAC Address: BA:EC:D1:D1:DF:F3 (Unknown)

Nmap scan report for 10.5.23.15
Host is up, received arp-response (0.000021s latency).

PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 64
MAC Address: 8E:B1:90:0D:F7:73 (Unknown)

Nmap scan report for 10.5.23.16
Host is up, received arp-response (0.000031s latency).

PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 64
MAC Address: EE:AF:FA:BC:CD:B3 (Unknown)

Nmap scan report for 10.5.23.5
Host is up, received user-set (0.00019s latency).

PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 64

Nmap done: 256 IP addresses (9 hosts up) scanned in 2.11 seconds
```

Get an overview about these systems (`sort -V` is used to sort by IP address):

```shell-session
kali@kali:~$ grep /open nmap_ssh.gnmap | sort -V
Host: 10.5.23.5 ()	Ports: 22/open/tcp//ssh///
Host: 10.5.23.11 ()	Ports: 22/open/tcp//ssh///
Host: 10.5.23.12 ()	Ports: 22/open/tcp//ssh///
Host: 10.5.23.13 ()	Ports: 22/open/tcp//ssh///
Host: 10.5.23.14 ()	Ports: 22/open/tcp//ssh///
Host: 10.5.23.15 ()	Ports: 22/open/tcp//ssh///
Host: 10.5.23.16 ()	Ports: 22/open/tcp//ssh///
Host: 10.5.23.17 ()	Ports: 22/open/tcp//ssh//
```

- Several servers have port `22/tcp` open.
- You will also see an additional host `10.5.23.1` if you have SSH running on your local system where Docker is running.