# Set kebijakan default untuk INPUT menjadi DROP
sudo iptables -P INPUT DROP

# Izinkan koneksi TCP dari IP 10.2.1.48 ke port 6699
sudo iptables -A INPUT -p tcp -s 10.2.1.48 --dport 6699 -j ACCEPT

# (Jika diperlukan) Drop semua koneksi TCP ke port 6699
sudo iptables -A INPUT -p tcp --dport 6699 -j DROP

# Izinkan koneksi yang sudah ada
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# Izinkan koneksi dengan ctstate RELATED,ESTABLISHED
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Izinkan akses TCP ke port 53 (DNS)
sudo iptables -A INPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 53 -j ACCEPT

# Set kebijakan default untuk OUTPUT menjadi DROP
sudo iptables -P OUTPUT DROP

# Izinkan koneksi TCP ke port 80 dan 443 (HTTP)
sudo iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT

# Izinkan koneksi yang sudah ada
sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
