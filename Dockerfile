FROM robocupssl/ubuntu-vnc:latest

USER root

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
    gedit                    \
    bash                     \
    && apt-get clean

# ssl-coach install
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
RUN mkdir spdlog && \
    cd spdlog && \
    wget https://github.com/gabime/spdlog/archive/v1.6.1.zip && \
    unzip v1.6.1.zip && \
    cd spdlog-1.6.1 && \
    mkdir build && \
    cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --config Release && \
    cd build && \
    make install -j4 && \
    cd ../../.. && \
    rm -r spdlog

# ssl-unification

# depedencies essencials
RUN git clone --recursive https://github.com/robocin/soccer-common.git -b 'release/amistoso' && \
    cd soccer-common/scripts && \
    ./setup.py --essentials && \
    cd ../.. && \
    rm -r soccer-common

USER default



