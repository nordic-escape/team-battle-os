#!/bin/bash -e

# Create necessary directories
install -d "${ROOTFS_DIR}/usr/lib/aarch64-linux-gnu/wayfire/lib"
install -d "${ROOTFS_DIR}/usr/share/wayfire/metadata"
install -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config"
install -d "${ROOTFS_DIR}/root/.docker"
install -d "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d"

# Install files
install -m 644 -v files/libhide-cursor.so "${ROOTFS_DIR}/usr/lib/aarch64-linux-gnu/wayfire/libhide-cursor.so"
install -m 644 -v files/hide-cursor.xml "${ROOTFS_DIR}/usr/share/wayfire/metadata/hide-cursor.xml"
install -m 644 -v files/wayfire.ini "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/wayfire.ini"
install -m 644 -v files/config.json "${ROOTFS_DIR}/root/.docker/config.json"
install -m 644 -v files/team-battle.service "${ROOTFS_DIR}/etc/systemd/system/team-battle.service"
install -m 644 -v files/qlcplus.service "${ROOTFS_DIR}/etc/systemd/system/qlcplus.service"
install -m 644 -v files/autologin.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"
install -m 644 -v files/docker-compose.yaml "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/docker-compose.yaml"
install -m 644 -v files/production.db "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/production.db"
install -m 755 -v files/autostart.sh "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/autostart.sh"

# Clear motd file
: > "${ROOTFS_DIR}/etc/motd"

# Fix ownership of user files (using chroot to ensure correct UID/GID)
on_chroot << EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/.config
chown ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/autostart.sh
chown ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/docker-compose.yaml

sudo systemctl enable team-battle.service
sudo systemctl start team-battle.service

sudo systemctl enable qlcplus.service
sudo systemctl start qlcplus.service
EOF