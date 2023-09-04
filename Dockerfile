FROM alpine:3.9

RUN apk --no-cache add curl && apk add bash
# install rclone
RUN curl https://rclone.org/install.sh | bash

# install entrypoint
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# defaults env vars
ENV CRON_SCHEDULE="0 0 * * *"
ENV COMMAND="rclone version"

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]
