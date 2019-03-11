FROM node:latest
LABEL maintainer="DevClub team, https://github.com/devclub-iitd/EtherPad"

ENV NODE_ENV production

# install supervisor
RUN apt-get update && apt-get install -y \
	supervisor curl unzip mysql-client gzip git python libssl-dev pkg-config build-essential  && \
	rm -rf /var/lib/apt/lists/*

# install supervisor.conf in a low layer of the container
ADD supervisor.conf /etc/supervisor/supervisor.conf

# git hash of the version to be built.
# If not given, build the latest development version.
ARG ETHERPAD_VERSION=develop

# grab the ETHERPAD_VERSION tarball from github (no need to clone the whole
# repository)
RUN echo "Getting version: ${ETHERPAD_VERSION}" && \
	curl \
		--location \
		--fail \
		--silent \
		--show-error \
		--output /opt/etherpad-lite.tar.gz \
		https://github.com/ether/etherpad-lite/archive/"${ETHERPAD_VERSION}".tar.gz && \
	mkdir /opt/etherpad-lite && \
	tar xf /opt/etherpad-lite.tar.gz \
		--directory /opt/etherpad-lite \
		--strip-components=1 && \
	rm /opt/etherpad-lite.tar.gz

# install node dependencies for Etherpad
RUN /opt/etherpad-lite/bin/installDeps.sh

WORKDIR /opt/etherpad-lite

RUN rm settings.json


RUN npm install ep_align ep_author_neat ep_brightcolorpicker ep_comments_page ep_font_color ep_headings2 ep_pads_stats ep_prompt_for_name ep_spellcheck ep_googleanalytics ep_post_data ep_ether-o-meter

COPY settings.template .
COPY entrypoint.sh /entrypoint.sh

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisor.conf", "-n"]
