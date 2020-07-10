FROM ubuntu:bionic

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y build-essential libxml2-dev python3-dev python3-pip zlib1g-dev \
    unzip wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://deb.nodesource.com/setup_14.x && chmod +x setup_14.x && ./setup_14.x && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /cellxgene

RUN npm --prefix /cellxgene/client install && \
    npm --prefix /cellxgene/client run build configuration/webpack/webpack.config.prod.js 

RUN mkdir -p /cellxgene/build/client && \
    mkdir -p /cellxgene/build/server/common/web/static/assets && \
    mkdir -p /cellxgene/build/server/common/web/templates && \
    cp -r /cellxgene/client/build/* /cellxgene/build/client/ && \
    cp -r /cellxgene/server /cellxgene/build/ && \
    cp /cellxgene/build/client/index.html /cellxgene/build/server/common/web/templates/ && \
    cp -r /cellxgene/build/client/static /cellxgene/build/server/common/web/ && \
    cp /cellxgene/MANIFEST.in /cellxgene/build/ && \
    cp /cellxgene/README.md /cellxgene/build/ && \
    cp /cellxgene/setup.cfg /cellxgene/build/ && \
    cp /cellxgene/setup.py /cellxgene/build/

RUN cd /cellxgene/build && \
    python3 setup.py sdist -d /dist && \
    pip3 install $(ls /dist/*.tar.gz)

RUN rm -rf /cellxgene && \
    apt-get purge -y --auto-remove nodejs

# ENTRYPOINT ["cellxgene"]
