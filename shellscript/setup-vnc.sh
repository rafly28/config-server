#!/bin/bash

echo "Updating package list..."
sudo apt update -y

sudo apt install -y xfce4 xfce4-goodies

echo "Installing TightVNC Server..."
sudo apt install -y tightvncserver vlc

echo "Starting VNC Server to set password..."
vncserver

echo "Stopping VNC Server..."
vncserver -kill :1

echo "Backing up existing xstartup file..."
mv ~/.vnc/xstartup ~/.vnc/xstartup.bak

echo "Creating new xstartup file..."
cat <<EOL > ~/.vnc/xstartup
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOL

chmod +x ~/.vnc/xstartup

vncserver

echo "Creating systemd service for VNC..."
cat <<EOL | sudo tee /etc/systemd/system/vncserver@.service
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=$(whoami)
Group=$(whoami)
WorkingDirectory=/home/$(whoami)
PIDFile=/home/$(whoami)/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1280x720 :%i
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload

echo "Enabling VNC service to start on boot..."
sudo systemctl enable vncserver@1.service

vncserver -kill :1

echo "Starting VNC service..."
sudo systemctl start vncserver@1

echo "Downloading Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

echo "Installing Google Chrome..."
sudo apt install -y ./google-chrome-stable_current_amd64.deb
sudo mv google-chrome-stable_current_amd64.deb /opt/

echo "Stopping VNC service to conserve resources..."
sudo systemctl stop vncserver@1

echo "Installation and configuration of TightVNC Server completed."
