FROM kong/kong:3.6

USER root
COPY txu-role-checker /usr/local/share/lua/5.1/kong/plugins/txu-role-checker

ENV KONG_PLUGINS="bundled,txu-role-checker"
USER kong