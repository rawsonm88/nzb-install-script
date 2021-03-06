#!/bin/sh
# Install dependencies
sudo apt-get install git-core python python-cheetah unzip unrar par2

# git clone sabnzbd, sickrage and couchpotato into /opt
cd /opt
sudo git clone https://github.com/sabnzbd/sabnzbd.git
sudo git clone https://github.com/SiCKRAGETV/SickRage.git
sudo git clone https://github.com/RuudBurger/CouchPotatoServer.git

# Copy/Download init scripts into /etc/init.d/
sudo cp /opt/CouchPotatoServer/init/ubuntu /etc/init.d/couchpotato
sudo cp /opt/SickRage/init.ubuntu /etc/init.d/sickrage
sudo cp ~/nzb-install-script/init/sabnzbd /etc/init.d/
sudo chmod 755 /etc/init.d/sabnzbd

# Set sabnzbd, sickrage and couchpotato to start automatically
sudo update-rc.d couchpotato defaults
sudo update-rc.d sickrage defaults
sudo update-rc.d sabnzbd defaults

# Add users and nzb group
sudo groupadd nzb
sudo useradd -G nzb -d /opt/SickRage sabnzbd
sudo useradd -G nzb -d /opt/SickRage sickrage
sudo useradd -G nzb -d /opt/SickRage couchpotato

# Correct ownership of the install directories
sudo chown sabnzbd:nzb /opt/sabnzbd -cR
sudo chown sickrage:nzb /opt/SickRage -cR
sudo chown couchpotato:nzb /opt/CouchPotatoServer -cR

# Download basic settings
cd /etc/default/
sudo cp ~/nzb-install-script/default/sickbeard ./
sudo cp ~/nzb-install-script/default/couchpotato ./
sudo cp ~/nzb-install-script/default/sabnzbd ./

# Create media directory
sudo mkdir /home/media
sudo chown sabnzbd:nzb /home/media

# Start services
sudo service sabnzbd start
sudo service couchpotato start
sudo service sickrage start

# Delay 5 seconds to ensure services are started and initial sabnzbd configuration is created
for i in 5 4 3 2 1
do
   sleep 1;
   echo "Please wait...$i seconds remaining"
done

echo ""

# Print SABnzbd
echo "SABnzbd API key: " `sudo awk -F " = " '/^api_key/ {print $2}' /opt/sabnzbd/config.ini`

echo ""
echo "Happy configuring!"
