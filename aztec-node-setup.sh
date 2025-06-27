#!/bin/bash

set -e

echo "========================================"
echo "🔧 Starting Full AZTEC Node Setup (With Docker Fix)"
echo "========================================"

yes | bash <<'EOF'

echo "[1/10] Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

echo "[2/10] Installing Node.js v20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "[3/10] Installing essential packages..."
sudo apt-get install -y curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf screen htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev ufw apt-transport-https ca-certificates software-properties-common

echo "[4/10] Installing Docker and Docker Compose..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce

sudo systemctl enable --now docker

echo "[⚙️  Docker permission setup...]"
sudo usermod -aG docker $USER

# Ensure docker group applies immediately
if ! groups | grep -q docker; then
  echo "⚠️  Docker group not yet applied. Restarting shell in docker group..."
  exec sg docker "$0"
  exit
fi

sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker --version
docker-compose --version
docker ps > /dev/null 2>&1 && echo "Docker accessible ✅" || echo "❌ Docker not accessible"

echo "[5/10] Installing AZTEC CLI..."
bash -i <(curl -s https://install.aztec.network)

echo "[6/10] Adding AZTEC CLI path to .bashrc..."
echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo "[7/10] Pulling latest AZTEC node docker image..."
aztec-up latest

echo "[8/10] Setting up firewall rules..."
sudo ufw allow 22
sudo ufw allow ssh
sudo ufw allow 40400
sudo ufw allow 8080
sudo ufw --force enable

EOF

echo "========================================"
echo "📝 Please enter AZTEC node configuration:"

read -p "Network (default: alpha-testnet): " network
network=${network:-alpha-testnet}

read -p "L1 RPC URLs (default: https://rpc.sepolia.org): " l1_rpc
l1_rpc=${l1_rpc:-https://rpc.sepolia.org}

read -p "L1 Consensus Host URLs (default: https://beaconstate-sepolia.chainsafe.io): " l1_consensus
l1_consensus=${l1_consensus:-https://beaconstate-sepolia.chainsafe.io}

read -p "Sequencer Validator Private Key (0x...): " priv_key
read -p "Sequencer Coinbase Address (0x...): " coinbase
read -p "P2P IP Address: " p2p_ip

# Save input to a config log file
config_file="$HOME/aztec-config-log.txt"
echo "===== AZTEC Node Configuration =====" > "$config_file"
echo "Network: $network" >> "$config_file"
echo "L1 RPC: $l1_rpc" >> "$config_file"
echo "L1 Consensus: $l1_consensus" >> "$config_file"
echo "Validator Private Key: $priv_key" >> "$config_file"
echo "Coinbase Address: $coinbase" >> "$config_file"
echo "P2P IP: $p2p_ip" >> "$config_file"
echo "✅ Configuration saved to $config_file"

# Compose full command with safe PATH
cmd="export PATH=\$HOME/.aztec/bin:\$PATH && aztec start --node --archiver --sequencer \
--network $network \
--l1-rpc-urls $l1_rpc \
--l1-consensus-host-urls $l1_consensus \
--sequencer.validatorPrivateKey $priv_key \
--sequencer.coinbase $coinbase \
--p2p.p2pIp $p2p_ip >> \$HOME/aztec-node.log 2>&1"

# Save for debug
echo "$cmd" > ~/last_aztec_cmd.sh

# Start in screen session with log
screen -L -Logfile ~/aztec-screen.log -dmS AZZ bash -l -c "$cmd"

echo ""
echo "✅ AZTEC node started in screen session 'AZZ'."
echo "📄 Logs (CLI): saved to ~/aztec-node.log"
echo "📄 Logs (Screen): saved to ~/aztec-screen.log"
echo "▶️ To view screen: screen -r AZZ"
echo "🧹 To detach: Press Ctrl+A then D"
echo "🔎 Or tail log: tail -f ~/aztec-screen.log"
