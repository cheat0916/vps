#!/bin/bash
###
# IPv4 + IPv6 多平台解锁检测（公网 IP + 彩色整齐表格）
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
    nf_code1=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$NETFLIX_ORIGINAL")
    nf_code2=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$NETFLIX_MOVIE")
    if [ "$nf_code1" = "200" ] && [ "$nf_code2" = "200" ]; then nf="完整解锁"
    elif [ "$nf_code1" = "200" ]; then nf="仅自制剧"
    else nf="不可用"; fi

    # Disney+
    ds_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$DISNEY_TEST")
    if [ "$ds_code" = "200" ]; then ds="可访问"
    elif [ "$ds_code" = "403" ]; then ds="被封锁"
    else ds="异常($ds_code)"; fi

    # YouTube
    yt_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$YOUTUBE_TEST")
    if [ "$yt_code" = "200" ]; then yt="可访问"
    elif [ "$yt_code" = "403" ]; then yt="被封锁"
    else yt="异常($yt_code)"; fi

    # ChatGPT
    cg_res=$(curl --interface "$ip" -s --max-time 8 "$CHATGPT_TEST" 2>/dev/null | grep "loc=" | cut -d= -f2)
    if [ -n "$cg_res" ]; then cg="可用($cg_res)"; else cg="不可用"; fi

    # HBO Max
    hb_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$HBOMAX_TEST")
    if [ "$hb_code" = "200" ]; then hb="可访问"
    elif [ "$hb_code" = "403" ]; then hb="被封锁"
    else hb="异常($hb_code)"; fi

    # Hulu
    hl_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$HULU_TEST")
    if [ "$hl_code" = "200" ]; then hl="可访问"
    elif [ "$hl_code" = "403" ]; then hl="被封锁"
    else hl="异常($hl_code)"; fi

    # Prime Video
    pr_code=$(curl --interface "$ip" -s -o /dev/null -m 8 -w "%{http_code}" "$PRIME_TEST")
    if [ "$pr_code" = "200" ]; then pr="可访问"
    elif [ "$pr_code" = "403" ]; then pr="被封锁"
    else pr="异常($pr_code)"; fi

    # 输出表格行（先去掉颜色）
    echo "$proto|$ip|$nf|$ds|$yt|$cg|$hb|$hl|$pr"
}

# 输出表头
echo "类型|IP地址|Netflix|Disney+|YouTube|ChatGPT|HBO Max|Hulu|Prime Video"
echo "$(printf '=%.0s' {1..120})"

# 检测结果收集
results=""
for ip in $ip_list; do
    results="$results
$(check_ip "$ip")"
done

# 用 column 对齐
echo "$results" | column -t -s "|"

# 彩色显示
colorize() {
    sed -e "s/完整解锁/${GREEN}完整解锁${NC}/g" \
        -e "s/仅自制剧/${YELLOW}仅自制剧${NC}/g" \
        -e "s/不可用/${RED}不可用${NC}/g" \
        -e "s/可访问/${GREEN}可访问${NC}/g" \
        -e "s/被封锁/${RED}被封锁${NC}/g" \
        -e "s/异常(*/${YELLOW}&${NC}/g" \
        -e "s/可用(/${GREEN}&${NC}/g"
}

echo "$results" | column -t -s "|" | colorize

echo -e "\n${YELLOW}========== 检测完成 ==========${NC}"
