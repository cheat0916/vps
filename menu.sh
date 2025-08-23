#!/bin/bash
# VPS初始化主菜单脚本（完善版）
# 作者: Cheat

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # 无色

# 多语言支持
declare -A LANG_ZH_CN=(
  [welcome]="欢迎使用VPS初始化脚本"
  [choose_lang]="请选择语言:"
  [option_1]="1. 在hosts中添加当前hostname"
  [option_2]="2. 添加官方软件源"
  [option_3]="3. swap管理"
  [option_4]="4. 安装Warp"
  [option_5]="5. 性能测试"
  [option_6]="6. 磁盘及垃圾文件清理"
  [option_7]="7. IPv6解锁检测"
  [option_8]="8. 退出"
  [prompt]="请输入选项数字："
  [invalid]="无效选项，请重新输入。"
  [press_enter]="按回车键返回菜单..."
  [checking_deps]="检查依赖..."
  [installing]="缺少依赖，正在尝试安装："
  [mod_missing]="模块 %s 不存在，正在下载..."
  [mod_down_fail]="下载失败，请检查网络或仓库地址。"
  [bye]="拜拜！"
)

declare -A LANG_ZH_TW=(
  [welcome]="歡迎使用VPS初始化腳本"
  [choose_lang]="請選擇語言:"
  [option_1]="1. 在hosts中添加當前hostname"
  [option_2]="2. 添加官方軟體源"
  [option_3]="3. swap管理"
  [option_4]="4. 安裝Warp"
  [option_5]="5. 性能測試"
  [option_6]="6. 磁碟及垃圾檔案清理"
  [option_7]="7. IPv6解鎖檢測"
  [option_8]="8. 退出"
  [prompt]="請輸入選項數字："
  [invalid]="無效選項，請重新輸入。"
  [press_enter]="按回車鍵返回菜單..."
  [checking_deps]="檢查依賴..."
  [installing]="缺少依賴，正在嘗試安裝："
  [mod_missing]="模組 %s 不存在，正在下載..."
  [mod_down_fail]="下載失敗，請檢查網路或倉庫地址。"
  [bye]="掰掰！"
)

declare -A LANG_EN=(
  [welcome]="Welcome to VPS Initialization Script"
  [choose_lang]="Please select language:"
  [option_1]="1. Add current hostname to hosts"
  [option_2]="2. Add official software sources"
  [option_3]="3. Manage swap"
  [option_4]="4. Install Warp"
  [option_5]="5. Performance test"
  [option_6]="6. Clean disk and junk files"
  [option_7]="7. IPv6 Unlock Check"
  [option_8]="8. Exit"
  [prompt]="Please enter an option number:"
  [invalid]="Invalid option, please try again."
  [press_enter]="Press Enter to return to menu..."
  [checking_deps]="Checking dependencies..."
  [installing]="Missing dependency, trying to install:"
  [mod_missing]="Module %s not found, downloading..."
  [mod_down_fail]="Download failed, please check network or repo URL."
  [bye]="Bye!"
)

CURRENT_LANG=LANG_ZH_CN

# 简单函数取翻译，使用 declare -n 进行间接引用
function t() {
  local key=$1
  declare -n lang_ref="$CURRENT_LANG"
  echo -e "${lang_ref[$key]}"
}

function t_format() {
  # printf格式化输出，用于带变量的翻译
  local key=$1; shift
  declare -n lang_ref="$CURRENT_LANG"
  printf "${lang_ref[$key]}\n" "$@"
}

# 语言选择
function choose_language() {
  echo -e "${YELLOW}1) 简体中文"
  echo -e "2) 繁體中文"
  echo -e "3) English${NC}"
  read -rp "Select language [1-3]: " lang_choice
  case $lang_choice in
    1) CURRENT_LANG=LANG_ZH_CN ;;
    2) CURRENT_LANG=LANG_ZH_TW ;;
    3) CURRENT_LANG=LANG_EN ;;
    *) CURRENT_LANG=LANG_ZH_CN ;;
  esac
}

# 美化Logo，含作者名
function show_logo() {
  echo -e "${CYAN}"
  echo " __      __      _       "
  echo " \ \    / /__ _ (_) __ _ "
  echo "  \ \/\/ / _ \ '_| |/ _\` |"
  echo "   \_/\_/\___/_| |_|\__,_|"
  echo "                         "
  echo -e "       欢迎使用，作者: ${GREEN}Cheat${CYAN}"
  echo -e "${NC}"
}

# 检查依赖命令并安装
function check_dependencies() {
  echo -e "$(t checking_deps)"
  local deps=("curl" "wget" "lsb_release" "grep" "awk" "sed" "df" "free" "uname")
  for cmd in "${deps[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo -e "${RED}$(t installing) $cmd${NC}"
      if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y "$cmd"
      elif command -v yum &>/dev/null; then
        sudo yum install -y "$cmd"
      else
        echo -e "${RED}Unknown package manager, please install $cmd manually.${NC}"
      fi
    fi
  done
}

# 扩展主机信息显示
function show_host_info() {
  echo -e "${BLUE}------ 当前主机信息 ------${NC}"
  echo "系统版本: $(lsb_release -d | cut -f2-)"
  echo "内核版本: $(uname -r)"
  echo "架构: $(uname -m)"
  echo "CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2- | sed 's/^[ \t]*//')"
  echo "内存总量: $(free -h | grep Mem | awk '{print $2}')"
  echo -n "磁盘空间: "
  df -h / | tail -1 | awk '{print $2 " 总，共用: " $3}'
  echo "IP地址: $(hostname -I | awk '{print $1}')"
  # 虚拟化检测
  virt_type="未知"
  if command -v systemd-detect-virt &>/dev/null; then
    virt_type=$(systemd-detect-virt)
  fi
  echo "虚拟化: $virt_type"
  # 检测是否启用 TUN
  if [[ -c /dev/net/tun ]]; then
    echo "TUN设备: 已启用"
  else
    echo "TUN设备: 未启用"
  fi
  # 检测BBR是否启用
  bbr_status=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | awk '{print $3}')
  echo "BBR状态: ${bbr_status:-未知}"
  echo "--------------------------"
  echo
}

# 自动更新模块
function update_modules() {
  mkdir -p modules
  echo -e "${YELLOW}正在更新模块...${NC}"
  local base_url="https://raw.githubusercontent.com/cheat0916/vps/main/modules"
  for mod in hosts repos swap warp perf_test cleanup unlock_check; do
    echo -n "更新 $mod ... "
    if wget -q -O "modules/${mod}.sh" "${base_url}/${mod}.sh"; then
      chmod +x "modules/${mod}.sh"
      echo -e "${GREEN}成功${NC}"
    else
      echo -e "${RED}失败${NC}"
    fi
  done
  echo -e "${YELLOW}模块更新完成！${NC}\n"
}

# 下载并保证模块存在
function ensure_module() {
  local module_name=$1
  local url_base="https://raw.githubusercontent.com/cheat0916/vps/main/modules"
  local module_path="./modules/${module_name}.sh"
  if [ ! -f "$module_path" ]; then
    t_format mod_missing "$module_name"
    mkdir -p ./modules
    if ! wget -q --show-progress -O "$module_path" "${url_base}/${module_name}.sh"; then
      echo -e "${RED}$(t mod_down_fail)${NC}"
      return 1
    fi
    chmod +x "$module_path"
  fi
  return 0
}

# 主菜单
function main_menu() {
  while true; do
    clear
    show_logo
    echo -e "$(t welcome)"
    show_host_info
    echo ""
    echo -e "$(t option_1)"
    echo -e "$(t option_2)"
    echo -e "$(t option_3)"
    echo -e "$(t option_4)"
    echo -e "$(t option_5)"
    echo -e "$(t option_6)"
    echo -e "$(t option_7)"
    echo -e "$(t option_8)"
    echo -n "$(t prompt) "
    read -r choice
    case $choice in
      1)
        ensure_module "hosts" && source ./modules/hosts.sh && hosts_menu "$CURRENT_LANG"
        ;;
      2)
        ensure_module "repos" && source ./modules/repos.sh && repos_menu "$CURRENT_LANG"
        ;;
      3)
        ensure_module "swap" && source ./modules/swap.sh && swap_menu "$CURRENT_LANG"
        ;;
      4)
        ensure_module "warp" && source ./modules/warp.sh && warp_menu "$CURRENT_LANG"
        ;;
      5)
        ensure_module "perf_test" && source ./modules/perf_test.sh && perf_test_menu "$CURRENT_LANG"
        ;;
      6)
        ensure_module "cleanup" && source ./modules/cleanup.sh && cleanup_menu "$CURRENT_LANG"
        ;;
      7)
        ensure_module "unlock_check" && bash ./modules/unlock_check.sh
        ;;
      8)
        echo -e "$(t bye)"
        exit 0
        ;;
      *)
        echo -e "${RED}$(t invalid)${NC}"
        ;;
    esac
    echo -e "$(t press_enter)"
    read -r
  done
}

# 主流程
choose_language
check_dependencies
update_modules
main_menu
