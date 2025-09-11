#!/bin/bash
# setup-ubuntu.sh - Setup script for Ubuntu bootstrap daemon

set -e

echo "=== Elastos Bootstrap Daemon Ubuntu Setup ==="

# 1. Install dependencies
echo "Installing build dependencies..."
sudo apt-get update
sudo apt-get install -y build-essential autoconf automake autopoint libtool bison texinfo pkg-config cmake git wget curl

# 2. Create local directories (avoid system path permission issues)
echo "Creating local configuration directories..."
mkdir -p ~/ela-bootstrapd/{keys,logs,run}

# 3. Build the project
echo "Building bootstrap daemon..."
if [ ! -d "build/linux" ]; then
    mkdir -p build/linux
fi

cd build/linux
cmake -DCMAKE_INSTALL_PREFIX=outputs ../..
make install
cd ../..

# 4. Create local configuration file
echo "Creating local configuration file..."
cat > ~/ela-bootstrapd/bootstrapd.conf << 'EOF'
// Local Ubuntu configuration for Elastos Bootstrap Daemon
port = 33445
keys_file_path = "~/ela-bootstrapd/keys/keys"
pid_file_path = "~/ela-bootstrapd/run/ela-bootstrapd.pid"
enable_ipv6 = false
enable_ipv4_fallback = true
enable_lan_discovery = true
enable_tcp_relay = true
tcp_relay_ports = [443, 3389, 33445]
enable_motd = true
motd = "elastos-bootstrapd"

turn = {
  port = 3478
  realm = "elastos.org"
  pid_file_path = "~/ela-bootstrapd/run/turnserver.pid"
  userdb = "~/ela-bootstrapd/keys/turndb"
  verbose = true
}

bootstrap_nodes = (
  {
    address = "13.58.208.50"
    port = 33445
    public_key = "89vny8MrKdDKs7Uta9RdVmspPjnRMdwMmaiEW27pZ7gh"
  },
  {
    address = "18.216.102.47"
    port = 33445
    public_key = "G5z8MqiNDFTadFUPfMdYsYtkUDbX5mNCMVHMZtsCnFeb"
  },
  {
    address = "18.216.6.197"
    port = 33445
    public_key = "H8sqhRrQuJZ6iLtP2wanxt4LzdNrN2NNFnpPdq1uJ9n2"
  },
  {
    address = "54.193.141.205"
    port = 33445
    public_key = "7TfZWZNV8vnBxxWzJXuvKgX2QyKkLpg2oXx3LQ5tg8LW"
  },
  {
    address = "52.74.215.181"
    port = 33445
    public_key = "Xv6d34WaUw9bPn7YihzVAFw7D2igbQJZ3jwmzzfYVFV"
  },
  {
    address = "52.63.19.190"
    port = 33445
    public_key = "EeNenbyS4sx3qtu82esT1V1NMe9dZib5LyQmYGM6fboK"
  },
  {
    address = "52.57.248.163"
    port = 33445
    public_key = "CfJLve8FNQPQJ9xYQ8oEVkPxeAPCN7iSdhnYFkWmWgLn"
  },
  {
    address = "35.179.41.220"
    port = 33445
    public_key = "6u2vKadPa9wqDf531QaZy7FJN3c7Wzntm7dKXxXqvyNB"
  },
  {
    address = "43.129.244.17"
    port = 33445
    public_key = "8qoXec3GGYGvMrnim4mNwsCUZeygjMizXgFjTEuFPA9u"
  }
)
EOF

# 5. Fix path expansion in config (replace ~ with actual home path)
sed -i "s|~/ela-bootstrapd|$HOME/ela-bootstrapd|g" ~/ela-bootstrapd/bootstrapd.conf

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Bootstrap daemon binary: $(pwd)/build/linux/outputs/usr/bin/ela-bootstrapd"
echo "Configuration file: ~/ela-bootstrapd/bootstrapd.conf"
echo "Data directory: ~/ela-bootstrapd/"
echo ""
echo "To run the bootstrap daemon:"
echo "  cd $(pwd)/build/linux/outputs/usr/bin"
echo "  ./ela-bootstrapd --config=$HOME/ela-bootstrapd/bootstrapd.conf --foreground"
echo ""
echo "To check if it's working:"
echo "  # Look for 'Public Key:' in the output"
echo "  # Should not see any permission errors"
echo ""
