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

# args: System/General
ARG ROOT_PASS

# args: audio
ARG AUDIO_GID

# set root password
RUN echo "root:${ROOT_PASS}" | chpasswd

# add tizen group and user
RUN groupadd -g ${TIZEN_GID} -o ${TIZEN_USER} \
    && useradd -m -d /home/${TIZEN_USER} -u ${TIZEN_UID} -g ${TIZEN_GID} -o -s /bin/bash ${TIZEN_USER} \
    && mkdir -p /run/user/$TIZEN_UID \
    && chown ${TIZEN_UID}:${TIZEN_GID} /run/user/${TIZEN_UID}

# install base dependencies
COPY ./files /
RUN chmod a+x /opt/scripts/*.sh \
    && chmod a+x /usr/bin/gnome-terminal
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
        bash wget zip unzip \
        openjdk-11-jdk

# emulator dependencies
RUN apt-get install -fy /root/ext-pkg/*.deb
RUN apt-get install -y libsdl1.2debian libv4l-0 libasound2 \
    libxcb-render-util0 libxcb-image0 libxcb-icccm4 libxcb-xfixes0 libxcb-randr0

# (optional) install xterm (required for SDB-Console to work; might be used for advanced debugging - check `runTizen.sh`)
RUN apt-get install -y xterm

# (optional) install chrome browser (required for Tizen Studio web-simulator)
RUN wget ${CHROME_REPO}"/"${CHROME_BINARY} \
    && apt-get install -fy "./"${CHROME_BINARY} \
    && rm "./"${CHROME_BINARY}

# cleanup for lower image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# audio support
RUN groupmod --gid ${AUDIO_GID} audio \
    && usermod -a -G audio ${TIZEN_USER}

# dump the config
RUN DUMPFILE="/opt/scripts/imgConfig.sh" \
    && echo "TIZEN_VERSION=${TIZEN_VERSION}" >> ${DUMPFILE} \
    && echo "TIZEN_BINARY=${TIZEN_BINARY}"   >> ${DUMPFILE} \
    && echo "TIZEN_REPO=${TIZEN_REPO}"       >> ${DUMPFILE} \
    && echo "TIZEN_TARGET=${TIZEN_TARGET}"   >> ${DUMPFILE} \
    && echo "CHROME_REPO=${CHROME_REPO}"     >> ${DUMPFILE} \
    && echo "CHROME_BINARY=${CHROME_BINARY}" >> ${DUMPFILE} \
    && echo "TIZEN_USER=${TIZEN_USER}"       >> ${DUMPFILE} \
    && echo "TIZEN_UID=${TIZEN_UID}"         >> ${DUMPFILE} \
    && echo "TIZEN_GID=${TIZEN_GID}"         >> ${DUMPFILE} \
    && echo "AUDIO_GID=${AUDIO_GID}"         >> ${DUMPFILE} \
    && echo ""                               >> ${DUMPFILE}

# switch user
USER ${TIZEN_USER}
