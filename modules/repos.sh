#!/bin/bash
# 软件源管理模块

function repos_menu() {
  echo "检测系统类型，添加对应官方软件源..."
  if command -v lsb_release &>/dev/null; then
    dist=$(lsb_release -si)
    codename=$(lsb_release -c -s)
  else
    dist=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
    codename=$(awk -F= '/^VERSION_CODENAME=/{print $2}' /etc/os-release | tr -d '"')
  fi

  echo "系统：$dist 代号：$codename"

  if [[ "$dist" =~ (Ubuntu|Debian) ]]; then
    echo "备份当前sources.list"
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak_$(date +%F_%T)

    sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb http://archive.ubuntu.com/ubuntu/ ${codename} main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ ${codename}-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ ${codename}-security main restricted universe multiverse
EOF

    echo "更新软件源..."
    sudo apt update

  elif [[ "$dist" =~ (CentOS|Rocky|AlmaLinux) ]]; then
    echo "暂未实现CentOS系软件源添加功能"
  else
    echo "不支持的系统类型，请手动配置软件源"
  fi
}
