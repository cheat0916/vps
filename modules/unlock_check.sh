#!/bin/bash
###
# IPv4 + IPv6 多平台解锁检测模块（并行 + 彩色对齐）
# 作者：ChatGPT
# 依赖：curl, ip, awk, grep
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

# 获取 IPv6 地址（排除 link-local 和回环）
ipv6_list=$(ip -6 addr | grep inet6 | grep -v fe80 | grep -v "::1" | awk '{print $2}' | cut -d/ -f1)
# 获取 IPv4 地址（排除回环）
ipv4_list=$(ip -4 addr | grep inet | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1)

# 合并 IP
ip_list=""
[ -n "$ipv6_list" ] && ip_list="$ip_list $ipv6_list"
[ -n "$ipv4_list" ] && ip_list="$ip_list $ipv4_list"

if [ -z "$ip_list" ]; then
    echo -e "${RED}未检测到可用 IPv4/IPv6 地址！${NC}"
    exit 1
fi

echo -e "${YELLOW}========== 本机 IPv4 + IPv6 多平台解锁检测 ==========${NC}"
echo "检测到 IP 地址："
echo "$ip_list"
echo "==========================================="

# 检测函数
check_ip() {
    local ip=$1
    local proto
    [[ "$ip" == *:* ]] && proto="IPv6" || proto="IPv4"

    local nf ds yt cg hb hl pr

    # Netflix
    nf_code1=$(curl --interface $ip -s -o /dev/null -m 8 -w "%{http_code}" "$NETFLIX_ORIGINAL")
    nf_code2=$(curl --interface $ip -s -o /dev/null -m 8 -w "%{http_code}" "$NETFLIX_MOVIE")
    if [ "$nf_code1" = "200" ] && [ "$nf_code2" = "200" ]; then nf="${GREEN}完整解锁${NC}"
    elif [ "$nf_code1" = "200" ]; then nf="${YELLOW}仅自制剧${NC}"
    else nf="${RED}不可用${NC}"; fi

    # Disney+
    ds_code=$(curl --interface $ip -s -o /dev/null -m 8 -w "%{http_code}" "$DISNEY_TEST")
    if [ "$ds_code" = "200" ]; then ds="${GREEN}可访问${NC}"
    elif [ "$ds_code" = "403" ]; then ds="${RED}被封锁${NC}"
    else ds="${YELLOW}异常($ds_code)${NC}"; fi

    # YouTube
    yt_code=$(curl --interface $ip -s -o /dev/null -m 8 -w "%{http_code}" "$YOUTUBE_TEST")
    if [ "$yt_code" = "200" ]; then yt="${GREEN}可访问${NC}"
    elif [ "$yt_code" = "403" ]; then yt="${RED}被封锁${NC}"
    else yt="${YELLOW}异常($yt_code)${NC}"; fi

    # ChatGPT
    cg_res=$(curl --interface $ip -s --max-time 8 "$CHATGPT_TEST" 2>/dev/null | grep "loc=" | cut -d= -f2)
    if [ -n "$cg_res" ]; then cg="${GREEN}可用($cg_res)${NC}"; else cg="${RED}不可用${NC}"; fi

    # HBO Max
    hb_code=$(curl --interface $ip -s -o /dev/null -m 8 -w "%{http_code}" "$HBOMAX_TEST")
    if [ "$hb_code" = "200" ]; then hb="${GREEN}可访问${NC}"
    elif [ "$hb_code" = "403" ]; then hb="${RED}被封锁${NC}"
    else hb="${YELLOW}异常($hb_code)${NC}"; fi

    # Hulu
    hl_code=$(curl --interface $ip -s -o /dev/null -m 8 -w "%{http_code}" "$HULU_TEST")
    if [ "$hl_code" = "200" ]; then hl="${GREEN}可访问${NC}"
    elif [ "$hl_code" = "403" ]; then hl="${RED}被封锁${NC}"
    else hl="${YELLOW}异常($hl_code)${NC}"; fi

    # Prime Video
    pr_code=$(curl --interface $ip -s -o /dev/null -m 8 -w "%{http_code}" "$PRIME_TEST")
    if [ "$pr_code" = "200" ]; then pr="${GREEN}可访问${NC}"
    elif [ "$pr_code" = "403" ]; then pr="${RED}被封锁${NC}"
    else pr="${YELLOW}异常($pr_code)${NC}"; fi

    # 输出表格行
    printf "%-5s | %-40s | %-10s | %-8s | %-8s | %-15s | %-8s | %-8s | %-12s\n" \
        "$proto" "$ip" "$nf" "$ds" "$yt" "$cg" "$hb" "$hl" "$pr"
}

# 输出表头
printf "%-5s | %-40s | %-10s | %-8s | %-8s | %-15s | %-8s | %-8s | %-12s\n" \
"类型" "IP地址" "Netflix" "Disney+" "YouTube" "ChatGPT" "HBO Max" "Hulu" "Prime Video"
printf "%s\n" "$(printf '=%.0s' {1..135})"

# 并行检测每个 IP
for ip in $ip_list; do
    check_ip "$ip" &
done
wait

echo -e "\n${YELLOW}========== 检测完成 ==========${NC}"
