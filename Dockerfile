ARG RELEASE
FROM ghcr.io/sagernet/sing-box:${RELEASE} AS sing-box

FROM alpine:latest

RUN apk add --no-cache libqrencode jq coreutils bash && mkdir -p /etc/sing-box/
RUN apk add --no-cache --update wireguard-tools iptables

COPY --from=sing-box /usr/local/bin/sing-box /bin/sing-box
COPY --from=ghcr.io/tarampampam/mustpl:0.1.1 /bin/mustpl /bin/mustpl
COPY entrypoint.sh config-template* show-template /opt/
COPY gen* /bin/
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

CMD ["sing-box", "--config", "/etc/sing-box/config.json", "run"]
