# Open Watcom template project

This project aims to keep a simple project folder for Watcom C/C++ so that programmers can focus more on their code in a more modern environment than the IDE provided in Watcom.

## Introduction

This project contains a number of files designed to simplify the workflow when working with C and C++ for Watcom.
The `build.ps1` file takes all source files in the `src` directory and compiles and links them.
`watcom-vscode.code-workspace` is the default project settings, which adds `build.ps1` to the Build Task in vscode (default: ctrl+shift+B).
The `.vscode` directory contains some default settings for C and C++. It will assume C89 and C++98, as those are (at best) what the Watcom C and C++ compilers support.
This file also contains the default Watcom directory for the includes, so if another platform than windows is to be supported, it needs to be updated here as well.
A define for `far` is added here as well to remove annoying vscode squiggles under the `far` keywords.

## Caveats

- Currently only Windows
- Only designed for simple projects

## Requirements

- [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- [Visual Studio Code](https://code.visualstudio.com/Download)
- [Open Watcom](http://www.openwatcom.org/download.php)
- [DOSBox](https://www.dosbox.com/download.php?main=1) or other platform emulator capable of DOS PC/*T and 8088 / x86 emulation