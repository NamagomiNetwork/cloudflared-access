FROM ubuntu:20.04

RUN apt update && apt install -y wget
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb
RUN apt install -y ./cloudflared-linux-arm64.deb
RUN apt-get install -y tzdata screen --&& \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT [ "/start.sh" ]