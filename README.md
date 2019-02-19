SA:MP 0.3.7 server in a docker image.

Features:
* Ubuntu 18.04 (ubuntu:bionic) as a base image
* [s6 overlay](https://github.com/just-containers/s6-overlay) for autostart
* all libraries from official repos for make clean samp03svr work are included (see Dockerfile for details)

Requirements:
* docker
* docker-compose

How to use:
* copy any files for server you need to ./etc directory (please do not replace samp03svr, samp-npc and announce, otherwise I won't be responsible for working)
* build container with ``docker-compose build``
* run container with ``docker-compose up -d`` (it'll be launched in foreground)

Please note: I am not responsible for technical problems with plugins that you want to use - if you want to use dynamically linked plugins, you should change my Dockerfile and install it by yourself. Otherwise, you can just use static versions of plugins you need.
