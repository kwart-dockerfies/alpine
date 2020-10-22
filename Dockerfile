#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

FROM alpine:3.12.1

MAINTAINER Josef (kwart) Cacek <josef.cacek@gmail.com>

ENV DROPBEAR_CONF=/etc/dropbear \
    ALPINE_USER=alpine

COPY bashrc /

RUN echo "Setting edge repositories" \
    && rm /etc/apk/repositories \
    && for repo in main community testing; do echo "http://dl-cdn.alpinelinux.org/alpine/edge/$repo" >>/etc/apk/repositories; done \
    && apk upgrade --update-cache --available \
    && echo "Installing APK packages" \
    && apk add bash dropbear openssh sudo iptables openjdk8 rsync dstat curl procps \
    && echo "Configuring SSH" \
    && mkdir /usr/libexec \
    && ln -s /usr/lib/ssh/sftp-server /usr/libexec/ \
    && touch /var/log/lastlog \
    && echo "Adding user $ALPINE_USER in wheel group (with a NOPASSWD: entry in sudoers file)" \
    && adduser -D $ALPINE_USER -s /bin/bash \
    && adduser $ALPINE_USER wheel \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/wheel \
    && sed -i s#/bin/ash#/bin/bash# /etc/passwd \
    && ln -s /bashrc /root/.bashrc \
    && sudo -u $ALPINE_USER ln -s /bashrc /home/$ALPINE_USER/.bashrc \
    && echo "Cleaning APK cache" \
    && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /

EXPOSE 22

USER alpine

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD []
