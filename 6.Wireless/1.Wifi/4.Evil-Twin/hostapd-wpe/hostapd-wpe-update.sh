#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold}
 _   _  ___  ____ _____  _    ____  ____     __        ______  _____ 
| | | |/ _ \/ ___|_   _|/ \  |  _ \|  _ \    \ \      / /  _ \| ____|
| |_| | | | \___ \ | | / _ \ | |_) | | | |____\ \ /\ / /| |_) |  _|  
|  _  | |_| |___) || |/ ___ \|  __/| |_| |_____\ V  V / |  __/| |___ 
|_| |_|\___/|____/ |_/_/   \_\_|   |____/       \_/\_/  |_|   |_____|
        
${normal}"

GITREPOROOT=/opt/ITSEC/6.Wireless/1.Wifi/4.Evil-Twin/hostapd-wpe/OpenSecurityResearch/hostapd-wpe
GITREPOGITFILE=$GITREPOROOT/.git
DSKTPFLS=/opt/ITSEC-Install-Scripts/0.Initial/usrlcl/.local/share/applications/6.Wireless/1.Wifi/4.Evil-Twin
DSKTPFLSDEST=/home/$USER/.local/share/applications/6.Wireless/1.Wifi/4.Evil-Twin
DSKTPFL=hostapd-wpe.desktop

if [ ! -d $GITREPOGITFILE ]

then


mkdir -p /opt/ITSEC/6.Wireless/1.Wifi/4.Evil-Twin/hostapd-wpe/OpenSecurityResearch
cd /opt/ITSEC/6.Wireless/1.Wifi/4.Evil-Twin/hostapd-wpe/OpenSecurityResearch
git clone https://github.com/OpenSecurityResearch/hostapd-wpe.git

else

echo "repo exists"

fi

cd $GITREPOROOT

if git diff-index --quiet HEAD --; then
    echo "UP TO DATE"

else

cd $GITREPOROOT
git clean -f
git fetch origin
git reset --hard origin/master
git pull
git submodule init
git submodule update --recursive
#
rm -rf hostapd-2.6
wget http://hostap.epitest.fi/releases/hostapd-2.6.tar.gz
tar -zxf hostapd-2.6.tar.gz
cd hostapd-2.6
patch -p1 < ../hostapd-wpe.patch 
cd hostapd
make -j 4
sudo make install
cd ../../certs/
./bootstrap
cd ../hostapd-2.6/hostapd
echo "#!/bin/bash
cd /opt/ITSEC/6.Wireless/1.Wifi/4.Evil-Twin/hostapd-wpe/OpenSecurityResearch/hostapd-wpe/hostapd-2.6/hostapd

sudo ./hostapd-wpe hostapd-wpe.conf" >> hostapd-wpe.sh
#cd /opt/ITSEC/6.Wireless/1.Wifi/4.Evil-Twin/hostapd-wpe/OpenSecurityResearch/hostapd-wpe
chmod +x hostapd-wpe.sh

mkdir -p $DSKTPFLSDEST 
rm -f $DSKTPFLSDEST/$DSKTPFL
cp $DSKTPFLS/$DSKTPFL $DSKTPFLSDEST/$DSKTPFL

fi
