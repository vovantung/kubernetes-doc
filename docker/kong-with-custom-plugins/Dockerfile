FROM kong/kong:3.6

USER root
COPY lua /usr/local/share/lua/5.1/kong/plugins/txu-plugins
ENV KONG_PLUGINS="bundled, txu-plugins"
USER kong