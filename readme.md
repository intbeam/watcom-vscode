# Open Watcom template project

This project aims to keep a simple project folder for Watcom C/C++ so that programmers can focus more on their code in a more modern environment than the IDE provided in Watcom.

# License

[MIT](https://opensource.org/licenses/MIT)

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
- All C and C++ files in `src` will be built

## Structure

`src` : this is where you'll place your own source files  
`obj` : object files output by the Watcom compilers  
`bin` : output from the Watcom linker  
`assets` : place graphics and any related assets in this directory  
`build.ps1` : compiles and links all C/C++ files placed in src directory  

## Goals

The IDE for OpenWatcom is old and not very user friendly. This solution provides something that is supposed to work out-of-the-box for "typical" Watcom scenarios.
This was made to suit my own needs; primarily writing code for 16-bit and 32-bit DOS in a modern environment without having to deal with Watcom IDE projects.

## Future improvements

- Cross-platform
- Auto-detect Watcom installation
- Command to run with DOSBox
- Platform targets and compiler optimization flags
- Post-build actions

## How to use

In the PowerShell commandline, go to a project directory and type the following :

```powershell
Invoke-WebRequest "https://github.com/intbeam/watcom-vscode/tarball/main" -OutFile "./watcom-vscode.tar" && tar.exe -xf "./watcom-vscode.tar" && Remove-Item "./watcom-vscode.tar"
```

This should create a directory named `watcom-vscode` that you can rename to your own needs.

You can also clone the repository and then manually remove the `.git` directory.

## Requirements

- [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- [Visual Studio Code](https://code.visualstudio.com/Download)
- [Open Watcom](http://www.openwatcom.org/download.php)
- [DOSBox](https://www.dosbox.com/download.php?main=1) or other platform emulator capable of DOS PC/*T and 8088 / x86 emulation
