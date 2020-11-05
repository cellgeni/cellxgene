FROM ubuntu:bionic

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y build-essential libxml2-dev python3-dev python3-pip zlib1g-dev git jq unzip wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://deb.nodesource.com/setup_14.x && chmod +x setup_14.x && ./setup_14.x && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#RUN git clone --single-branch --branch limb-dev https://github.com/cellgeni/cellxgene.git && \
COPY ./ /cellxgene/

RUN cd /cellxgene && \
    make build-for-server-dev

RUN cd /cellxgene && \
    python3 -m pip install --upgrade pip && \
    pip3 install --upgrade six && \
    pip3 install -e .

RUN apt-get purge -y --auto-remove nodejs && \
    rm setup_14.x && \
    rm -rf cellxgene/client/node_modules

ENTRYPOINT ["cellxgene"]
