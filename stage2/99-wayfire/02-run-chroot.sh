#!/bin/bash -e

# Install argon case
curl https://download.argon40.com/argon-eeprom.sh | bash
curl https://download.argon40.com/argonneo5.sh | bash

# Install wayland
apt-get install -y wayfire seatd xdg-user-dirs

# Install chromium-browser
apt-get install -y chromium

# Install docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli docker-compose-plugin

# Install QLC+
sudo apt-get install -y qlcplus libgl1 libglu1-mesa
sudo ln -sf /usr/lib/mesa-diverted/aarch64-linux-gnu/libGL.so.1 /usr/lib/aarch64-linux-gnu/libGL.so.1