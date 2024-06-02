FROM ubuntu:24.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive TZ=Australia/Melbourne apt install -y tzdata keyboard-configuration && \
    apt install -y xvfb dbus-x11 x11vnc openssl xfce4 adwaita-icon-theme supervisor tilix bash novnc python3-websockify python3-numpy && \
# install chrome
    apt install -y fonts-liberation libu2f-udev xdg-utils && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb && \
    apt install /tmp/chrome.deb && \
    sed -i 's#Exec=/usr/bin/google-chrome-stable#Exec=/usr/bin/google-chrome-stable --no-sandbox --disable-fre --no-default-browser-check --no-first-run --password-store=basic#g' /usr/share/applications/google-chrome.desktop && \
    # install vscode
    wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O /tmp/code.deb && \
    apt install /tmp/code.deb && \
    sed -i 's#Exec=/usr/share/code/code#Exec=/usr/share/code/code --no-sandbox#g' /usr/share/applications/code.desktop && \
# install other tools
    apt install -y openssh-client && \
# run as non-root user
    echo "ubuntu:ubuntu" | /usr/sbin/chpasswd && \
# setup index.html using vnc_lite.html template
    ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html && \
# clean up
    apt clean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

ENV DISPLAY=:0 \
    RESOLUTION=1920x1080

COPY ./rootfs /

EXPOSE 6901

USER ubuntu

ENTRYPOINT ["/usr/bin/supervisord"]
