#!/bin/bash
#doesent work

bold=$(tput bold)
normal=$(tput sgr0)

GITREPO=https://github.com/rafael-santiago/pig
BRANCH=master
GITREPOROOT=/opt/ITSEC/10.Stresstest/pig/rafael-santiago/pig
GITCONFDIR=/opt/ITSEC/10.Stresstest/pig/rafael-santiago/pig/.git
GITCLONEDIR=/opt/ITSEC/10.Stresstest/pig/rafael-santiago
#EXECUTEABLE1=pig.py
#EXECUTEABLE2=dhcpPIG
GITRESET () {
	git clean -f
	git fetch origin
	git reset --hard origin/$BRANCH
	git pull
}
GITSBMDLINIT () {
	git submodule init
	git submodule update --recursive
	sudo updatedb && sudo ldconfig
}

echo "${bold}
 ____ ___ ____ 
|  _ \_ _/ ___|
| |_) | | |  _ 
|  __/| | |_| |
|_|  |___\____|
           
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
#sudo rm  /usr/local/bin/$EXECUTEABLE2
GITRESET
GITSBMDLINIT

git clone https://github.com/rafael-santiago/hefesto

cd hefesto
GITRESET
GITSBMDLINIT
cd /opt/ITSEC/10.Stresstest/pig/rafael-santiago/pig/hefesto/src/

./build.sh
#chmod +x $GITREPOROOT/$EXECUTEABLE1
#sudo ln -s $GITREPOROOT/$EXECUTEABLE1 /usr/local/bin/$EXECUTEABLE2

echo "${bold}
UPDATED
${normal}"

else

echo "${bold}
UP TO DATE
${normal}"
	
fi
