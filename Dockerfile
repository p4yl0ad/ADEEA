# syntax=docker/dockerfile:1
FROM python:3.8-slim

WORKDIR /workdir
RUN apt-get update && apt-get install pkg-config libssl-dev build-essential g++ clang git wget unzip -y
RUN wget https://github.com/facebook/watchman/releases/download/v2022.09.26.00/watchman-v2022.09.26.00-linux.zip -O /tmp/watchman-v2022.09.26.00-linux.zip

RUN cd /tmp \
        && unzip /tmp/watchman-v2022.09.26.00-linux.zip \
        && cd /tmp/watchman-v2022.09.26.00-linux \
        && mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman \
        && cp bin/* /usr/local/bin \
        && cp lib/* /usr/local/lib \
        && chmod 755 /usr/local/bin/watchman \
        && chmod 2777 /usr/local/var/run/watchman \
        && mkdir /in \
        && mkdir /out

VOLUME /in /out

RUN rm -rf /tmp/watchman-v2022.09.26.00-linux.zip
RUN rm -rf /tmp/watchman-v2022.09.26.00-linux

RUN git clone https://github.com/c3c/ADExplorerSnapshot.py.git /workdir/ADExplorerSnapshot.py \
        && cd ADExplorerSnapshot.py \
        &&  pip3 install --user .

# TESTING
RUN watchman watch /in
RUN printf '#!/bin/bash\ndate > /workdir/datefile.txt\n' > /workdir/do-work.sh

RUN watchman -- trigger /in buildme '*.dat' -- bash /workdir/do-work.sh
