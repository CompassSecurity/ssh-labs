FROM debian:13

RUN apt-get update && apt-get install -y ssh vim less bc iputils-ping nmap autossh iproute2 sudo curl wget sshpass

COPY --chmod=755 srv /srv
COPY motd /etc/motd
COPY hostname /etc/hostname
COPY issue.net /etc/issue.net
RUN rm /etc/update-motd.d/10-uname

COPY ssh /etc/ssh
RUN find /etc/ssh/ -name "ssh_host*key" -exec chmod 600 {} \;

COPY root /root
RUN find /root -type d -exec chmod 700 {} \; && find /root -type f -exec chmod 600 {} \;

COPY --chmod=600 sudoers /etc/sudoers

RUN useradd -m -s /bin/bash alice
COPY alice /home/alice
RUN chown -R alice:alice /home/alice
RUN find /home/alice -type d -exec chmod 700 {} \; && find /home/alice -type f -exec chmod 600 {} \;

RUN useradd -m -s /bin/bash carol
COPY carol /home/carol
RUN chown -R carol:carol /home/carol
RUN find /home/carol -type d -exec chmod 700 {} \; && find /home/carol -type f -exec chmod 600 {} \;

RUN useradd -m -s /bin/bash dave
COPY dave /home/dave
RUN chown -R dave:dave /home/dave
RUN find /home/dave -type d -exec chmod 700 {} \; && find /home/dave -type f -exec chmod 600 {} \;

CMD ["/srv/entrypoint"]
