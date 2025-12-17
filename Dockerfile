ARG N8N_VERSION=1.119.0

FROM n8nio/n8n:${N8N_VERSION}

USER root
RUN ARCH=$(uname -m) && \
    wget -qO- "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk && \
    ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/main \
        -U --allow-untrusted add apk-tools && \
    rm -rf sbin apk-tools-static-*.apk
RUN apk add --no-cache chromium nss glib freetype freetype-dev harfbuzz ca-certificates ttf-freefont udev ttf-liberation font-noto-emoji \
  && mkdir -p /home/node/.cache /var/lib/chromium \
  && chown -R node:node /home/node /var/lib/chromium
ENV CHROME_PATH=/usr/bin/chromium-browser \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
USER node