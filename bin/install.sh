#!/usr/bin/env sh

# Request and keep the administrator password active.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

log() {
  echo
  echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] $@"
}

check_xcode_select() {
  if ! xcode-select -p &>/dev/null; then
    log "Xcode Command Line Tools not found. Installing..."
    xcode-select --install

    # Wait until the installation is complete
    until xcode-select -p &>/dev/null; do
      sleep 5
    done

    log "Xcode Command Line Tools installed successfully."
  else
    log "Xcode Command Line Tools are already installed."
  fi
}

check_config_repository() {
  local github_username="ymokry"
  local repo_name="oh-my-config"
  local repo_https_url="https://github.com/$github_username/$repo_name.git"
  local repo_ssh_url="git@github.com:$github_username/$repo_name.git"
  local config_dir="$HOME/.$repo_name"

  if [ -d "$config_dir" ]; then
    log "$config_dir is already initialized."
    return
  fi

  log "$config_dir does not exist. Cloning the GitHub repository..."
  git clone "$repo_https_url" "$config_dir"

  if [ $? -ne 0 ]; then
    log "Failed to clone the repository."
    return 1
  fi

  log "Repository cloned successfully into $config_dir."

  log "Changing the remote URL from HTTPS to SSH..."
  cd "$config_dir" || { log "Failed to change directory to $config_dir"; return 1; }
  git remote set-url origin "$repo_ssh_url"

  if [ $? -eq 0 ]; then
    log "Remote URL successfully changed to SSH."
  else
    log "Failed to change the remote URL."
  fi
}

log "Starting Mac setup..."

check_xcode_select
check_config_repository

log "Mac setup completed."
read -p "$(log 'Press [Enter] to exit')"
