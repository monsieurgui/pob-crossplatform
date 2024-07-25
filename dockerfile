# Use the official Ubuntu base image
FROM ubuntu:20.04

# Avoiding user interaction with tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Add WineHQ repository before installing Wine
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y software-properties-common wget && \
    wget -nv https://dl.winehq.org/wine-builds/winehq.key -O- | apt-key add - && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'

# Install Wine and other necessary packages
RUN apt-get update && \
    apt-get install -y --install-recommends \
    winehq-stable \
    winetricks \
    xvfb \
    x11vnc \
    fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Configure Wine and Winetricks for other dependencies excluding .NET
RUN winetricks --self-update && \
    winetricks -q corefonts gdiplus

# Copy the split .NET Framework 4.8 installer parts from local machine to Docker
COPY ndp48-x86-x64-allos-enu.zip.001 /root/
COPY ndp48-x86-x64-allos-enu.zip.002 /root/

# Combine and extract the .NET Framework 4.8 installer
RUN cat /root/ndp48-x86-x64-allos-enu.zip.001 /root/ndp48-x86-x64-allos-enu.zip.002 > /root/ndp48-x86-x64-allos-enu.zip && \
    unzip /root/ndp48-x86-x64-allos-enu.zip -d /root/ && \
    rm /root/ndp48-x86-x64-allos-enu.zip /root/ndp48-x86-x64-allos-enu.zip.001 /root/ndp48-x86-x64-allos-enu.zip.002

# Set up VNC
RUN mkdir ~/.vnc && \
    x11vnc -storepasswd yourVNCpassword ~/.vnc/passwd

# Download and setup Path of Building
WORKDIR /opt/pathofbuilding
RUN wget https://github.com/PathOfBuildingCommunity/PathOfBuilding/releases/download/v2.45.0/PathOfBuildingCommunity-Portable.zip -O pob.zip && \
    unzip pob.zip && \
    rm pob.zip

# Install .NET Framework 4.8
RUN wine /root/ndp48-x86-x64-allos-enu.exe /q /norestart

# Set the DISPLAY environment variable
ENV DISPLAY=:0

# Run Xvfb, Fluxbox, and x11vnc
CMD ["sh", "-c", "Xvfb :0 -screen 0 1920x1080x24 +extension GLX +render -noreset & fluxbox & sleep 5 && wine '/opt/pathofbuilding/Path Of Building.exe' & x11vnc -display :0 -nopw -xkb -forever -usepw -shared -noxdamage"]
