#!/bin/bash

# ============================
# 🌟 GENSYN BY PRODIP 🌟
# ============================

set -e

# 🎨 BLINKING TITLE (Yellow + Pink)
echo -e "\e[5m\e[33m=============================\e[0m"
echo -e "\e[5m\e[95m🌟  GENSYN BY PRODIP  🌟\e[0m"
echo -e "\e[5m\e[33m=============================\e[0m"
sleep 2

echo "🔧 System update & dependency install suru hocche..."
sudo apt update
sudo apt install -y tmux sudo
sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof ufw

echo "📦 Yarn setup..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

echo "🚀 ABHIEBA node.sh script run hocche..."
curl -sSL https://raw.githubusercontent.com/ABHIEBA/Gensyn/main/node.sh | bash

echo "📁 tmux session 'GEN' cholche..."
tmux new-session -d -s GEN '
cd $HOME
rm -rf gensyn-testnet
git clone https://github.com/zunxbt/gensyn-testnet.git
chmod +x gensyn-testnet/gensyn.sh
./gensyn-testnet/gensyn.sh
sleep 5
tmux send-keys -t GEN C-c
rm -rf gensyn-testnet
git clone https://github.com/zunxbt/gensyn-testnet.git
chmod +x gensyn-testnet/gensyn.sh
yes 1 | ./gensyn-testnet/gensyn.sh
sleep 10
tmux send-keys -t GEN C-b d
'

echo "🛡️ UFW firewall setup..."
sudo ufw allow 22
sudo ufw allow 3000/tcp
sudo ufw --force enable

echo "🌐 Cloudflared install hocche..."
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

echo "🌍 tmux session 'TUNNEL' e cloudflared run hocche..."
tmux new-session -d -s TUNNEL 'cloudflared tunnel --url http://localhost:3000'

# 🔔 Final Message
echo ""
echo -e "\e[5m\e[33m=======================================\e[0m"
echo -e "\e[5m\e[95m🌟 GENSYN BY PRODIP: SETUP COMPLETE 🌟\e[0m"
echo -e "\e[5m\e[33m=======================================\e[0m"
echo ""
echo "🔗 Login link dekhte chaile: tmux attach -t TUNNEL"
echo "🧠 Node prompt dekhte chaile: tmux attach -t GEN"
echo "⚠️ swarm.pem move korte hobe nijeke: mv swarm.pem rl-swarm/"
