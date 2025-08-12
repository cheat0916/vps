#!/bin/bash
# Warp安装模块，调用fscarmen项目

function warp_menu() {
  echo "本功能使用 fscarmen 的 Warp 脚本"
  echo "项目地址: https://gitlab.com/fscarmen/warp"
  echo "将调用官方安装脚本..."

  read -rp "请按回车继续安装 Warp，或Ctrl+C退出" _
  wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh
}
