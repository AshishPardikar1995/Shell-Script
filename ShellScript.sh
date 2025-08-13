#!/bin/bash

set -e

echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "☕ Installing latest Java (OpenJDK)..."
sudo apt install -y openjdk-17-jdk
java -version

echo "🐳 Installing Docker..."

# Remove old versions if any
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Install prerequisites
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, CLI, Buildx, Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "✅ Docker installed."
docker --version

echo "👥 Adding current user ($USER) to docker group..."
sudo usermod -aG docker "$USER"

echo "🔄 Applying group changes..."
newgrp docker <<EONG
docker ps
EONG

echo "🎉 Installation complete! Please log out and log back in for docker group changes to take full effect."
