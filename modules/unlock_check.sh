#!/bin/bash
###
# IPv4 + IPv6 多平台解锁检测（公网 IP + 彩色表格）
# 作者：ChatGPT
# 依赖：curl, awk, grep
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
public_ipv4=$(curl -s https://api.ipify.org)
public_ipv6=$(curl -6 -s https://api64.ipify.org)

ip_list=""
[ -n "$public_ipv6" ] && ip_list="$ip_list $public_ipv6"
[ -n "$public_ipv4" ] && ip_list="$ip_list $public_ipv4"

if [ -z "$ip_list" ]; 键，然后
    echo -e "${RED}未检测到公网 IP，无法进行解锁检测！${NC}"
    exit 1
fi

echo -e "${YELLOW}========== 本机 IPv4 + IPv6 多平台解锁检测 ==========${NC}"
echo "检测到公网 IP："
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

    # 输出表格行（去掉颜色用于 column 对齐）
    nf_plain=$(echo -e "$nf" | sed 's/\x1b\[[0-9;]*m//g')
    ds_plain=$(echo -e "$ds" | sed 's/\x1b\[[0-9;]*m//g')
    yt_plain=$(echo -e "$yt" | sed 's/\x1b\[[0-9;]*m//g')
    cg_plain=$(echo -e "$cg" | sed 's/\x1b\[[0-9;]*m//g')
    hb_plain=$(echo -e "$hb" | sed 's/\x1b\[[0-9;]*m//g')
    hl_plain=$(echo -e "$hl" | sed 's/\x1b\[[0-9;]*m//g')
    pr_plain=$(echo -e "$pr" | sed 's/\x1b\[[0-9;]*m//g')

    echo "$proto|$ip|$nf_plain|$ds_plain|$yt_plain|$cg_plain|$hb_plain|$hl_plain|$pr_plain"
}

# 输出表头（不带颜色，用 column 对齐）
echo "类型|IP地址|Netflix|Disney+|YouTube|ChatGPT|HBO Max|Hulu|Prime Video"
echo "$(printf '=%.0s' {1..120})"

# 并行检测每个 IP
results=""
for ip in $ip_list; do
    results="$results
$(check_ip "$ip")"
done

# 使用 column 对齐输出
echo "$results" | column -t -s "|"

echo -e "\n${YELLOW}========== 检测完成 ==========${NC}"
