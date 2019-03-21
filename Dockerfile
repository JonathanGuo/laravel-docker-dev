FROM chcjonathanguo/laravel-docker-dev:7.3-with-nodejs
LABEL maintainer="jonathan <chc.jonathan.guo@outlook.com>"

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=${PUPPETEER_SKIP_CHROMIUM_DOWNLOAD:-true}

# Install system packages
RUN apk update && \
    apk add --no-cache \
        # Chromium dependencies
        chromium \
        harfbuzz \
        nss \
        msttcorefonts-installer \
        fontconfig \
        ttf-freefont && \
        update-ms-fonts && \
        fc-cache -f
