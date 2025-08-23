#!/bin/bash
###
# IPv4 + IPv6 多平台解锁检测（仅公网，整齐表格）

###

# 颜色
GREEN=$'\033[0;32m'
RED=$'\033[0;31m'
YELLOW=$'\033[1;33m'
NC=$'\033[0m'

# 测试目标
NETFLIX_ORIGINAL="https://www.netflix.com/title/80018499"
NETFLIX_MOVIE="https://www.netflix.com/title/70143836"
DISNEY_TEST="https://www.disneyplus.com"
YOUTUBE_TEST="https://www.youtube.com/red"
CHATGPT_TEST="https://chat.openai.com/cdn-cgi/trace"
HBOMAX_TEST="https://www.max.com/"
HULU_TEST="https://www.hulu.com/"
PRIME_TEST="https://www.primevideo.com/"

# 获取公网 IP
public_ipv4=$(curl -s --max-time 5 https://api.ipify.org)
public_ipv6=$(curl -6 -s --max-time 5 https://api64.ipify.org)

ip_list=""
[ -n "$public_ipv6" ] && ip_list="$ip_list $public_ipv6"
[ -n "$public_ipv4" ] && ip_list="$ip_list $public_ipv4"

if [ -z "$ip_list" ]; then
    echo -e "${RED}未检测到公网 IPv4/IPv6，无法进行解锁检测！${NC}"
    exit 1
fi

echo -e "${YELLOW}========== 本机 IPv4 + IPv6 多平台解锁检测 ==========${NC}"
echo "检测到公网 IP：$ip_list"

# 列宽设置
TYPE_WIDTH=6
IP_WIDTH=36
COL_WIDTH=9

# 居中输出函数
center_text() {
    local text="$1"
    local width=$2
    local len=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g' | wc -m)
    local padding=$(( (width - len) / 2 ))
    [ $padding -lt 0 ] && padding=0
    local pad_left=$(printf "%*s" $padding "")
    local pad_right=$(printf "%*s" $((width - len - padding)) "")
    echo -n "${pad_left}${text}${pad_right}"
}

# 表头
cols=("Netflix" "Disney+" "YouTube" "ChatGPT" "HBO" "Hulu" "Prime")

# 打印表头
center_text "类型" $TYPE_WIDTH; echo -n " "
center_text "IP地址" $IP_WIDTH; echo -n " "
for col in "${cols[@]}"; do
    center_text "$col" $COL_WIDTH
    echo -n " "
done
echo

# 分隔线长度
total_width=$((TYPE_WIDTH + IP_WIDTH + COL_WIDTH * ${#cols[@]} + ${#cols[@]}))
printf "%0.s=" $(seq 1 $total_width)
echo

# 检测函数
check_ip() {
    local ip=$1
    local proto
    [[ "$ip" == *:* ]] && proto="IPv6" || proto="IPv4"

    local nf ds yt cg hb hl pr

    # Netflix
    nf_code1=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$NETFLIX_ORIGINAL")
    nf_code2=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$NETFLIX_MOVIE")
    if [ "$nf_code1" = "200" ] && [ "$nf_code2" = "200" ]; then nf="${GREEN}完整${NC}"
    elif [ "$nf_code1" = "200" ]; then nf="${YELLOW}自制${NC}"
    else nf="${RED}不可${NC}"; fi

    # Disney+
    ds_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$DISNEY_TEST")
    if [ "$ds_code" = "200" ]; then ds="${GREEN}可访问${NC}"
    elif [ "$ds_code" = "403" ]; then ds="${RED}封锁${NC}"
    else ds="${YELLOW}异常${NC}"; fi

    # YouTube
    yt_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$YOUTUBE_TEST")
    if [ "$yt_code" = "200" ]; then yt="${GREEN}可访问${NC}"
    elif [ "$yt_code" = "403" ]; then yt="${RED}封锁${NC}"
    else yt="${YELLOW}异常${NC}"; fi

    # ChatGPT
    cg_res=$(curl --interface $ip -s --max-time 8 "$CHATGPT_TEST" 2>/dev/null | grep "loc=" | cut -d= -f2)
    if [ -n "$cg_res" ]; then cg="${GREEN}${cg_res}${NC}"; else cg="${RED}不可${NC}"; fi

    # HBO Max
    hb_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$HBOMAX_TEST")
    if [ "$hb_code" = "200" ]; then hb="${GREEN}可访问${NC}"
    elif [ "$hb_code" = "403" ]; then hb="${RED}封锁${NC}"
    else hb="${YELLOW}异常${NC}"; fi

    # Hulu
    hl_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$HULU_TEST")
    if [ "$hl_code" = "200" ]; then hl="${GREEN}可访问${NC}"
    elif [ "$hl_code" = "403" ]; then hl="${RED}封锁${NC}"
    else hl="${YELLOW}异常${NC}"; fi

    # Prime Video
    pr_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$PRIME_TEST")
    if [ "$pr_code" = "200" ]; then pr="${GREEN}可访问${NC}"
    elif [ "$pr_code" = "403" ]; then pr="${RED}封锁${NC}"
    else pr="${YELLOW}异常${NC}"; fi

    # 输出表格
    center_text "$proto" $TYPE_WIDTH; echo -n " "
    center_text "$ip" $IP_WIDTH; echo -n " "
    for result in "$nf" "$ds" "$yt" "$cg" "$hb" "$hl" "$pr"; do
        center_text "$result" $COL_WIDTH
        echo -n " "
    done
    echo
}

# 遍历 IP 检测
for ip in $ip_list; do
    check_ip "$ip"
done

echo -e "\n${YELLOW}========== 检测完成 ==========${NC}"
