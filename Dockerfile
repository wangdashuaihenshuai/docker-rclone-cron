FROM alpine:3.9

RUN apk --no-cache add curl && apk --no-cache add bash

RUN apk --no-cache add ca-certificates fuse3 tzdata && \
  echo "user_allow_other" >> /etc/fuse.conf

RUN set -x; \
    apk add --no-cache --update rsync sudo openssh-client ca-certificates \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*

COPY install.sh ./
# install rclone
RUN bash install.sh

# install entrypoint
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# defaults env vars
ENV CRON_SCHEDULE="0 0 * * *"
ENV COMMAND="rclone version"

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]
