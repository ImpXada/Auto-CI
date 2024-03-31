# Auto-CI

<p align="center">
<a href="./README_CN.md">简体中文</a> | <a href="./README.md">English</a>
</p>

## Project Introduction

This is an automated CI project for suyu, sudachi, strato and mesa turnip.

## Release Notes

1. Suyu Android version is automatically generated daily at 00:00:00 (UTC).
2. Suyu Windows version is automatically generated every 2 days at 00:00:00 (UTC).
3. Suyu Linux version is automatically generated every 2 days at 00:00:00 (UTC).
4. Mesa Turnip Android version is automatically generated daily at 00:00:00 (UTC).
5. Sudachi Android version is automatically generated every 3 days at 00:00:00 (UTC).
6. Strato Android version is automatically generated on the 1st of every month at 00:00:00 (UTC).
7. Naming format: "Project Name - Date - Tag - Branch". (Tag depends on the developer, a decrease in version number does not indicate a backward release version)
8. Release frequency may be adjusted based on project code commit frequency.

## Driver Usage Instructions

Download--Open the emulator--Settings in the lower right corner--GPU Driver Manager--Install--Select the downloaded zip package

## Download

[Every day Release](https://github.com/ImpXada/Auto-CI/releases)
The daily release includes all projects that underwent CI execution on that day.

[Suyu Android](https://github.com/ImpXada/Auto-CI/releases/tag/suyu-android)

[Suyu Windows](https://github.com/ImpXada/Auto-CI/releases/tag/suyu-windows)

[Suyu Linux](https://github.com/ImpXada/Auto-CI/releases/tag/suyu-linux)

[Turnip Android](https://github.com/ImpXada/Auto-CI/releases/tag/mesa-turnip-android)

[Sudachi Android](https://github.com/ImpXada/Auto-CI/releases/tag/sudachi-android)

[Strato Android](https://github.com/ImpXada/Auto-CI/releases/tag/strato-android)

## Project Source Code

1. [Suyu](https://git.suyu.dev/suyu/suyu)
2. [Turnip](https://gitlab.freedesktop.org/mesa/mesa)
3. [Sudachi](https://github.com/sudachi-emu/sudachi)
4. [Strato](https://github.com/strato-emu/strato)