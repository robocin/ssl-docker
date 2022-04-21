FROM robocupssl/ubuntu-vnc:latest

USER root

# ssl-unification
RUN git clone --recursive https://github.com/robocin/soccer-common.git -b 'release/amistoso' && \
    cd soccer-common/scripts && \
    ./setup.py --essentials && \
    cd ../.. && \
    rm -r soccer-common

USER default



