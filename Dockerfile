FROM ubuntu:bionic 
MAINTAINER Alex Petrin <shoroop.spb@gmail.com>

#announce that we have'n interactive console
ENV DEBIAN_FRONTEND noninteractive

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

#updating system and installing locales
RUN apt-get update && apt-get upgrade -y && apt-get install language-pack-en language-pack-ru -y

#installing build-essential, ia32-libs and other missing stuff
RUN apt-get install build-essential lib32ncurses5 lib32z1 libstdc++6:i386 -y

#making samp dir
RUN mkdir /var/samp

#downloading samp03svr binaries
ADD http://files.sa-mp.com/samp037svr_R2-1.tar.gz /var/samp

#unpack samp03svr
RUN tar xvzf /var/samp/samp037svr_R2-1.tar.gz -C /var/samp

#use new samp dir (I am too lazy to move samp03 dir)
WORKDIR /var/samp/samp03

#chmod binaries
RUN chmod +x samp-npc samp03svr announce

#copying from etc dir
COPY etc/. .

#run samp03svr
CMD ["/var/samp/samp03/samp03svr"]
