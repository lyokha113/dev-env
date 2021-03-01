#!/bin/bash
#
# Install and config ZSH - Prezto 
# @Author: Long H. Nguyen
# @Date: 12/11/2020


#==============================================================================================================================================

FONT_DIR="${HOME}/.local/share/fonts"
DOTFILE_DIR="dotfile"
sudo apt upgrade -y && sudo apt update -y

#==============================================================================================================================================

echo "Install ZSH/GIT/CURL/WGET"
sudo apt install zsh curl git wget -y

#==============================================================================================================================================

echo "Install openjdk 8"
sudo apt install openjdk-8-jdk -y

#==============================================================================================================================================

echo "Install gradle"
wget -O "${HOME}/Downloads/gradle.zip" https://downloads.gradle-dn.com/distributions/gradle-6.8.2-all.zip
sudo unzip -d /opt/ "${HOME}/Downloads/gradle.zip"
sudo mv /opt/gradle-* /opt/gradle 
rm -f "${HOME}/Downloads/gradle.zip"

#==============================================================================================================================================

echo "Install maven"
wget -O "${HOME}/Downloads/maven.tar.gz" https://mirror.downloadvn.com/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
sudo tar -xf "${HOME}/Downloads/maven.tar.gz" -C /opt/
sudo mv /opt/apache-maven-* /opt/maven 
rm -f "${HOME}/Downloads/maven.tar.gz"

#==============================================================================================================================================

echo "Install nodejs"
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
sudo apt-get install -y nodejs

#==============================================================================================================================================

echo "Install yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn

#==============================================================================================================================================

echo "Install docker"
sudo apt upgrade -y && sudo apt update -y
sudo apt install apt-transport-https ca-certificates gnupg-agent software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

#==============================================================================================================================================

echo "Install Firacode/MesloLGS font"

if [ ! -d "${FONT_DIR}" ]; then
    mkdir -p "${FONT_DIR}"
fi

for type in Bold Light Medium Regular Retina; do
    FILE_PATH="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
    FILE_URL="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
    if [ ! -e "${FILE_PATH}" ]; then
        wget -O "${FILE_PATH}" "${FILE_URL}"
    fi;
done

for type in Bold Regular Italic "Bold Italic"; do
    FILE_PATH="${HOME}/.local/share/fonts/MesloLGS NF ${type}.ttf"
    FILE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS NF ${type}.ttf"
    if [ ! -e "${FILE_PATH}" ]; then
        wget -O "${FILE_PATH}" "${FILE_URL}"
    fi;
done

fc-cache -f

#==============================================================================================================================================

echo "Install and config prezto"
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${HOME}/.${rcfile:t}"
done


for file in "${DOTFILE_DIR}/"*; do
  cp -f "$file" "${HOME}"/.zprezto/runcoms/
done

cp -f "${DOTFILE_DIR}/.p10k.zsh" "${HOME}"

#==============================================================================================================================================

echo "Change default shell to ZSH"
chsh -s /bin/zsh

#==============================================================================================================================================

echo "Set git global config"
cp -f "${DOTFILE_DIR}/.gitconfig" "${HOME}"








