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

RUN npm install ep_post_data ep_align ep_author_neat ep_brightcolorpicker ep_comments_page ep_font_color ep_headings2 ep_pads_stats ep_prompt_for_name ep_spellcheck ep_googleanalytics ep_ether-o-meter ep_adminpads ep_cursortrace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "--experimental-worker", "node_modules/ep_etherpad-lite/node/server.js"]

