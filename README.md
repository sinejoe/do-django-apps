Ubuntu 18.04.03

```
sudo apt update
sudo apt -y dist-upgrade
sudo apt -y autoremove
sudo systemctl reboot

ssh-keygen
adduser ubuntu
mkdir /home/ubuntu/.ssh
cp ~/.ssh/* /home/ubuntu/.ssh
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

visudo
# Add below root line
ubuntu  ALL=(ALL:ALL) NOPASSWD: ALL

sudo nano /etc/ssh/sshd_config
Port 24445
PermitRootLogin no

sudo systemctl restart ssh

sudo apt install -y git autojump docker.io docker-compose

# Setup SWAP (4Gig)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# verify swap setup successfully
sudo swapon -s
free -m

# enable permanently
sudo nano /etc/fstab
    # add to bottom
    /swapfile   none    swap    sw    0   0

sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50

sudo nano /etc/sysctl.conf
    # add to bottom
    vm.swappiness=10
    vm.vfs_cache_pressure=50

sudo apt -y autoremove

sudo mkdir /var/www
sudo chown -R ubuntu:ubuntu /var/www
mkdir /var/www/db
mkdir /var/www/certbot

cd /var/www
git clone git@github.com:sinejoe/do-django-apps.git

```

