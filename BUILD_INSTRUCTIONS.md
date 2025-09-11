# Elastos Carrier Bootstrap Daemon - Build Instructions

## Prerequisites Installation

### Ubuntu/Debian
```shell
sudo apt-get update
sudo apt-get install -y build-essential autoconf automake autopoint libtool bison texinfo pkg-config cmake git wget curl
```

### CentOS/RHEL/Fedora
```shell
# CentOS/RHEL 7/8
sudo yum groupinstall "Development Tools"
sudo yum install autoconf automake libtool bison texinfo pkgconfig cmake git wget curl

# Fedora
sudo dnf groupinstall "Development Tools" 
sudo dnf install autoconf automake libtool bison texinfo pkgconfig cmake git wget curl
```

### Alpine Linux
```shell
sudo apk add build-base autoconf automake libtool bison texinfo pkgconfig cmake git wget curl
```

### Arch Linux
```shell
sudo pacman -S base-devel autoconf automake libtool bison texinfo pkgconfig cmake git wget curl
```

### macOS
```shell
# Using Homebrew (Recommended)
brew install autoconf automake cmake libtool shtool pkg-config gettext git wget curl

# Using MacPorts
sudo port install autoconf automake cmake libtool pkgconfig gettext git wget curl
```

## Build Scripts

### Linux Build Script
```shell
#!/bin/bash
# build-linux.sh

# Install dependencies (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y build-essential autoconf automake autopoint libtool bison texinfo pkg-config cmake git wget curl

# Create build directory
mkdir -p build/linux
cd build/linux

# Configure and build
cmake -DCMAKE_INSTALL_PREFIX=outputs ../..
make install

# Create local config directory and keys
mkdir -p ~/ela-bootstrapd/{keys,logs,run}

echo "Build completed! Binary: build/linux/outputs/usr/bin/ela-bootstrapd"
echo "To run: ./build/linux/outputs/usr/bin/ela-bootstrapd --config=/path/to/bootstrapd.conf --foreground"
```

### macOS Build Script
```shell
#!/bin/bash
# build-macos.sh

# Install dependencies
brew install autoconf automake cmake libtool shtool pkg-config gettext git wget curl

# Create build directory  
mkdir -p build/macos
cd build/macos

# Configure and build
cmake -DCMAKE_INSTALL_PREFIX=outputs ../..
make install

# Create local config directory and keys
mkdir -p ~/ela-bootstrapd/{keys,logs,run}

echo "Build completed! Binary: build/macos/outputs/usr/bin/ela-bootstrapd"
echo "To run: ./build/macos/outputs/usr/bin/ela-bootstrapd --config=/path/to/bootstrapd.conf --foreground"
```

## Troubleshooting

### 1. `makeinfo: command not found` Error
**Problem:** libconfig build fails with makeinfo missing

**Solution:**
```shell
# Ubuntu/Debian
sudo apt-get install texinfo

# CentOS/RHEL
sudo yum install texinfo

# Fedora  
sudo dnf install texinfo
```

### 2. Permission Issues (Linux)
**Problem:** `Couldn't read/write: /var/lib/ela-bootstrapd/keys`

**Solution:** Use local config instead of system paths:
```shell
# Create local directories
mkdir -p ~/ela-bootstrapd/{keys,logs,run}

# Use local config file with local paths
# See config/bootstrapd.conf for example
```

### 3. CMake Version Issues
**Problem:** `CMake 3.X or higher is required`

**Solution:**
```shell
# Ubuntu - install latest cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main'
sudo apt-get update && sudo apt-get install cmake
```

### 4. macOS Build Issues
**Problem:** Various compilation errors on macOS

**Solution:**
```shell
# Ensure Xcode Command Line Tools
xcode-select --install

# Update Homebrew
brew update && brew upgrade

# Clear build cache
rm -rf build/macos && mkdir -p build/macos
```

## Configuration

### Local Development Configuration
Create `~/ela-bootstrapd/bootstrapd.conf`:
```
// Local development configuration
port = 33445
keys_file_path = "/Users/username/ela-bootstrapd/keys/keys"
pid_file_path = "/Users/username/ela-bootstrapd/run/ela-bootstrapd.pid"
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
  pid_file_path = "/Users/username/ela-bootstrapd/run/turnserver.pid"
  userdb = "/Users/username/ela-bootstrapd/keys/turndb"
  verbose = true
}

bootstrap_nodes = (
  {
    address = "13.58.208.50"
    port = 33445
    public_key = "89vny8MrKdDKs7Uta9RdVmspPjnRMdwMmaiEW27pZ7gh"
  },
  // Add more bootstrap nodes as needed
)
```

## Running

### Development Mode
```shell
# Run in foreground with local config
./build/linux/outputs/usr/bin/ela-bootstrapd --config=~/ela-bootstrapd/bootstrapd.conf --foreground
```

### Production Mode (Linux)
```shell
# Install as system service (requires root)
sudo dpkg -i elastos-bootstrapd.deb
sudo systemctl status ela-bootstrapd
```

## Quick Start
```shell
# 1. Clone repository
git clone https://github.com/elastos/Elastos.CarrierClassic.Bootstrap.git
cd Elastos.CarrierClassic.Bootstrap

# 2. Run build script
chmod +x BUILD_INSTRUCTIONS.md  # This file contains the scripts
# Copy the Linux or macOS build script and save as build.sh, then:
chmod +x build.sh
./build.sh

# 3. Create local config
mkdir -p ~/ela-bootstrapd/{keys,logs,run}
cp config/bootstrapd.conf ~/ela-bootstrapd/
# Edit ~/ela-bootstrapd/bootstrapd.conf to use local paths

# 4. Run
./build/linux/outputs/usr/bin/ela-bootstrapd --config=~/ela-bootstrapd/bootstrapd.conf --foreground
```
