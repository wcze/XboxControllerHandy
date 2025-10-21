# XboxControllerHandy（Xbox手柄操作工具）

本项目通过 Xbox 手柄实现对 Windows 系统的操作，可替代鼠标和部分键盘功能。支持模块化管理，便于修改和扩展。

> **注意**：本项目使用 **AutoHotkey v1.1** 编写，如果使用 AHK v2，请不要直接运行。

## 功能概览

* **左摇杆**：平滑移动鼠标
* **右摇杆**：分段滚动屏幕，推动幅度越大滚动越快
* **D-Pad**：映射方向键，上下左右按住后支持延迟触发和自动重复
* **A / B 按键**：鼠标左键 / 右键（按下触发一次）
* **RB / LB**：切换 Tab（RB = Tab，LB = Shift+Tab）
* **RT / LT**：半屏滚动（PgUp / PgDn）
* **X / Y 按键**：已定义，预留扩展功能

## 项目结构

```
XboxControllerHandy/
│
├─ main.js                 # Node.js 脚本，组合各模块生成 AHK
├─ release/                # 可运行的 exe 文件
├─ ahk/                    # 各功能模块 AHK 文件
│   ├─ header.ahk
│   ├─ config.ahk
│   ├─ xinputLoad.ahk
│   ├─ mainLoopStart.ahk
│   ├─ mouseControl.ahk
│   ├─ scrollControl.ahk
│   ├─ triggers.ahk
│   ├─ tabSwitch.ahk
│   ├─ dpadControl.ahk
│   ├─ mouseButtons.ahk
│   └─ mainLoopEnd.ahk
└─ output/                 # 最终生成的 XboxControllerHandy.ahk
```

## 使用方法

1. 下载 `release/` 文件夹中的可执行文件（`XboxControllerHandy.exe`）。
2. 连接 Xbox 手柄。
3. 双击运行程序即可开始使用。

**开发者：**

1. 安装 [Node.js](https://nodejs.org/)
2. 克隆或下载项目源代码
3. 将手柄连接到电脑
4. 在项目目录运行：

```bash
node main.js
```

5. 脚本会生成 `output/XboxControllerHandy.ahk`
6. 双击运行生成的 AHK 脚本即可使用

---

## 打包成 EXE

使用 **AutoHotkey v1.1** 自带的 **Ahk2Exe.exe** 可以将 `.ahk` 脚本打包为 EXE。在项目根目录下执行：

```cmd
cmd /c "{PATH}\Compiler\Ahk2Exe.exe /in .\output\XboxControllerHandy.ahk /out .\release\XboxControllerHandy.exe"
```

* `/in` 指定源脚本
* `/out` 指定输出 EXE 路径
* 如果 `release` 文件夹不存在，先创建：
* `{PATH}` 请替换为 AutoHotKey 的真实路径
---

## 配置参数

可在 `ahk/config.ahk` 中修改：

* `PollInterval`：手柄轮询间隔（ms）
* `LeftDeadzone` / `RightDeadzone`：摇杆死区阈值
* `MaxMovePerPoll`：鼠标每轮最大移动距离
* `ScrollScale`：右摇杆滚动灵敏度
* `InitialDelay` / `RepeatInterval`：D-Pad 按住自动重复的延迟和间隔

## 开发扩展

* 每个功能模块都是独立 `.ahk` 文件，方便单独修改
* 新增功能只需在 `ahk/` 下添加文件，并在 `main.js` 的 `modulesOrder` 中注册即可
* 生成的 `XboxControllerHandy.ahk` 可通过 AutoHotkey Compiler 打包为 EXE 放入 `release/` 目录
