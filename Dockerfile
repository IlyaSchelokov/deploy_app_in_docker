FROM php:8-apache

# ---------- System / PHP extensions (редко меняются) ----------
ADD --chmod=0755 \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    /usr/local/bin/install-php-extensions

RUN install-php-extensions \
        iconv \
        gd \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
    && rm -rf \
        /usr/src/php* \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

# ---------- Runtime directories ----------
RUN mkdir -p /speedtest

# ---------- Environment (кешируется идеально) ----------
ENV TITLE=LibreSpeed \
    MODE=standalone \
    PASSWORD=password \
    TELEMETRY=false \
    ENABLE_ID_OBFUSCATION=false \
    REDACT_IP_ADDRESSES=false \
    WEBPORT=8080

# ---------- Application code (часто меняется → внизу) ----------
COPY backend/ /speedtest/backend
COPY results/*.php results/*.ttf /speedtest/results/
COPY *.js favicon.ico /speedtest/
COPY docker/*.php /speedtest/
COPY docker/entrypoint.sh /entrypoint.sh

# ---------- Metadata ----------
STOPSIGNAL SIGWINCH

LABEL org.opencontainers.image.title="LibreSpeed" \
      org.opencontainers.image.description="A Free and Open Source speed test that you can host on your server(s)" \
      org.opencontainers.image.vendor="LibreSpeed" \
      org.opencontainers.image.url="https://github.com/librespeed/speedtest" \
      org.opencontainers.image.source="https://github.com/librespeed/speedtest" \
      org.opencontainers.image.documentation="https://github.com/librespeed/speedtest/blob/master/doc_docker.md" \
      org.opencontainers.image.licenses="LGPL-3.0-or-later"

# ---------- Healthcheck ----------
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${WEBPORT}/ || exit 1

EXPOSE ${WEBPORT}
CMD ["bash", "/entrypoint.sh"]
