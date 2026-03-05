FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm
LABEL maintainer="bysknx" \
      org.opencontainers.image.source="https://github.com/bysknx/cursor-in-browser/" \
      org.opencontainers.image.title="Cursor in browser" \
      org.opencontainers.image.description="Cursor container image allowing access via web browser"

ENV DISPLAY=:1

# Update and install necessary packages
RUN echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl jq fuse python3.11-venv libfuse2 python3-xdg libgtk-3-0 libnotify4 libatspi2.0-0 libsecret-1-0 libnss3 desktop-file-utils fonts-noto-color-emoji git ssh-askpass && \
    apt-get autoclean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Download latest Cursor AppImage automatically
RUN CURSOR_URL=$(curl -s -L -H "User-Agent: Mozilla/5.0" "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable" | jq -r '.downloadUrl') && \
    curl -L --output Cursor.AppImage "$CURSOR_URL" && \
    chmod a+x Cursor.AppImage

# Environment variables
ENV CUSTOM_PORT="8080" \
    CUSTOM_HTTPS_PORT="8443" \
    CUSTOM_USER="" \
    PASSWORD="" \
    SUBFOLDER="" \
    TITLE="Cursor Latest" \
    FM_HOME="/cursor"

# Add local files and Cursor icon
COPY root/ /
COPY cursor_icon.png /cursor_icon.png

# Expose ports and volumes
EXPOSE 8080 8443
VOLUME ["/config","/cursor"]
