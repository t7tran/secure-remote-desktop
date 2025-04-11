FROM ubuntu:24.04

ENV DISPLAY=:0 \
    RESOLUTION=1920x1080 \
    TZ=Australia/Melbourne

RUN apt update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt install -y  tzdata keyboard-configuration ca-certificates \
                    xvfb dbus-x11 x11vnc openssl xfce4 adwaita-icon-theme supervisor tilix bash novnc python3-websockify python3-numpy \
                    curl \
                    openssh-client \
                    mysql-client \
                    && \
# install postgresql client
    install -d /usr/share/postgresql-common/pgdg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    . /etc/os-release && \
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt update && \
    apt install -y postgresql-client-17 && \
# install mongo tools
    curl -fsSL https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2404-x86_64-100.12.0.deb -o /tmp/mongodb-tools.deb && \
    apt install -y /tmp/mongodb-tools.deb && \
# install mongosh
    curl -fsSL https://downloads.mongodb.com/compass/mongodb-mongosh_2.5.0_amd64.deb -o /tmp/mongosh.deb && \
    apt install -y /tmp/mongosh.deb && \
# install chrome
    apt install -y fonts-liberation libu2f-udev xdg-utils && \
    curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb && \
    apt install -y /tmp/chrome.deb && \
    sed -i 's#Exec=/usr/bin/google-chrome-stable#Exec=/usr/bin/google-chrome-stable --no-sandbox --disable-fre --no-default-browser-check --no-first-run --password-store=basic#g' /usr/share/applications/google-chrome.desktop && \
    # install vscode
    curl -fsSL 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -o /tmp/code.deb && \
    apt install -y /tmp/code.deb && \
    sed -i 's#Exec=/usr/share/code/code#Exec=/usr/share/code/code --no-sandbox#g' /usr/share/applications/code.desktop && \
# run as non-root user
    echo "ubuntu:ubuntu" | /usr/sbin/chpasswd && \
# setup index.html using vnc_lite.html template
    ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html && \
# clean up
    apt clean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY ./rootfs /

EXPOSE 6901

USER ubuntu

ENTRYPOINT ["/usr/bin/supervisord"]
