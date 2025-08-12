#!/bin/bash
# swap管理模块

function swap_menu() {
  echo "检测当前swap信息..."
  swapon --show

  total_mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  total_mem_mb=$((total_mem_kb / 1024))
  suggested_swap_mb=$((total_mem_mb * 2))
  echo "建议swap大小: ${suggested_swap_mb}MB"

  echo "请选择操作："
  echo "1) 创建swap文件"
  echo "2) 删除swap"
  echo "3) 退出"

  read -rp "输入数字: " swap_choice
  case $swap_choice in
    1)
      read -rp "请输入swap大小（MB）: " size_mb
      if [ -z "$size_mb" ] || ! [[ "$size_mb" =~ ^[0-9]+$ ]]; then
        echo "输入无效"
        return
      fi
      create_swap "$size_mb"
      ;;
    2)
      remove_swap
      ;;
    3)
      return
      ;;
    *)
      echo "无效选择"
      ;;
  esac
}

function create_swap() {
  local size_mb=$1
  echo "创建 ${size_mb}MB swap 文件..."

  sudo swapoff -a
  sudo rm -f /swapfile
  sudo dd if=/dev/zero of=/swapfile bs=1M count="$size_mb" status=progress
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile

  # 确保开机启用
  if ! grep -q '/swapfile' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  fi

  echo "Swap创建完成，当前swap状态："
  swapon --show
}

function remove_swap() {
  echo "关闭并删除swap文件..."

  sudo swapoff -a
  sudo rm -f /swapfile
  sudo sed -i '/swapfile/d' /etc/fstab

  echo "Swap已删除"
}
