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
    net-tools                \ 
    && apt-get clean

# qmake
RUN pip3 install aqtinstall

ARG QT=5.15.2
ARG QT_MODULES='core network widgets opengl gui gamepad'
ARG QT_HOST=linux
ARG QT_TARGET=desktop
ARG QT_ARCH=
RUN aqt install --outputdir /opt/qt ${QT} ${QT_HOST} ${QT_TARGET} ${QT_ARCH}

ENV PATH /opt/qt/${QT}/gcc_64/bin:$PATH
ENV QT_PLUGIN_PATH /opt/qt/${QT}/gcc_64/plugins/
ENV QML_IMPORT_PATH /opt/qt/${QT}/gcc_64/qml/
ENV QML2_IMPORT_PATH /opt/qt/${QT}/gcc_64/qml/

# open-gl
RUN apt-get install freeglut3 freeglut3-dev -y

# spdlog
RUN cd .. && \
    mkdir spdlog && \
    cd spdlog && \
    wget https://github.com/gabime/spdlog/archive/v1.6.1.zip && \
    unzip v1.6.1.zip && \
    cd spdlog-1.6.1 && \
    mkdir build && \
    cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --config Release && \
    cd build && \
    sudo make install -j4 && \
    cd ../../.. && \
    sudo rm -r spdlog

# ssl-coach
WORKDIR /home

ARG GITHUB_TOKEN
RUN export GITHUB_ACCESS_TOKEN=${GITHUB_TOKEN} && \
    git clone https://$GITHUB_ACCESS_TOKEN:x-oauth-basic@github.com/robocin/ssl-coach.git -b passKickOff && \
    cd ssl-coach/src/Communication && \
    rm -r CommBst && \
    git clone https://$GITHUB_ACCESS_TOKEN:x-oauth-basic@github.com/robocin/communication-software.git CommBst && \
    cd CommBst && \
    git reset --hard 00027e9ec1bc0aa46ecb642e0b243b1e0ce154bb && \
    cd libs/communication && \
    rm -r nRF24Communication && \
    git clone https://$GITHUB_ACCESS_TOKEN:x-oauth-basic@github.com/robocin/communication-embedded.git nRF24Communication && \
    cd nRF24Communication && \
    git reset --hard 98aacebd25229155267fc6f0774cd4a72fde199f

WORKDIR /home/ssl-coach
RUN git config user.email robocin@cin.ufpe.br && \ 
    git config user.name robocinufpe

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

# remove source
RUN rm -r src