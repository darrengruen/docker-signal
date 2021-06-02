FROM debian:buster

ENTRYPOINT [ "signal-desktop" ]

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg2 \
  libgtk-3-0 \
  libgtk-3-dev \
  && curl -s https://updates.signal.org/desktop/apt/keys.asc | apt-key add - \
  && echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" \
  | tee -a /etc/apt/sources.list.d/signal-xenial.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends signal-desktop \
  && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/* \
  && useradd -m signal

USER signal

WORKDIR /home/signal

VOLUME [ "/home/signal/.config/Signal" ]

ARG BUILD_DATE
ARG COMMIT_SHA
ARG BRANH_NAME

LABEL created="${BUILD_DATE}"
LABEL descirption="Run signal in a docker container"
LABEL licenses="GPL"
LABEL revision="${COMMIT_SHA}"
LABEL source="github.com/darrengruen/docker-signal"
LABEL title="docker-signal"
LABEL version="${BRANCH_NAME}"
