# Open Watcom template project

This project aims to keep a simple project folder for Watcom C/C++ so that programmers can focus more on their code in a more modern environment than the IDE provided in Watcom.

# License

[MIT](https://opensource.org/licenses/MIT)

## Quick update

Things I want to do :

- [ ] Figure out if there's a C Language Server that actually works with Watcom C/C++ code, without requiring recompilation
- [ ] Improve intuitiveness further
- [ ] Debugging through emulator (DOSBox/X86Box)

## Introduction

This project contains a number of files designed to simplify the workflow when working with C and C++ for Watcom.
The `build.ps1` file takes all source files in the `src` directory and compiles and links them.
`watcom-vscode.code-workspace` is the default project settings, which adds `build.ps1` to the Build Task in vscode (default: ctrl+shift+B).
The `.vscode` directory contains some default settings for C and C++. It will assume C89 and C++98, as those are (at best) what the Watcom C and C++ compilers support.
This file also contains the default Watcom directory for the includes, so if another platform than windows is to be supported, it needs to be updated here as well.
A define for `far` is added here as well to remove annoying vscode squiggles under the `far` keywords.

## Caveats

- Only designed for simple projects
- All C and C++ files in `src` will be built by default

## Structure

`src` : this is where you'll place your own source files  
`obj` : object files output by the Watcom compilers  
`bin` : output from the Watcom linker  
`assets` : place graphics and any related assets in this directory  
`build.ps1` : compiles and links all C/C++ files placed in src directory  

## Goals

The original IDE for OpenWatcom is old and not very user friendly. 

My solution provides something that is supposed to work out-of-the-box for "typical" Watcom scenarios.
This repo was made to suit my own needs; primarily writing code for 16-bit and 32-bit DOS in a modern environment without having to deal with Watcom IDE projects

## Future improvements

- Platform targets and compiler optimization flags
- Post-build actions

## How to use

First, install OpenWatcom 2.0. Then make sure the appropriate PATH, INCLUDE and EDATA environment variables are set for your environment

In the PowerShell commandline, go to a project directory and type the following :

```powershell
Invoke-WebRequest "https://github.com/intbeam/watcom-vscode/tarball/main" -OutFile "./watcom-vscode.tar" && tar.exe -xf "./watcom-vscode.tar" && Remove-Item "./watcom-vscode.tar"
```

This should create a directory named `watcom-vscode` that you can rename to your own needs.

You can also clone the repository and then manually remove the `.git` directory.

## On Linux

Open a terminal and install the required prerequisite tools:

```sh
sudo snap install powershell --classic
sudo snap install code --classic
wget https://github.com/open-watcom/open-watcom-v2/releases/download/Current-build/open-watcom-2_0-c-linux-x64
sudo chmod +x ./open-watcom-2_0-c-linux-x64
sudo ./open-watcom-2_0-c-linux-x64
```

Follow the install instructions for Open Watcom, install in default location (which should be `/usr/bin/watcom`) and remember to select 16-bit compilers.

Finally,

```sh
wget -c https://github.com/intbeam/watcom-vscode/tarball/main -O ./watcom-vscode.tar && tar -xf ./watcom-vscode.tar && rm ./watcom-vscode.tar
```

And delete or replace the readme.

## Requirements

- [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- [Visual Studio Code](https://code.visualstudio.com/Download)
- [Open Watcom 2.0](https://github.com/open-watcom/open-watcom-v2/releases)

## Optional

- [DOSBox](https://www.dosbox.com/download.php?main=1)
- [X86Box](https://github.com/86Box/86Box/releases)


## Thanks

A thanks and apology to @eltoneo for not fixing your issues, I'll try to be more vigilant going forwards

Thanks to the guys over at the Open Watcom Discord for tips

 - Count_MHM
 - Jiri Malak


