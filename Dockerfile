FROM etherpad/etherpad

USER root

RUN apt-get update && \
    apt-get install -y \
    abiword mariadb-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/etherpad-lite

RUN rm settings.json
COPY settings.template .
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "--experimental-worker", "node_modules/ep_etherpad-lite/node/server.js"]

