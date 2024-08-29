#!/usr/bin/env sh

echo "Starting Mac setup..."

# Request and keep the administrator password active.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if ! xcode-select -p &>/dev/null; then
  echo "Xcode Command Line Tools not found. Installing..."
  xcode-select --install

  # Wait until the installation is complete
  until xcode-select -p &>/dev/null; do
    sleep 5
  done

  echo "Xcode Command Line Tools installed successfully."
else
  echo "Xcode Command Line Tools are already installed."
fi
