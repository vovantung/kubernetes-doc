FROM kong/kong:3.6

USER root
COPY lua /usr/local/share/lua/5.1/kong/plugins/txu
ENV KONG_PLUGINS="bundled,txu"
USER kong