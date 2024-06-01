FROM alpine:3.20.0

RUN apk upgrade --no-cache && \
    apk add --no-cache xvfb x11vnc openssl xfce4 adwaita-icon-theme supervisor xterm bash chromium firefox xrdp wqy-zenhei novnc websockify tzdata && \
    ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html && \
    adduser -D viewer && \
    echo "viewer:viewer" | /usr/sbin/chpasswd && \
# clean up
    rm -rf /apk /tmp/* /var/cache/apk/*

ENV DISPLAY=:0 \
    RESOLUTION=1920x1080

COPY ./rootfs /

EXPOSE 5901 6901

USER viewer

ENTRYPOINT ["/usr/bin/supervisord"]
