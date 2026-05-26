FROM debian:13

RUN apt-get update && apt-get install -y ssh vim less bc iputils-ping nmap autossh iproute2 sudo curl wget libpam-google-authenticator oathtool

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

COPY opt /opt
COPY sshd /etc/pam.d/sshd

RUN useradd -m -s /bin/bash -G sudo frank
COPY frank /home/frank
RUN chown -R frank:frank /home/frank
RUN find /home/frank -type d -exec chmod 700 {} \; && find /home/frank -type f -exec chmod 600 {} \;

COPY flag.txt /
RUN chmod 644 /flag.txt

CMD ["/srv/entrypoint"]
