# qBreakpad 预编译库说明

本目录按 **平台 / 架构** 组织 qBreakpad 静态库。`qbreakpadtest.pro` 会根据 `QT_ARCH` 自动选择对应的子目录链接，无需手改 .pro。

## 目录结构

```
lib/
├── windows/
│   ├── x86/           Windows 32-bit (MSVC)
│   │   ├── release/
│   │   └── debug/
│   └── x64/           Windows 64-bit (MSVC)
│       ├── release/
│       └── debug/
├── mac/
│   ├── x86_64/        macOS Intel
│   └── arm64/         macOS Apple Silicon (M1/M2/M3...)
└── linux/
    ├── x86_64/        Linux 64-bit Intel/AMD
    └── arm64/         Linux 64-bit ARM (aarch64)
```

每个叶子目录里都放一份 `libqBreakpad.a`（macOS / Linux）或 `qBreakpad.lib` (+ `.pdb` for debug)（Windows）。空目录用 `.gitkeep` 占位，方便以后补编。

## 当前已有库的构建信息

> 约定：**每个架构目录只放一份库**（不同时维护多个 Qt 版本）。如果未来要换 Qt 版本，直接覆盖即可，并同步更新本文档。

| 目录 | 架构 | 编译器 | Qt 版本 | Deployment Target | 构建日期 | 备注 |
|---|---|---|---|---|---|---|
| `windows/x86/release/` | PE 32-bit i386 | MSVC 2017 (14.16.27023) | Qt 5.15 (msvc2019 kit) | — | 历史构建 | 运行库 `MD`（动态 Release） |
| `windows/x86/debug/` | PE 32-bit i386 | MSVC 2017 (14.16.27023) | Qt 5.15 (msvc2019 kit) | — | 历史构建 | 运行库 `MDd`（动态 Debug），带 `.pdb` |
| `windows/x64/release/` | — | — | — | — | — | 待补编 |
| `windows/x64/debug/` | — | — | — | — | — | 待补编 |
| `mac/x86_64/` | Mach-O 64-bit x86_64 | Apple clang (Xcode) | Qt 5.15.2 （Qt在线安装包安装, x86 原生） | macOS 11.0 | 历史构建 | 原仓库遗留，**非 arm64** |
| `mac/arm64/` | Mach-O 64-bit arm64 | Apple clang (Xcode) | Qt 5.15.19 (Homebrew `qt@5`, arm64 原生) | macOS 11.0 | 2026-06-04 | Apple Silicon (M1/M2/M3...) 原生 |
| `linux/x86_64/` | ELF 64-bit x86-64 | GCC（gnu/linux） | _TBD_ | _TBD_ | 历史构建 | 原仓库遗留 |
| `linux/arm64/` | — | — | — | — | — | 待补编 |

## 重新编译方法

### macOS / Linux

```bash
cd <repo>/handler
make distclean 2>/dev/null
<qt-bin>/qmake QMAKE_APPLE_DEVICE_ARCHS=<arch>   # mac 用，例如 arm64 / x86_64
# 或 Linux 上：<qt-bin>/qmake
make -j$(sysctl -n hw.ncpu 2>/dev/null || nproc)

# 验证架构
lipo -info libqBreakpad.a        # mac
file libqBreakpad.a              # linux

# 拷贝到对应目录
cp libqBreakpad.a <repo>/demo/qbreakpadtest/qbreakpadlib/lib/<platform>/<arch>/
```

### Windows (MSVC)

在对应的 "x86 Native Tools Command Prompt" 或 "x64 Native Tools Command Prompt" 里：

```cmd
cd <repo>\handler
nmake distclean
<qt-bin>\qmake.exe
nmake release   :: 或 nmake debug
```

产物 `qBreakpad.lib` (+ debug 配置下的 `qBreakpad.pdb`) 拷到：
- `lib/windows/x86/release/`、`lib/windows/x86/debug/`（32-bit）
- `lib/windows/x64/release/`、`lib/windows/x64/debug/`（64-bit）

## 兼容性注意事项

1. **Qt 大版本必须匹配**：用 Qt 5.15.x 编出来的库只能给 Qt 5.15.x 的项目链接，跨大版本（Qt 5 ↔ Qt 6）必崩。
2. **Qt 小版本（5.15.x 之间）**：LTS 系列承诺 BC，理论上可互换；但安全做法仍是「谁用哪个版本就编哪个版本」。
3. **macOS deployment target**：Apple Silicon (arm64) 最低 11.0，Intel (x86_64) 可低至 10.13。混合发布时取最高门槛。
4. **Windows MSVC 运行库 (MD / MT)**：使用方工程的 `CONFIG` 必须和库一致，否则 `_ITERATOR_DEBUG_LEVEL` / `RuntimeLibrary` 不匹配会链接失败。当前历史 Windows 库使用 `MD` / `MDd`（动态 CRT）。
5. **Windows MSVC 编译器版本**：VS 2015/2017/2019/2022 同属 v14 工具集，ABI 兼容；当前历史库用 MSVC 2017 编译，可被 VS 2017/2019/2022 链接使用。

## 头文件

链接库的同时需要 include 同级 `../include/` 目录下的头文件：

- `QBreakpadHandler.h`
- `QBreakpadHttpUploader.h`
- `singletone/call_once.h`
- `singletone/singleton.h`
