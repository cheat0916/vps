#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import requests

# ========= 配置 =========
IPV6_TEST_URL = "https://api64.ipify.org"  # 获取公网IPv6
IPV4_TEST_URL = "https://api.ipify.org"    # 获取公网IPv4

# 平台检测函数（示例简化版）
def check_netflix(ip_type):
    return "完整解锁"

def check_disney(ip_type):
    return "可访问"

def check_youtube(ip_type):
    return "可访问"

def check_chatgpt(ip_type):
    return "可用(JP)"

def check_hbomax(ip_type):
    return "异常(301)"

def check_hulu(ip_type):
    return "被封锁"

def check_prime(ip_type):
    return "异常(000)"

# ========= 工具 =========
def get_public_ip(ipv6=False):
    try:
        url = IPV6_TEST_URL if ipv6 else IPV4_TEST_URL
        return requests.get(url, timeout=5).text.strip()
    except:
        return "获取失败"

def print_table(results):
    headers = ["类型", "IP地址", "Netflix", "Disney+", "YouTube", "ChatGPT", "HBO Max", "Hulu", "Prime Video"]

    # 各列宽度
    col_widths = [6, 40, 10, 10, 10, 10, 10, 10, 10]

    # 打印表头
    header_line = "".join(h.ljust(w) for h, w in zip(headers, col_widths))
    print(header_line)
    print("=" * sum(col_widths))

    # 打印每一行
    for row in results:
        line = "".join(str(val).center(w) for val, w in zip(row, col_widths))
        print(line)


# ========= 主程序 =========
def main():
    print("========== 本机 IPv4 + IPv6 多平台解锁检测 ==========")

    ipv6 = get_public_ip(ipv6=True)
    ipv4 = get_public_ip(ipv6=False)

    print("检测到公网 IP：")
    print("IPv6:", ipv6)
    print("IPv4:", ipv4)
    print("===========================================")

    results = []

    if ipv6 and ipv6 != "获取失败":
        results.append([
            "IPv6", ipv6,
            check_netflix("IPv6"), check_disney("IPv6"),
            check_youtube("IPv6"), check_chatgpt("IPv6"),
            check_hbomax("IPv6"), check_hulu("IPv6"),
            check_prime("IPv6")
        ])

    if ipv4 and ipv4 != "获取失败":
        results.append([
            "IPv4", ipv4,
            check_netflix("IPv4"), check_disney("IPv4"),
            check_youtube("IPv4"), check_chatgpt("IPv4"),
            check_hbomax("IPv4"), check_hulu("IPv4"),
            check_prime("IPv4")
        ])

    print_table(results)
    print("\n========== 检测完成 ==========")


if __name__ == "__main__":
    main()
