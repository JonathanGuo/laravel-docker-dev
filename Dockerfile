FROM chcjonathanguo/laravel-docker-dev:7.2
LABEL maintainer="jonathan <chc.jonathan.guo@outlook.com>"

# Install system packages
RUN apk add --no-cache \
        nodejs \
        npm && \
    # Tidy up
    rm -rf /var/cache/*
