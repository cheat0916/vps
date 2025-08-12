# VPS Initialization Script

> 一款专业且多语言支持的 VPS 初始化工具，集成主机信息展示、软件源配置、swap 管理、Warp 安装、性能测试及磁盘清理等多功能模块。  
> 适用于 Debian/Ubuntu 系统，方便快速初始化与维护 VPS 环境。

---

## 功能亮点

- 🎨 多语言支持：简体中文、繁体中文、英文  
- ⚙️ 模块化设计：支持按需加载并自动更新各功能模块  
- 🖥️ 主机信息展示：系统版本、内核版本、CPU、内存、磁盘空间一目了然  
- 📦 官方软件源配置：自动检测系统类型，配置并更新官方软件源  
- 💾 Swap 管理：智能检测内核支持，创建/删除 swap 文件  
- 🌐 Warp 安装：快速安装和管理 Cloudflare Warp  
- ⚡ 性能测试：网络和硬件性能快速评估  
- 🧹 磁盘垃圾清理：清理系统日志、旧内核、缓存及临时文件，释放磁盘空间  
- 🔄 自动模块更新：运行时自动检测缺失模块并下载安装，确保始终使用最新版本

---

## 目录结构

vps/
  menu.sh           # 主菜单脚本
  modules/
    hosts.sh
    repos.sh
    swap.sh
    warp.sh
    perf_test.sh
    cleanup.sh

---

## 快速开始

1. 下载并运行主菜单脚本：

wget -N https://raw.githubusercontent.com/cheat0916/vps/main/menu.sh && bash menu.sh

2. 选择语言并进入主菜单  
3. 根据提示选择需要执行的功能模块

---

## 使用示例

请输入选项数字： 6  
开始清理无用日志和垃圾文件...  
清理 systemd journal 日志...  
清理 apt 缓存和自动删除无用依赖包...  
清理旧内核...  
清理用户缓存目录...  
清理临时文件夹...  

清理完成。磁盘空间情况：  
清理前： 2.9G / 7.9G  
清理后： 2.6G / 7.9G  
Filesystem         Size  Used Avail Use% Mounted on  
/dev/ploop40393p1  7.9G  2.6G  5.0G  34% /  
建议定期检查系统磁盘使用情况，避免空间不足导致服务异常。

---

## 模块说明

模块名       | 功能描述                   
-------------|------------------------------
hosts        | 在 /etc/hosts 添加当前主机名  
repos        | 添加并更新官方软件源          
swap         | 创建和管理 swap 文件          
warp         | 安装和管理 Cloudflare Warp    
perf_test    | 性能测试工具                  
cleanup      | 清理系统日志和垃圾文件        

---

## 依赖要求

- Bash 4.3+  
- curl  
- wget  
- lsb_release  
- grep  
- awk  

脚本会自动检测并尝试安装缺失依赖。

---

## 版本更新策略

- 主菜单脚本运行时自动检测缺失模块并下载最新版本  
- 用户也可手动执行更新脚本同步模块代码  

---

## 贡献指南

欢迎提出 issues 或 pull requests，帮助完善本项目。  
请确保代码风格一致，提交前通过测试。

---

## 许可协议

MIT License © Cheat

---

## 联系方式

- GitHub: https://github.com/cheat0916/vps  
- 邮箱: your-email@example.com （可选）

---

感谢使用！祝你 VPS 管理更轻松高效！
