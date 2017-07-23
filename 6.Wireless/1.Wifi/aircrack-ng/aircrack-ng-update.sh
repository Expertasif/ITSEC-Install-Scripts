#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold}
    _    ___ ____   ____ ____      _    ____ _  __     _   _  ____ 
   / \  |_ _|  _ \ / ___|  _ \    / \  / ___| |/ /    | \ | |/ ___|
  / _ \  | || |_) | |   | |_) |  / _ \| |   | ' /_____|  \| | |  _ 
 / ___ \ | ||  _ <| |___|  _ <  / ___ \ |___| . \_____| |\  | |_| |
/_/   \_\___|_| \_\\____|_| \_\/_/   \_\____|_|\_\    |_| \_|\____|
         
${normal}"

GITREPOROOT=/opt/ITSEC/6.Wireless/1.Wifi/aircrack-ng/aircrack-ng/aircrack-ng
GITREPOGITFILE=$GITREPOROOT/.git
DSKTPFLS=/opt/ITSEC-Install-Scripts/0.Initial/usrlcl/.local/share/applications/6.Wireless/1.Wifi
DSKTPFLSDEST=/home/$USER/.local/share/applications/6.Wireless/1.Wifi
DSKTPFL=aircrack-ng.desktop

if [ ! -d $GITREPOGITFILE ]

then

mkdir -p /opt/ITSEC/6.Wireless/1.Wifi/aircrack-ng/aircrack-ng
cd /opt/ITSEC/6.Wireless/1.Wifi/aircrack-ng/aircrack-ng
git clone https://github.com/aircrack-ng/aircrack-ng
else

echo "repo exists"

fi

cd $GITREPOROOT

if git diff-index --quiet HEAD --; then
    echo "UP TO DATE"

else


cd $GITREPOROOT
sudo make uninstall
make clean
git clean -f
git fetch origin
git reset --hard origin/master
git pull
git submodule init
git submodule update --recursive
#
make -j 4
sudo make install
sudo airodump-ng-oui-update
mkdir -p $DSKTPFLSDEST
cp $DSKTPFLS/$DSKTPFL $DSKTPFLSDEST/$DSKTPFL

fi
