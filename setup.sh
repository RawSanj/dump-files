#!/bin/sh

# update the system
apt-get update
apt-get upgrade

################################################################################
# Install the mandatory tools
################################################################################

export LANGUAGE='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# install utilities
apt-get -y install vim git zip bzip2 fontconfig curl language-pack-en

# install Java 8
apt-get install default-jdk

# install node.js
curl -sL https://deb.nodesource.com/setup_6.x | bash -
apt-get install -y nodejs unzip python g++ build-essential

# update npm
npm install -g npm

# install yarn
npm install -g yarn
su -c "yarn config set prefix /home/rawsanj/.yarn-global" rawsanj

# install yeoman grunt bower gulp
su -c "yarn global add yo bower gulp" rawsanj

# install JHipster
su -c "yarn global add generator-jhipster@4.1.1" rawsanj

# install JHipster UML
su -c "yarn global add jhipster-uml@2.0.3" rawsanj

################################################################################
# Install the VirtualBox utilities
################################################################################

# force encoding
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment

# install VirtualBox guest tools
apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# remove light-locker (see https://github.com/jhipster/jhipster-devbox/issues/54)
apt-get remove -y light-locker --purge

################################################################################
# Install the development tools
################################################################################

# install Ubuntu Make - see https://wiki.ubuntu.com/ubuntu-make

add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make

apt-get update
apt-get upgrade

apt install -y ubuntu-make

# install MySQL Workbench
apt-get install -y mysql-workbench

# install PgAdmin
apt-get install -y pgadmin3

# install Heroku toolbelt
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# install Guake
apt-get install -y guake
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/

# install jhipster-devbox
git clone git://github.com/jhipster/jhipster-devbox.git /home/rawsanj/jhipster-devbox
chmod +x /home/rawsanj/jhipster-devbox/tools/*.sh

# install zsh
apt-get install -y zsh

# install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/rawsanj/.oh-my-zsh
cp /home/rawsanj/.oh-my-zsh/templates/zshrc.zsh-template /home/rawsanj/.zshrc
chsh -s /bin/zsh rawsanj
echo 'SHELL=/bin/zsh' >> /etc/environment

# install jhipster-oh-my-zsh-plugin
git clone https://github.com/jhipster/jhipster-oh-my-zsh-plugin.git /home/rawsanj/.oh-my-zsh/custom/plugins/jhipster
sed -i -e "s/plugins=(git)/plugins=(git docker docker-compose jhipster)/g" /home/rawsanj/.zshrc
echo 'export PATH="$PATH:/usr/bin:/home/rawsanj/.yarn-global/bin:/home/rawsanj/.yarn/bin:/home/rawsanj/.config/yarn/global/node_modules/.bin"' >> /home/rawsanj/.zshrc

# change user to rawsanj
chown -R rawsanj:rawsanj /home/rawsanj/.zshrc /home/rawsanj/.oh-my-zsh

# install Visual Studio Code
su -c 'umake ide visual-studio-code /home/rawsanj/.local/share/umake/ide/visual-studio-code --accept-license' rawsanj

# fix links (see https://github.com/ubuntu/ubuntu-make/issues/343)
sed -i -e 's/visual-studio-code\/code/visual-studio-code\/bin\/code/' /home/rawsanj/.local/share/applications/visual-studio-code.desktop

# disable GPU (see https://code.visualstudio.com/docs/supporting/faq#_vs-code-main-window-is-blank)
sed -i -e 's/"$CLI" "$@"/"$CLI" "--disable-gpu" "$@"/' /home/rawsanj/.local/share/umake/ide/visual-studio-code/bin/code

#install IDEA community edition
su -c 'umake ide idea /home/rawsanj/.local/share/umake/ide/idea' rawsanj

# increase Inotify limit (see https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit)
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-inotify.conf
sysctl -p --system

# install latest Docker
curl -sL https://get.docker.io/ | sh

# install latest docker-compose
curl -L "$(curl -s https://api.github.com/repos/docker/compose/releases | grep browser_download_url | head -n 4 | grep Linux | cut -d '"' -f 4)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# configure docker group (docker commands can be launched without sudo)
usermod -aG docker rawsanj

# fix ownership of home
chown -R rawsanj:rawsanj /home/rawsanj/

# clean the box
apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
