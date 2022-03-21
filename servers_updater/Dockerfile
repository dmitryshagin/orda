FROM ubuntu:18.04

RUN apt update && apt install -y sshpass

COPY servers_update.sh /
COPY init.sh /

CMD ["/servers_update.sh", "/servers/servers.txt"]
