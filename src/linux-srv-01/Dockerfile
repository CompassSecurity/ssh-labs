FROM debian:13

RUN apt-get update && apt-get install -y ssh vim less bc iputils-ping autossh iproute2 sudo curl wget

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

RUN useradd -m -s /bin/bash bob
RUN echo bob:flower | chpasswd
COPY bob /home/bob
RUN chown -R bob:bob /home/bob
RUN find /home/bob -type d -exec chmod 700 {} \; && find /home/bob -type f -exec chmod 600 {} \;

COPY flag.txt /
RUN chmod 644 /flag.txt

CMD ["/srv/entrypoint"]
