FROM debian:buster

# args: Tizen IDE
ARG TIZEN_VERSION
ARG TIZEN_BINARY
ARG TIZEN_REPO
ARG TIZEN_TARGET

# args: Chrome Browser
ARG CHROME_REPO
ARG CHROME_BINARY

# args: Tizen User
ARG TIZEN_USER
ARG TIZEN_UID
ARG TIZEN_GID

# args: General
ARG ROOT_PASS

# set root password
RUN echo "root:${ROOT_PASS}" | chpasswd

# add tizen group and user
RUN groupadd -g ${TIZEN_GID} -o ${TIZEN_USER} \
    && useradd -m -d /home/${TIZEN_USER} -u ${TIZEN_UID} -g ${TIZEN_GID} -o -s /bin/bash ${TIZEN_USER} \
    && mkdir -p /run/user/$TIZEN_UID \
    && chown ${TIZEN_UID}:${TIZEN_GID} /run/user/${TIZEN_UID}

# install dependencies
COPY ./files /
RUN chmod a+x /opt/scripts/*.sh \
    && chmod a+x /usr/bin/gnome-terminal
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
        bash wget \
        openjdk-11-jdk

# emulator dependencies
RUN apt-get install -fy /root/ext-pkg/*.deb
RUN apt-get install -y libsdl1.2debian libv4l-0 libasound2 \
    libxcb-render-util0 libxcb-image0 libxcb-icccm4 libxcb-xfixes0 libxcb-randr0


# (optional) install xterm to ease development and testing/debugging 
RUN apt-get install -y xterm wget

# install chrome browser
RUN wget ${CHROME_REPO}"/"${CHROME_BINARY} \
    && apt-get install -fy "./"${CHROME_BINARY} \
    && rm "./"${CHROME_BINARY}

# cleanup for lower image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# switch user
USER ${TIZEN_USER}

# download the IDE
RUN cd ~ \
    && wget ${TIZEN_REPO}"/"${TIZEN_BINARY} \
    && chmod +x ./${TIZEN_BINARY}

# install the IDE
RUN cd ~ \
    && ./${TIZEN_BINARY} --accept-license ~/tizen-studio \
    && ./tizen-studio/package-manager/package-manager-cli.bin install NativeIDE Emulator PlatformIDE \
    && ./tizen-studio/package-manager/package-manager-cli.bin install ${TIZEN_TARGET}

# final cleaning
RUN rm ~/${TIZEN_BINARY}
