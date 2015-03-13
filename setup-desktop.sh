#!/bin/bash
sudo yum update -y
sudo setenforce 0
sudo yum install -y wget
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo rpm -ivh epel-release-7-5.noarch.rpm
sudo yum groups install -y "X Window System" "MATE Desktop"
wget http://virtualgl.sourceforge.net/vgl.nightly/VirtualGL-2.3.91.x86_64.rpm
wget http://turbovnc.sourceforge.net/vnc.nightly/turbovnc-1.2.80.x86_64.rpm
sudo yum install -y libXaw libXmu libXt xauth xdpyinfo glx-utils libXp xterm xorg-x11-xdm  xorg-x11-fonts-100dpi xorg-x11-fonts-ISO8859-9-100dpi xorg-x11-fonts-misc xorg-x11-fonts-Type1 gcc kernel-devel libGLU
sudo rpm -ivh turbovnc-1.2.80.x86_64.rpm
sudo rpm -ivh VirtualGL-2.3.91.x86_64.rpm
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/346.47/NVIDIA-Linux-x86_64-346.47.run
chmod +x NVIDIA-Linux-x86_64-346.47.run
sudo rpm -e xorg-x11-drivers xorg-x11-drv-nouveau
sudo ./NVIDIA-Linux-x86_64-346.47.run -s -Z -z
sudo /opt/VirtualGL/bin/vglserver_config -config +s +f +t
wget https://github.com/rncry/gpu-desktop/raw/master/xorg.conf
sudo cp xorg.conf /etc/X11/xorg.conf
sudo xinit
export PASS=` < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};echo;`
echo "$PASS" | /opt/TurboVNC/bin/vncpasswd -f
echo "$PASS" | /opt/TurboVNC/bin/vncpasswd -f >> $HOME/.vnc/passwd
chmod 600 ~/.vnc/passwd
sudo iptables -I INPUT -p tcp --dport 5901 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 5801 -j ACCEPT
sudo iptables-save
wget https://github.com/rncry/gpu-desktop/raw/master/.Xclients
chmod +x .Xclients
sudo touch /etc/X11/xinit/Xclients.d/mate.sh
sudo chmod 666 /etc/X11/xinit/Xclients.d/mate.sh
sudo echo "mate-session" >> /etc/X11/xinit/Xclients.d/mate.sh
/opt/TurboVNC/bin/vncserver
echo "vnc password: $PASS"

