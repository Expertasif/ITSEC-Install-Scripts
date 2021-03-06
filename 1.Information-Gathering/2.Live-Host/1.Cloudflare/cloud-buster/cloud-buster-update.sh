#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

GITREPO=https://github.com/SageHack/cloud-buster.git
BRANCH=master
GITREPOROOT=/opt/ITSEC/1.Information-Gathering/2.Live-Host/1.Cloudflare/cloud-buster/SageHack/cloud-buster
GITCONFDIR=/opt/ITSEC/1.Information-Gathering/2.Live-Host/1.Cloudflare/cloud-buster/SageHack/cloud-buster/.git
GITCLONEDIR=/opt/ITSEC/1.Information-Gathering/2.Live-Host/1.Cloudflare/cloud-buster/SageHack
EXECUTEABLE1=bust.sh
EXECUTEABLE2=bust
BINDIR=/usr/local/bin
DSKTPFLS=/opt/ITSEC-Install-Scripts/0.Initial/usrlcl/.local/share/applications/1.Information-Gathering/2.Live-Host/1.Cloudflare
DSKTPFLSDEST=/home/$USER/.local/share/applications/1.Information-Gathering/1.Cloudflare
DSKTPFL=cloud-buster.desktop
GITSBMDLINIT () {
	git submodule init
	git submodule update --recursive
	sudo updatedb && sudo ldconfig
}
GITRESET () {
	git clean -f
	git fetch origin
	git reset --hard origin/$BRANCH
	git pull
}

echo "${bold}
  ____ _     ___  _   _ ____        ____  _   _ ____ _____ _____ ____  
 / ___| |   / _ \| | | |  _ \      | __ )| | | / ___|_   _| ____|  _ \ 
| |   | |  | | | | | | | | | |_____|  _ \| | | \___ \ | | |  _| | |_) |
| |___| |__| |_| | |_| | |_| |_____| |_) | |_| |___) || | | |___|  _ < 
 \____|_____\___/ \___/|____/      |____/ \___/|____/ |_| |_____|_| \_\
         
UPDATE
${normal}"

if [ ! -d $GITCONFDIR ]

then

mkdir -p $GITCLONEDIR
cd $GITCLONEDIR
git clone -b $BRANCH $GITREPO

else

echo "${bold}REPO EXISTS, skip clone...${normal}"

fi

cd $GITREPOROOT

if git checkout $BRANCH &&
    git fetch origin $BRANCH &&
    [ `git rev-list HEAD...origin/$BRANCH --count` != 0 ] &&
    git merge origin/$BRANCH
then
    
cd $GITREPOROOT
GITRESET
GITSBMDLINIT
sudo -H pip3 install --upgrade pip
sudo -H pip3 install dnspython3

echo "#!/bin/bash

cd /opt/ITSEC/1.Information-Gathering/2.Live-Host/1.Cloudflare/cloud-buster/SageHack/cloud-buster
python3 bust" >> $GITREPOROOT/$EXECUTEABLE1

sudo rm -f $BINDIR/$EXECUTEABLE2
chmod +x $GITREPOROOT/$EXECUTEABLE1
sudo rm -f $BINDIR/$EXECUTEABLE2
sudo ln -s $GITREPOROOT/$EXECUTEABLE1 $BINDIR/$EXECUTEABLE2

mkdir -p $DSKTPFLSDEST
rm -f $DSKTPFLSDEST/$DSKTPFL
cp $DSKTPFLS/$DSKTPFL $DSKTPFLSDEST/$DSKTPFL

#bust

echo "${bold}
UPDATED
${normal}"

else

echo "${bold}
UP TO DATE
${normal}"
	
fi