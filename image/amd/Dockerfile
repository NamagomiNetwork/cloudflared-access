FROM cloudflare/cloudflared:2022.12.1 as cloudflared-binary

FROM ubuntu:20.04

COPY --from=cloudflared-binary /usr/local/bin/cloudflared /usr/local/bin/

COPY ./start.sh /start.sh

ENTRYPOINT [ "/start.sh" ]