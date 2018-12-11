FROM ubuntu:16.04

COPY scripts/scraper.sh /usr/bin/scraper.sh

USER root

RUN apt-get update && apt-get upgrade -y \
        && apt-get install -y wget \
                    git \
                    systemd \
                    lua5.1 \
                    software-properties-common \
                    libssl-dev \
                    htop \
                    net-tools \
                    luarocks

RUN wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add - && \
    add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" && \
    apt-get update && apt-get install --no-install-recommends -y openresty

RUN luarocks install luasec && luarocks install lapis

RUN git clone https://github.com/DSG-UPC/Prometheus-Lua-Exporter.git

ENTRYPOINT "/usr/bin/scraper.sh"

