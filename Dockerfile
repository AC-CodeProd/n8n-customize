ARG N8N_VERSION=2.18.0

FROM alpine:3.23.4 AS alpine

FROM n8nio/n8n:${N8N_VERSION}

USER root

COPY --from=alpine /sbin/apk /sbin/apk
COPY --from=alpine /usr/lib/libapk.so* /usr/lib/

RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.23/main" > /etc/apk/repositories \
  && echo "https://dl-cdn.alpinelinux.org/alpine/v3.23/community" >> /etc/apk/repositories \
  && sed -i '/^zlib>/d' /etc/apk/world \
  && sed -i '/^brotli-libs>/d' /etc/apk/world \
  && apk upgrade --no-cache \
  && apk add --no-cache \
      chromium \
      nss \
      glib \
      freetype \
      freetype-dev \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      udev \
      ttf-liberation \
      font-noto-emoji \
  && mkdir -p /home/node/.cache /var/lib/chromium \
  && chown -R node:node /home/node /var/lib/chromium

ENV CHROME_PATH=/usr/bin/chromium-browser \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

USER node