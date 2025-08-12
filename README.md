# VPS Initialization Script

![VPS Init Logo](https://raw.githubusercontent.com/cheat0916/vps/main/logo.png)



# VPS Initialization Script

██████   ██████   ██████  
██   ██  ██   ██  ██   ██ 
██   ██  ██   ██  ██   ██ 
██████   ██████   ██████  
                          
A professional, multilingual VPS initialization and maintenance tool.  
Supports Debian/Ubuntu systems, helping you quickly configure and maintain your VPS with ease.

---

## 📁 目录结构

vps/  
├── menu.sh           # 主菜单脚本（入口）  
└── modules/          # 功能模块目录  
 ├── hosts.sh         # hosts 管理  
 ├── repos.sh         # 软件源管理  
 ├── swap.sh          # swap 管理  
 ├── warp.sh          # Warp 安装  
 ├── perf_test.sh     # 性能测试  
 └── cleanup.sh       # 垃圾文件清理  

---

## ✨ 功能特性

- 🎨 **多语言支持**：简体中文、繁体中文、英文  
- ⚙️ **模块化设计**：支持按需加载并自动更新各功能模块  
- 🖥️ **主机信息展示**：系统版本、内核版本、CPU、内存、磁盘空间一目了然  
- 📦 **官方软件源配置**：自动检测系统类型，配置并更新官方软件源  
- 💾 **Swap 管理**：智能检测内核支持，创建/删除 swap 文件  
- 🌐 **Warp 安装**：快速安装和管理 Cloudflare Warp  
- ⚡ **性能测试**：网络和硬件性能快速评估  
- 🧹 **磁盘垃圾清理**：清理系统日志、旧内核、缓存及临时文件，释放磁盘空间  
- 🔄 **自动模块更新**：运行时自动检测缺失模块并下载安装，确保始终使用最新版本

---

## 🚀 快速开始

使用以下命令即可一键下载并运行：

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/cheat0916/vps/main/menu.sh)"
```

或者

```bash
curl -fsSL https://raw.githubusercontent.com/cheat0916/vps/main/menu.sh | bash
```

> **小提示**  
> - 支持复制粘贴，简单方便  
> - 脚本首次运行时选择语言，进入主菜单  

---

## 🖥 使用示例

运行脚本后界面示例：

欢迎使用VPS初始化脚本

------ 当前主机信息 ------  
系统版本: Ubuntu 20.04.6 LTS  
内核版本: 5.4.0-42-generic  
架构: x86_64  
CPU: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz  
内存总量: 4.0G  
磁盘空间: 80G 总，共用: 20G  
--------------------------

1. 在hosts中添加当前hostname  
2. 添加官方软件源  
3. swap管理  
4. 安装Warp  
5. 性能测试  
6. 磁盘及垃圾文件清理  
7. 退出  

请输入选项数字：

---

## 🔧 依赖环境

- Bash 4.3+  
- curl  
- wget  
- lsb_release  
- grep  
- awk  

脚本会自动检测并尝试安装缺失依赖。

---

## 🔄 更新机制

- 模块化结构，运行时自动下载和更新缺失或新版本模块  
- 建议定期运行脚本以保持功能最新  

---

## 🤝 贡献与反馈

欢迎提出 Issues 或 Pull Requests！  
请确保代码简洁、规范并经过测试。  

---

## 📄 许可证

MIT License © Cheat

---

## 📬 联系方式

GitHub: https://github.com/cheat0916/vps  


---

感谢您的使用，祝您 VPS 管理顺利！

