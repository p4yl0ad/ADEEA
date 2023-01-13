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

# On each file drop take the dat file and move to new folder 
# mkdir /tmp/filename.dat

RUN printf \
'#!/bin/bash \
date > /workdir/datefile.txt \
' > /workdir/do-work.sh

RUN echo
#!/usr/bin/bash \
a=$(ls /tmp/in) \
for file in $a \
do \
        echo "[i] File to move" \
        echo $file \
        file_dir="${file}_dir" \
        echo "[i] Making directory /tmp/$file_dir" \
        mkdir /tmp/in/$file_dir \
        echo "[i] Moving /tmp/in/$file to /tmp/in/$file_dir/$file" \
        mv /tmp/in/$file /tmp/in/$file_dir/$file \
        echo "[i] Generating bloodhound JSON output" \
        outdir="/tmp/in/${file_dir}/outdir" \
        #mkdir $outdir \
        python3 /opt/ADExplorerSnapshot.py/ADExplorerSnapshot.py -o $outdir /tmp/in/$file_dir/$file \
done

RUN watchman -- trigger /in buildme '*.dat' -- bash /workdir/do-work.sh
