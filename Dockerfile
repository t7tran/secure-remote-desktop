FROM alpine:edge

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update
RUN apk add --no-cache xvfb x11vnc openssl xfce4 adwaita-icon-theme supervisor xterm bash chromium firefox xrdp wqy-zenhei novnc websockify tzdata

RUN ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html

ADD supervisord.conf /etc/supervisord.conf
ADD xrdp.ini /etc/xrdp/xrdp.ini
ADD entry.sh /entry.sh
ADD xfce4-panel.xml /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

RUN chmod +x /entry.sh

RUN openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/xrdp/key.pem -out /etc/xrdp/cert.pem -days 365 ; \
  chmod 600 /etc/xrdp/key.pem ; \
  chmod 600 /etc/xrdp/cert.pem

ENV DISPLAY :0
ENV RESOLUTION=1920x1080

# add main user
RUN adduser -D vncviewer

# change passwords and permissions
RUN 	echo "vncviewer:vncviewer" | /usr/sbin/chpasswd

EXPOSE 5901 6901

ENTRYPOINT ["/bin/bash", "-c", "/entry.sh"]
