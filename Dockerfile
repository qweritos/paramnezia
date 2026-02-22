FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  systemd \
  wget \
  curl \
  libglib2.0-bin \
  lsb-release \
  apt-utils \
  nano \
  inetutils-ping \
  iproute2 \
  httping \
  bash-completion \
  openssh-server \
  fuse-overlayfs

RUN curl -fsSL get.docker.com | sh

ADD ./rootfs /

RUN rm -f \
  /lib/systemd/system/sockets.target.wants/*udev* \
  /lib/systemd/system/sockets.target.wants/*initctl* \
  /lib/systemd/system/local-fs.target.wants/* \
  /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
  /etc/systemd/system/etc-resolv.conf.mount \
  /etc/systemd/system/etc-hostname.mount \
  /etc/systemd/system/etc-hosts.mount

RUN systemctl mask -- \
      tmp.mount \
      etc-hostname.mount \
      etc-hosts.mount \
      etc-resolv.conf.mount \
      swap.target \
      getty.target \
      getty-static.service \
      dev-mqueue.mount \
      cgproxy.service \
      systemd-tmpfiles-setup-dev.service \
      systemd-remount-fs.service \
      systemd-ask-password-wall.path \
      systemd-logind && \
      systemctl set-default multi-user.target || true

RUN systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target ModemManager.service
RUN systemctl enable ssh setup

STOPSIGNAL SIGRTMIN+3


ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/sbin/init", "--log-level=debug", "--log-target=console"]
