FROM ubuntu:bionic 
MAINTAINER Alex Petrin <shoroop.spb@gmail.com>

#announce that we haven't interactive console
ENV DEBIAN_FRONTEND noninteractive

#defining rcon pass, it's easier to make it here
ENV rcon_pass fuckchangemepass

#exposing working port
EXPOSE 7777

#adding i386 arch and update packets and install libstdc++
RUN dpkg --add-architecture i386 \
        && apt-get update && apt-get upgrade -y \
        && apt-get install libstdc++6:i386 wget -y

#adding s6 overlay
RUN wget https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz -O /tmp/s6-overlay-amd64.tar.gz \
	&& tar xvzf /tmp/s6-overlay-amd64.tar.gz -C /

#adding entrypoint
ENTRYPOINT ["/init"]

#unpacking samp server files
RUN mkdir /var/samp \
	&& wget http://files.sa-mp.com/samp037svr_R2-1.tar.gz -O /tmp/samp037svr_R2-1.tar.gz \
	&& tar xvzf /tmp/samp037svr_R2-1.tar.gz -C /var/samp

#using new samp dir (I am too lazy to move samp03 dir)
WORKDIR /var/samp/samp03

#copying from etc dir
COPY etc/. .

#removing server_log.txt if it exists and create a symlink to stdout (to make logs be readable from docker logs)
RUN rm -f server_log.txt && ln -s /dev/stdout server_log.txt

#replacing rcon pass in server.cfg
RUN sed -i "s/changeme/${rcon_pass}/g" server.cfg

#chmodding binaries
RUN chmod +x samp-npc samp03svr announce

#finally, run samp03svr
CMD ["/var/samp/samp03/samp03svr"]
