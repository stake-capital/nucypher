# Install Geth
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum

# Create systemd unit file for Geth
echo "[Unit]
Description=Ethereum go client

[Service]
Type=simple
ExecStart=/usr/bin/geth --goerli --syncmode light

[Install]
WantedBy=default.target" > geth.service

sudo mv geth.service /etc/systemd/system/
sudo systemctl enable geth.service
sudo systemctl start geth.service

echo "You can view the Geth output by running: journalctl -u geth.service -f"

echo "Please enter a password for your new Ethereum account:"

sudo geth attach ipc:///root/.ethereum/goerli/geth.ipc --exec "personal.newAccount(); console.log(eth.accounts[0]);"

echo "Fund this account with Görli testnet ETH: https://goerli-faucet.slock.it/"

# Install Nucypher dependencies
sudo apt-get install libffi-dev
sudo apt-get install python3-dev
sudo apt-get install python3-virtualenv
sudo apt install python3-pip
pip3 install virtualenv

# NOTE: may need to restart session here

sudo mkdir /opt/nucypher

# Create virtual environment
sudo /home/ubuntu/.local/bin/virtualenv /opt/nucypher/nucypher-venv
source /opt/nucypher/nucypher-venv/bin/activate

# Install nucypher while inside virtual environment
sudo pip3 install -U nucypher

# Initialize Ursula
sudo nucypher ursula init --provider ipc:///root/.ethereum/goerli/geth.ipc --poa --staker-address 0x87c0915e34e89628d33ce98588a400c1c0fa4f41

# Run Ursula
sudo nucypher ursula run --teacher discover.nucypher.network:9151 --interactive
