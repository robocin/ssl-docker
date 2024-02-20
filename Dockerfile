FROM robocupssl/ubuntu-vnc:latest

USER root

RUN apt update && apt upgrade -y && apt install python3-pip -y

# ssl-unification
RUN git clone --recursive https://github.com/robocin/soccer-common.git && \
    cd soccer-common/scripts && \
    ./setup.py --essentials && \
    ./setup.py --install zlib && \
    cd ../.. && \
    rm -r soccer-common

USER default



