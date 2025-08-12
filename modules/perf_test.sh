#!/bin/bash
# 性能测试模块，调用LloydAsp项目

function perf_test_menu() {
  echo "本功能使用 LloydAsp 的性能测试脚本"
  echo "项目地址: https://run.NodeQuality.com"
  read -rp "请按回车开始性能测试，或Ctrl+C退出" _
  bash <(curl -sL https://run.NodeQuality.com)
}
