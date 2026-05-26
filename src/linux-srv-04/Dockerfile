FROM debian:13

RUN apt-get update && apt-get install -y ssh vim less bc iputils-ping nmap autossh iproute2 sudo curl wget

COPY srv /srv
COPY motd /etc/motd
COPY hostname /etc/hostname
COPY issue.net /etc/issue.net
RUN rm /etc/update-motd.d/10-uname

COPY ssh /etc/ssh
RUN find /etc/ssh/ -name "ssh_host*key" -exec chmod 600 {} \;

COPY root /root
RUN find /root -type d -exec chmod 700 {} \; && find /root -type f -exec chmod 600 {} \;

COPY --chmod=600 sudoers /etc/sudoers

RUN useradd -m -s /bin/bash carol
COPY carol /home/carol
RUN chown -R carol:carol /home/carol
RUN find /home/carol -type d -exec chmod 700 {} \; && find /home/carol -type f -exec chmod 600 {} \;

RUN useradd -m -s /bin/bash -G sudo trent
COPY trent /home/trent
RUN chown -R trent:trent /home/trent
RUN find /home/trent -type d -exec chmod 700 {} \; && find /home/trent -type f -exec chmod 600 {} \;

COPY flag.txt /
RUN chmod 644 /flag.txt

CMD ["/srv/entrypoint"]
