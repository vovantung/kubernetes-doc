FROM kong/kong:3.6

USER root
COPY rolechecker /usr/local/share/lua/5.1/kong/plugins/rolechecker

ENV KONG_PLUGINS="bundled,role-checker"
USER kong