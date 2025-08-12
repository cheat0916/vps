# VPS Initialization Script

![VPS Init Logo](https://raw.githubusercontent.com/cheat0916/vps/main/logo.png)

> 一个专业、多语言支持的VPS初始化和维护工具，集成主机信息展示、软件源管理、Swap控制、Warp安装、性能测试和系统垃圾清理等多功能模块。  
> 适用于 Debian/Ubuntu 系统，帮助你轻松快速完成VPS初始化配置。

---

## 目录结构

vps/
├── menu.sh           # 主菜单脚本，入口
└── modules/          # 功能模块目录
    ├── hosts.sh
    ├── repos.sh
    ├── swap.sh
    ├── warp.sh
    ├── perf_test.sh
    └── cleanup.sh

---

## 功能特性

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

## 快速开始

你可以使用下面的命令一键下载并运行主菜单脚本：

bash -c "$(wget -qO- https://raw.githubusercontent.com/cheat0916/vps/main/menu.sh)"

或者：

curl -fsSL https://raw.githubusercontent.com/cheat0916/vps/main/menu.sh | bash

> **提示：**  
> - 以上两种方式都能保证脚本直接执行且支持复制粘贴  
> - 脚本运行后，会提示选择语言并显示主菜单，按照提示操作即可

---

## 使用示例

选择语言后，菜单界面如下：

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

## 依赖环境

- Bash 4.3及以上  
- curl  
- wget  
- lsb_release  
- grep  
- awk  

脚本会自动检测并安装缺失依赖。

---

## 更新说明

- 脚本设计为模块化结构，运行时自动下载或更新缺失模块，确保使用最新功能  
- 推荐定期运行脚本，保持模块更新

---

## 贡献与反馈

欢迎提交 Issue 或 Pull Request，帮助完善本项目。  
请确保代码风格规范，功能稳定。

---

## 许可证

MIT License © Cheat

---

## 联系方式

- GitHub: https://github.com/cheat0916/vps  

---

感谢使用，祝你 VPS 管理轻松高效！
