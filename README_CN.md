# Auto-CI

<p align="center">
<a href="./README_EN.md">English</a> | <a href="./README.md">简体中文</a>
</p>

## 项目介绍

suyu sudachi turnip mesa的自动CI项目

## 发布说明

1. 每天的00:00:00（UTC）会自动生成Suyu安卓版。
2. 每2天的00:00:00（UTC）会自动生成Suyu Windows版。
3. 每天的00:00:00（UTC）会自动生成Mesa Turnip 安卓版。
4. 每3天的00:00:00（UTC）会自动生成Sudachi安卓版。
5. 命名方式为”项目名-日期-Tag-分支“。（Tag取决于开发者，如果出现版本号下降，不代表发包版本落后）
6. 发布频率可能会根据项目代码提交频率进行调整。

## 驱动使用说明

下载--打开模拟器--右下角设置--GPU驱动管理器--安装--选择下载好的zip包

## 下载

[每日Release地址](https://github.com/ImpXada/Auto-CI/releases)
每日Release包含所有当天执行CI的项目

[Suyu Android版](https://github.com/ImpXada/Auto-CI/releases/tag/suyu-android)

[Suyu Windows版](https://github.com/ImpXada/Auto-CI/releases/tag/suyu-windows)

[Turnip Android版](https://github.com/ImpXada/Auto-CI/releases/tag/mesa-turnip-android)

[Sudachi Android版](https://github.com/ImpXada/Auto-CI/releases/tag/sudachi-android)

## 项目源码

1. [Suyu](https://git.suyu.dev/suyu/suyu)
2. [Turnip](https://gitlab.freedesktop.org/mesa/mesa)
3. [Sudachi](https://github.com/sudachi-emu/sudachi)
