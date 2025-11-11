ARG N8N_VERSION=1.119.0

FROM n8nio/n8n:${N8N_VERSION}

USER root
RUN apk add --no-cache chromium nss glib freetype freetype-dev harfbuzz ca-certificates ttf-freefont udev ttf-liberation font-noto-emoji \
  && mkdir -p /home/node/.cache /var/lib/chromium \
  && chown -R node:node /home/node /var/lib/chromium
ENV CHROME_PATH=/usr/bin/chromium-browser \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
USER node