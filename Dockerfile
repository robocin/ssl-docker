FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# essentials
RUN apt-get update           \
    && apt-get install -y    \
    build-essential          \
    cmake                    \
    wget                     \
    unzip                    \
    git                      \
    sudo                     \
    protobuf-compiler        \
    nano                     \
    python3                  \
    python3-pip              \
    libdbus-1-3              \
    libpulse-mainloop-glib0  \
    qt5-default              \
    libgl1-mesa-dev          \
    libxkbcommon-x11-0       \
    libpulse-dev             \
    && apt-get clean

# qmake
RUN pip3 install aqtinstall

ARG QT=5.15.1
ARG QT_MODULES=all
ARG QT_HOST=linux
ARG QT_TARGET=desktop
ARG QT_ARCH=
RUN aqt install --outputdir /opt/qt ${QT} ${QT_HOST} ${QT_TARGET} ${QT_ARCH} -m ${QT_MODULES}

ENV PATH /opt/qt/${QT}/gcc_64/bin:$PATH
ENV QT_PLUGIN_PATH /opt/qt/${QT}/gcc_64/plugins/
ENV QML_IMPORT_PATH /opt/qt/${QT}/gcc_64/qml/
ENV QML2_IMPORT_PATH /opt/qt/${QT}/gcc_64/qml/

# open-gl
RUN apt-get install freeglut3 freeglut3-dev -y

# ssl-coach
WORKDIR /home/ssl-coach

ARG GITHUB_TOKEN
RUN git init && \
    git config user.email robocin@cin.ufpe.br && \
    git config user.name robocinufpe && \
    export GITHUB_ACCESS_TOKEN=${GITHUB_TOKEN} && \
    git pull https://$GITHUB_ACCESS_TOKEN:x-oauth-basic@github.com/robocin/ssl-coach.git larc-2020

# spdlog
WORKDIR /home/ssl-coach
RUN sh scripts/install_spdlog.sh

# compile protobuf
WORKDIR /home/ssl-coach/libs/pb/proto
RUN sh compile.sh

# compile ssl-coach
WORKDIR /home/ssl-coach
RUN qmake ssl-coach.pro -spec linux-g++ && make -j8

# compile run-ssl-coach
WORKDIR /home/ssl-coach/run-ssl-coach
RUN qmake run-ssl-coach.pro -spec linux-g++ && make -j8

WORKDIR /home/ssl-coach
