#!/bin/bash
# hosts管理模块

function hosts_menu() {
  echo "当前hostname: $(hostname)"
  echo "正在尝试将 hostname 添加到 /etc/hosts 文件..."

  local host_entry="127.0.0.1 $(hostname)"

  if grep -q "$(hostname)" /etc/hosts; then
    echo "/etc/hosts 已经包含当前hostname。"
  else
    echo "$host_entry" | sudo tee -a /etc/hosts
    echo "已添加：$host_entry"
  fi
}
