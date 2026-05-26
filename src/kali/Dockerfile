FROM kalilinux/kali-last-release

RUN apt-get update && apt-get install -y ssh vim less bc iputils-ping nmap autossh iproute2 sudo curl wget ncrack john ncat ssh-audit asciinema tmux sshpass

COPY srv /srv

COPY motd /etc/motd
COPY issue.net /etc/issue.net
COPY hostname /etc/hostname

COPY ssh /etc/ssh
RUN find /etc/ssh/ -name "ssh_host*key" -exec chmod 600 {} \;
COPY --chmod=600 sudoers /etc/sudoers

COPY root /root
RUN find /root -type d -exec chmod 700 {} \; && find /root -type f -exec chmod 600 {} \;

RUN useradd -m -s /bin/bash -G sudo kali
COPY kali /home/kali
RUN chown -R kali:kali /home/kali
RUN find /home/kali -type d -exec chmod 700 {} \; && find /home/kali -type f -exec chmod 600 {} \;
RUN echo kali:kali | chpasswd

CMD ["/srv/entrypoint"]
