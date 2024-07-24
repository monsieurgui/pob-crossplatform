#!/bin/bash

# Start Xvfb
Xvfb :99 -ac -screen 0 1280x1024x16 &
export DISPLAY=:99

# Start a simple window manager
openbox &

# Start VNC server
x11vnc -display :99 -forever -nopw -create &

# Start Nginx
nginx

# Start noVNC
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 6080 &

# Wait for X server to start
sleep 5

# Initialize Wine
WINEARCH=win32 WINEPREFIX=/root/.wine wineboot --init

# Install Visual C++ Redistributable
wine /tmp/vc_redist.x86.exe /q

# Install Windows Common Controls
winetricks -q vcrun6 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015

# Install .NET Framework 4.8 (this may take a while)
winetricks -q dotnet48

# Configure Wine
wineboot --update

# Start Path of Building with increased verbosity
WINEDEBUG=+relay,+seh,+tid,+ole,+rpc,+module wine '/opt/PoB/Path of Building.exe' > /tmp/pob_output.log 2>&1 &

# Keep the container running and display Path of Building output
tail -f /tmp/pob_output.log