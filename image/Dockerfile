FROM cloudflare/cloudflared:2022.5.0 as cloudflared-binary

FROM ubuntu:20.04

COPY --from=cloudflared-binary /usr/local/bin/cloudflared /usr/local/bin/
RUN apt update
RUN apt install screen -y
COPY ./start.sh /start.sh

ENTRYPOINT [ "/start.sh" ]