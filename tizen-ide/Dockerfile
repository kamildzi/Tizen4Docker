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

# args: kvm
ARG KVM_GID

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
        openjdk-11-jdk libcanberra-gtk0

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

# audio support
RUN groupmod -o --gid ${AUDIO_GID} audio \
    && usermod -a -G audio ${TIZEN_USER}

# KVM support
RUN groupmod -o --gid ${KVM_GID} kvm \
    && usermod -a -G kvm ${TIZEN_USER}

# gnome keyring support
RUN apt-get install -y gnome-keyring

# libwebkitgtk - required for Samsung Web Sign-in / Samsung Certificates
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" >> /etc/apt/sources.list.d/ubuntu-bionic.list \
    && apt-get install -y gnupg \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y libwebkitgtk-1.0

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
    && echo "KVM_GID=${KVM_GID}"             >> ${DUMPFILE} \
    && echo ""                               >> ${DUMPFILE}

# cleanup for lower image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# switch user
USER ${TIZEN_USER}
