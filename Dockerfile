FROM ubuntu:bionic 
MAINTAINER Alex Petrin <shoroop.spb@gmail.com>

#announce that we haven't interactive console
ENV DEBIAN_FRONTEND noninteractive

#defining rcon pass, it's easier to make it here
ENV rcon_pass fuckchangemepass

#exposing working port
EXPOSE 7777

#adding s6 overlay archive
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz /tmp/

#installing s6 overlay
RUN tar xvzf /tmp/s6-overlay-amd64.tar.gz -C /

#adding entrypoint
ENTRYPOINT ["/init"]

#adding i386 arch
RUN dpkg --add-architecture i386

#updating system
RUN apt-get update && apt-get upgrade -y

#installing other missing stuff
RUN apt-get install libstdc++6:i386 -y

#making samp dir
RUN mkdir /var/samp

#downloading samp03svr binaries
ADD http://files.sa-mp.com/samp037svr_R2-1.tar.gz /var/samp

#unpacking samp03svr tarball
RUN tar xvzf /var/samp/samp037svr_R2-1.tar.gz -C /var/samp

#using new samp dir (I am too lazy to move samp03 dir)
WORKDIR /var/samp/samp03

#copying from etc dir
COPY etc/. .

#replacing rcon pass in server.cfg
RUN sed -i "s/changeme/${rcon_pass}/g" server.cfg

#chmodding binaries
RUN chmod +x samp-npc samp03svr announce

#finally, run samp03svr
CMD ["/var/samp/samp03/samp03svr"]
