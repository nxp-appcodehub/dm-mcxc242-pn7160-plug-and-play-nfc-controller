# NXP Application Code Hub
[<img src="https://mcuxpresso.nxp.com/static/icon/nxp-logo-color.svg" width="100"/>](https://www.nxp.com)

[English](README.md)

## 基于 PN7160 的 FRDM-MCXC242 NFC 控制器使能
*本示例展示 FRDM-MCXC242 开发板通过 NXP-NCI 2.0 中间件与 PN7160 NFC 控制器进行接口连接。*

1. RWandCE - 读写器加 Type 4 Tag 卡模拟模式
2. RW      - 读写器模式
3. P2P     - 点对点模式

![Block_diagram](images/Block_diagram.png)

[概述]

- MCU 开发板：搭载 NXP MCXC242 的 FRDM-MCXC242。
- NFC 控制器：PN7160。
- 主机接口：I2C1，100 kHz，7 位地址 0x28。
- PN7160 控制引脚：
  - SCL：PTD7，I2C1 SCL
  - SDA：PTD6，I2C1 SDA
  - IRQ：PTE31，高电平有效的数据就绪中断输入
  - VEN：PTC8，PN7160 使能/复位输出
  - REQ：PTC9，保持低电平以进入普通 NCI 启动模式
- 调试控制台：开发板调试 UART，115200 8n1。

[特性]
- MCU：FRDM-MCXC242 上的 NXP MCXC242。
- NFC 控制器：PN7160。
- 主机接口：I2C1，7 位地址 `0x28`，100 kHz。
- NFC 示例：可从串口控制台选择 RWandCE、RW 和 P2P。
- RWandCE 模式：从 NFC 标签读取 NDEF 数据，并向外部 NFC 读卡器提供一个简单的 Type 4 Tag NDEF 消息。
- 读写器模式：检测 NFC 标签，并针对支持的协议运行读卡场景。
- P2P 模式：与远程 NFC 对等设备交换示例 NDEF 消息。
- 通过开发板调试 UART 输出调试控制台信息。

#### 开发板：[FRDM-MCXC242](https://www.nxp.com/design/design-center/development-boards-and-designs/FRDM-MCXC242)、[OM27160](https://www.nxp.com/design/design-center/development-boards-and-designs/PN7160-EVK)
#### 类别：工业、用户界面
#### 外设：GPIO、I2C、UART
#### 工具链：VS Code

## 目录
1. [软件](#step1)
2. [硬件](#step2)
3. [设置](#step3)
4. [结果](#step4)
5. [Release Notes](#step5)

## 1. 软件<a name="step1"></a>
- [MCUXpresso for Visual Studio Code](https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/mcuxpresso-for-visual-studio-code:MCUXPRESSO-VSC)
- [SDK_26.06.0_FRDM-MCXC242](https://mcuxpresso.nxp.com/en/welcome)
- MCUXpresso for Visual Studio Code：本示例支持 MCUXpresso for Visual Studio Code。关于如何使用 Visual Studio Code 的更多信息，请参阅[此处](https://www.nxp.com/design/training/getting-started-with-mcuxpresso-for-visual-studio-code:TIP-GETTING-STARTED-WITH-MCUXPRESSO-FOR-VS-CODE)。

## 2. 硬件<a name="step2"></a>
- 1 根 Type-C USB 线缆
- 1 块 OM27160 开发板
- 1 块 FRDM-MCXC242 开发板：

![FRDM-MCXC242](images/FRDM-MCXC242.png)

## 3. 设置<a name="step3"></a>

### 3.1 硬件连接
*按照下图所示，通过 FRDM 接口将 FRDM-MCXC242 连接到 OM27160。*

![Hardware_connection](images/Hardware_connection_guide.png)

![FRDM-MCXC242 and OM27160 Hardware Photo](images/Hardware_photo.png)

### 3.2 从 SW6705 刷新 NFC 中间件

当需要从 NXP SW6705 重新同步 NFC 中间件和示例源码时，在项目根目录运行以下命令：

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\scripts\apply-sw6705-nfc.ps1
```

脚本会先要求确认同意 NFC Infrastructure Software License and Distribution Agreement。输入 `APPROVE` 后才会继续；如果未同意该许可，脚本会直接退出，不会下载 SW6705、复制文件或应用 patch。

非交互场景可传入显式确认参数：

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\scripts\apply-sw6705-nfc.ps1 -AcceptNfcInfrastructureLicense
```

确认后，脚本会下载 `https://www.nxp.com/downloads/en/software/SW6705.zip`，将映射的 NFC 源文件复制到本工程，并应用 `scripts/sw6705-mcxc242-local.patch` 中的 MCXC242/PN7160 本地适配补丁。该 patch 文件本身也包含许可提示，只能在同意 NFC Infrastructure Software License and Distribution Agreement 后应用。

### 3.3 下载 MCXC242 固件

1. 从 Visual Studio Code Marketplace 安装 MCUXpresso for VS Code。

2. 使用 Type-C USB 线缆将板载 MCU-Link 接口（J9）连接到 PC 的 USB 端口。
   
3. 打开 Visual Studio Code，并确认已安装目标 MCU 的 SDK 包。如果尚未安装，请安装或导入所需的 SDK 包。

4. 打开 Visual Studio Code，在 Quick Start Panel 中选择 **Import from Application Code Hub**。

5. 在 **Search...** 搜索栏中输入 **demo name**。

6. 配置项目 **Name** 和项目路径 **Location**，点击 **Import Project(s)**，VS Code 将自动下载项目。

> 在导入项目之前，用户必须在 MCUXpresso for Visual Studio Code 中安装 [SDK_26.06.00_FRDM-MCXC242](https://mcuxpresso.nxp.com/en/welcome)。
> 
7. 点击 **Build Project** 编译本项目，然后点击 **Debug** 将程序下载到 FRDM-MCXC242 开发板。

### 3.4 测试 PN7160 功能

1. 通过 J9 将 FRDM-MCXC242 的 MCU-Link 连接到 PC，打开串口终端，选择正确的虚拟 COM（VCOM）端口，并设置为 115200 8n1。
2. 按下 FRDM-MCXC242 上的 SW1 复位按钮，启动 PN7160 演示应用程序。
3. 复位后，调试 UART 会打印模式选择器：

```text
Select NFC application task:
  1 / rwandce - Reader/Writer + Card Emulation mode
  2 / rw      - Reader/Writer mode
  3 / p2p     - P2P mode
>
```

输入一个支持的命令并按 Enter：

| 命令 | 模式 |
| --- | --- |
| `1`、`rwandce` 或 `rwce` | 读写器加卡模拟模式 |
| `2` 或 `rw` | 读写器模式 |
| `3` 或 `p2p` | P2P 模式 |

随后将初始化所选模式，并进入其 NFC 发现循环。复位开发板可返回选择器并选择其他模式。

## 4. 结果<a name="step4"></a>
终端输出如下图所示。

![terminal information](images/terminal_result_display.png)

#### Project Metadata

<!----- Boards ----->
[![Board badge](https://img.shields.io/badge/Board-FRDM&ndash;MCXC242-blue)]()

<!----- Categories ----->
[![Category badge](https://img.shields.io/badge/Category-INDUSTRIAL-yellowgreen)](https://mcuxpresso.nxp.com/appcodehub?category=industrial)
[![Category badge](https://img.shields.io/badge/Category-USER%20INTERFACE-yellowgreen)](https://mcuxpresso.nxp.com/appcodehub?category=ui)

<!----- Peripherals ----->
[![Peripheral badge](https://img.shields.io/badge/Peripheral-GPIO-yellow)](https://mcuxpresso.nxp.com/appcodehub?peripheral=gpio)
[![Peripheral badge](https://img.shields.io/badge/Peripheral-I2C-yellow)](https://mcuxpresso.nxp.com/appcodehub?peripheral=i2c)
[![Peripheral badge](https://img.shields.io/badge/Peripheral-UART-yellow)](https://mcuxpresso.nxp.com/appcodehub?peripheral=uart)

<!----- Toolchains ----->
[![Toolchain badge](https://img.shields.io/badge/Toolchain-VS%20CODE-orange)](https://mcuxpresso.nxp.com/appcodehub?toolchain=vscode)

关于本示例内容或正确性的问题，可以在此 GitHub 仓库中以 Issue 形式提交。

>**警告**：对于有关 NXP 微控制器以及预期功能差异的更通用技术问题，请在 [NXP Community Forum](https://community.nxp.com/) 上提交问题。

[![Follow us on Youtube](https://img.shields.io/badge/Youtube-Follow%20us%20on%20Youtube-red.svg)](https://www.youtube.com/NXP_Semiconductors)
[![Follow us on LinkedIn](https://img.shields.io/badge/LinkedIn-Follow%20us%20on%20LinkedIn-blue.svg)](https://www.linkedin.com/company/nxp-semiconductors)
[![Follow us on Facebook](https://img.shields.io/badge/Facebook-Follow%20us%20on%20Facebook-blue.svg)](https://www.facebook.com/nxpsemi/)
[![Follow us on Twitter](https://img.shields.io/badge/X-Follow%20us%20on%20X-black.svg)](https://x.com/NXP)

## 5. Release Notes<a name="step5"></a>
| Version | Description / Update                           | Date                        |
|:-------:|------------------------------------------------|----------------------------:|
| 1.0     | Initial release on Application Code Hub        | July 31<sup>th</sup> 2026 |

<small> <b>Trademarks and Service Marks</b>: There are a number of proprietary logos, service marks, trademarks, slogans and product designations ("Marks") found on this Site. By making the Marks available on this Site, NXP is not granting you a license to use them in any fashion. Access to this Site does not confer upon you any license to the Marks under any of NXP or any third party's intellectual property rights. While NXP encourages others to link to our URL, no NXP trademark or service mark may be used as a hyperlink without NXP’s prior written permission. The following Marks are the property of NXP. This list is not comprehensive; the absence of a Mark from the list does not constitute a waiver of intellectual property rights established by NXP in a Mark. </small> <br> <small> NXP, the NXP logo, NXP SECURE CONNECTIONS FOR A SMARTER WORLD, Airfast, Altivec, ByLink, CodeWarrior, ColdFire, ColdFire+, CoolFlux, CoolFlux DSP, DESFire, EdgeLock, EdgeScale, EdgeVerse, elQ, Embrace, Freescale, GreenChip, HITAG, ICODE and I-CODE, Immersiv3D, I2C-bus logo , JCOP, Kinetis, Layerscape, MagniV, Mantis, MCCI, MIFARE, MIFARE Classic, MIFARE FleX, MIFARE4Mobile, MIFARE Plus, MIFARE Ultralight, MiGLO, MOBILEGT, NTAG, PEG, Plus X, POR, PowerQUICC, Processor Expert, QorIQ, QorIQ Qonverge, RoadLink wordmark and logo, SafeAssure, SafeAssure logo , SmartLX, SmartMX, StarCore, Symphony, Tower, TriMedia, Trimension, UCODE, VortiQa, Vybrid are trademarks of NXP B.V. All other product or service names are the property of their respective owners. © 2021 NXP B.V. </small>
