#!/bin/bash
# 磁盘清理模块

function cleanup_menu() {
  echo "开始清理无用日志和垃圾文件..."
  # 一些常用日志路径
  sudo journalctl --vacuum-time=3d
  sudo rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/**/*.gz /var/log/**/*.1 2>/dev/null
  sudo apt-get clean

  echo "清理完成。磁盘空间情况："
  df -h /
}
