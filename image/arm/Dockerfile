FROM ubuntu:20.04

RUN apt update && apt install wget screen -y
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm.deb
RUN apt install ./cloudflared-linux-arm.deb
COPY ./start.sh /start.sh
RUN chmod +x ./start.sh
RUN chmod +x ./access-command.sh

ENTRYPOINT [ "/start.sh" ]