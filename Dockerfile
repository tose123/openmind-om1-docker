FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    vim \
    python3.10 \
    python3-pip \
    python3-venv \
    python3-dev \
    iputils-ping \
    pkg-config \
    libssl-dev \
    pulseaudio \
    pulseaudio-utils \
    portaudio19-dev \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

RUN cd / && mkdir openmind && cd openmind \
    && git clone --depth=1 https://github.com/OpenMind/OM1.git \
    && cd OM1 && git fetch --all --prune && git checkout 26b066f \
    && git submodule update --init \
    && uv venv

COPY ./init_env_conversation.sh /openmind/OM1/init_env_conversation.sh
COPY ./init_env_spot.sh /openmind/OM1/init_env_spot.sh
RUN cd /openmind/OM1 \
    && /openmind/OM1/init_env_conversation.sh \
    && /openmind/OM1/init_env_spot.sh

WORKDIR /openmind/OM1

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["spot"]
