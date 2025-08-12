#!/bin/bash
# cleanup.sh - VPS磁盘空间及垃圾文件清理模块
# 适用于 Debian/Ubuntu 类系统

function cleanup_menu() {
  echo "开始清理无用日志和垃圾文件..."

  local disk_before
  disk_before=$(df -h / | awk 'NR==2{print $3 " / " $2}')

  # 1. 清理 systemd journal 日志，保留最近3天
  echo "清理 systemd journal 日志..."
  sudo journalctl --vacuum-time=3d

  # 2. 清理 apt 缓存和自动删除无用依赖包
  echo "清理 apt 缓存和自动删除无用依赖包..."
  sudo apt clean
  sudo apt autoremove -y

  # 3. 清理旧内核（排除当前内核）
  clean_old_kernels() {
    if ! command -v dpkg >/dev/null; then
      echo "非 Debian 系系统，跳过旧内核清理。"
      return
    fi
    if [[ "$(uname -r)" == *generic ]]; then
      echo "清理旧内核..."
      sudo dpkg -l 'linux-image-*' | awk '/^ii/{print $2}' | grep -v "$(uname -r)" | xargs -r sudo apt -y purge
    else
      echo "非标准 generic 内核，跳过旧内核清理。"
    fi
  }

  clean_old_kernels

  # 4. 清理用户缓存目录（root 和 sudo 用户）
  echo "清理用户缓存目录..."
  rm -rf /root/.cache/*
  if [ -n "$SUDO_USER" ]; then
    rm -rf /home/"$SUDO_USER"/.cache/*
  fi

  # 5. 清理 /tmp 和 /var/tmp，删除超过3天未访问文件
  echo "清理临时文件夹..."
  sudo find /tmp -type f -atime +3 -delete
  sudo find /var/tmp -type f -atime +3 -delete

  local disk_after
  disk_after=$(df -h / | awk 'NR==2{print $3 " / " $2}')

  echo
  echo "清理完成。磁盘空间情况："
  echo "清理前： $disk_before"
  echo "清理后： $disk_after"
  df -h /

  echo "建议定期检查系统磁盘使用情况，避免空间不足导致服务异常。"
}
