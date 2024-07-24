FROM --platform=linux/amd64 ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    xvfb \
    x11vnc \
    novnc \
    nginx \
    openbox \
    net-tools \
    curl \
    unzip \
    software-properties-common \
    gnupg2 \
    cabextract \
    && rm -rf /var/lib/apt/lists/*

# Install Wine and dependencies
RUN dpkg --add-architecture i386 && \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    echo "deb [signed-by=/etc/apt/keyrings/winehq-archive.key] http://dl.winehq.org/wine-builds/ubuntu/ focal main" | tee /etc/apt/sources.list.d/wine.list && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-stable winetricks && \
    rm -rf /var/lib/apt/lists/*

# Create minimal Openbox menu
RUN mkdir -p /var/lib/openbox && \
    echo '<?xml version="1.0" encoding="UTF-8"?><openbox_menu><menu id="root-menu" label=""><item label="Terminal"><action name="Execute"><command>xterm</command></action></item></menu></openbox_menu>' > /var/lib/openbox/debian-menu.xml

# Download Visual C++ Redistributable installer
RUN wget -O /tmp/vc_redist.x86.exe https://aka.ms/vs/17/release/vc_redist.x86.exe

# Download and extract Path of Building
RUN mkdir -p /opt/PoB && \
    curl -L -o /tmp/PoB.zip https://github.com/PathOfBuildingCommunity/PathOfBuilding/releases/download/v2.45.0/PathOfBuildingCommunity-Portable.zip && \
    unzip /tmp/PoB.zip -d /opt/PoB && \
    rm /tmp/PoB.zip

# Copy NGINX conf to the container
COPY nginx.conf /etc/nginx/nginx.conf

# Copy entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Expose ports for VNC and noVNC
EXPOSE 5900 6080

ENTRYPOINT ["/entrypoint.sh"]