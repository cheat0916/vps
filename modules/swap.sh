#!/bin/bash
# swap 管理模块

# 检测系统是否支持 swap
function check_swap_support() {
  if grep -q swap /proc/filesystems; then
    return 0   # 支持swap
  else
    return 1   # 不支持swap
  fi
}

# 显示当前swap信息
function show_swap_info() {
  echo "检测当前swap信息..."
  swapon --show
  free -h | awk '/Swap:/ {print "Swap总量: "$2", 已用: "$3", 空闲: "$4}'
}

# 创建swap文件
function create_swap() {
  local size=$1
  echo "创建 ${size}MB swap 文件..."

  # 如果已存在swapfile，先删除
  if swapon --show | grep -q '/swapfile'; then
    echo "检测到已启用的 /swapfile，先关闭并删除..."
    swapoff /swapfile
    rm -f /swapfile
  fi

  fallocate -l ${size}M /swapfile
  chmod 600 /swapfile
  mkswap /swapfile

  if swapon /swapfile; then
    echo "Swap 启用成功。"
  else
    echo "Swap 启用失败，可能宿主环境不支持 swap。"
  fi
  show_swap_info
}

# 删除swap
function delete_swap() {
  echo "关闭并删除swap文件..."
  swapoff /swapfile 2>/dev/null
  rm -f /swapfile
  echo "Swap文件已删除。"
  show_swap_info
}

# 主菜单
function swap_menu() {
  echo "检测当前swap信息..."
  show_swap_info

  if ! check_swap_support; then
    echo "警告：系统内核未启用 swap 支持，无法创建 swap 文件。"
    echo "请确认宿主环境是否支持swap。"
  fi

  # 建议swap大小（简易示例）
  local suggest_size=2000
  echo "建议swap大小: ${suggest_size}MB"

  while true; do
    echo "请选择操作："
    echo "1) 创建swap文件"
    echo "2) 删除swap"
    echo "3) 退出"
    read -rp "输入数字: " choice

    case "$choice" in
      1)
        if ! check_swap_support; then
          echo "当前系统不支持swap，无法创建。"
          continue
        fi
        read -rp "请输入swap大小（MB）: " size
        if ! [[ "$size" =~ ^[0-9]+$ ]]; then
          echo "请输入有效数字！"
          continue
        fi
        create_swap "$size"
        ;;
      2)
        delete_swap
        ;;
      3)
        echo "退出swap管理。"
        break
        ;;
      *)
        echo "无效选项，请重新输入。"
        ;;
    esac
  done
}

# 直接运行时调用菜单
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  swap_menu
fi
