FROM tiangolo/uwsgi-nginx-flask:python3.5

WORKDIR /tmp
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get install -y python3 python3-all-dev python3-pip build-essential swig git libpulse-dev portaudio19-dev python-all-dev \
    && apt-get -y autoclean
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.11.3

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN node -v
RUN npm -v

RUN apt-get update && apt-get install apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends yarn

COPY ./ /app
WORKDIR /app

RUN pip install -r requirements.txt
RUN rm -rf /app/*
ENV NGINX_MAX_UPLOAD 0

ENV UWSGI_INI /app/uwsgi.ini

ENV STATIC_INDEX 0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


CMD ["/usr/bin/supervisord"]
