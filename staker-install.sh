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

echo "Request testnet tokens by joining the Discord server and type .getfunded <YOUR_CHECKSUM_ETH_ADDRESS> in the #testnet-faucet channel: https://discord.gg/7rmXa3S"

# Install Nucypher dependencies
sudo apt-get install libffi-dev
sudo apt-get install python3-dev
sudo apt-get install python3-virtualenv
sudo apt install python3-pip
pip3 install virtualenv

# NOTE: may need to restart session here, then run:
#       source /opt/nucypher/nucypher-venv/bin/activate

sudo mkdir /opt/nucypher

# Create virtual environment
sudo /home/ubuntu/.local/bin/virtualenv /opt/nucypher/nucypher-venv
source /opt/nucypher/nucypher-venv/bin/activate

# Install nucypher while inside virtual environment
sudo pip3 install -U nucypher

# Initialize a new stakeholder
sudo nucypher stake init-stakeholder --provider ipc:///root/.ethereum/goerli/geth.ipc --poa

# Initialize a new stake
sudo nucypher stake create --provider ipc:///root/.ethereum/goerli/geth.ipc

# Now, list all of the stakes
sudo nucypher stake list --provider ipc:///root/.ethereum/goerli/geth.ipc

# Finally, bond an Ursula to a staker
sudo nucypher stake set-worker --provider ipc:///root/.ethereum/goerli/geth.ipc

echo "Staker setup! If you would like to learn about automatic reward restaking, see: https://docs.nucypher.com/en/latest/guides/staking_guide.html#manage-automatic-reward-re-staking"
