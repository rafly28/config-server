#!/bin/bash

# Set kebijakan default untuk zona public menjadi DROP
sudo firewall-cmd --zone=public --set-target=DROP --permanent

# Izinkan layanan yang diperlukan
sudo firewall-cmd --zone=public --add-service=dhcpv6-client --permanent
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent
sudo firewall-cmd --zone=public --add-service=ssh --permanent

# Izinkan port 53 untuk TCP dan UDP
sudo firewall-cmd --zone=public --add-port=53/tcp --permanent
sudo firewall-cmd --zone=public --add-port=53/udp --permanent

# Izinkan forwarding
sudo firewall-cmd --zone=public --set-target=DROP --permanent

# Tambahkan rich rule untuk mengizinkan koneksi dari subnet 10.2.1.0/24 ke port 6699
sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="10.2.1.0/24" port protocol="tcp" port="6699" accept' --permanent

# Reload firewalld untuk menerapkan perubahan
sudo firewall-cmd --reload

echo "Konfigurasi firewalld telah diterapkan."