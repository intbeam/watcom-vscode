# Copyright 2021 intbeam
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
# to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

param(
    [parameter(Mandatory = $false)][switch]$release = $false,
    [parameter(Mandatory = $false)][string]$architecture = "16bit"    
)

[string]$operatingSystem = "Windows"
# Watcom install path - assume root
[string]$watcomInstallPath = "C:/WATCOM"

# if platform is Unix change install path
if($IsLinux)
{    
    $watcomInstallPath = "/usr/bin/watcom"    
}

# Retrieve all source code files (c, cpp) from src directory
$files = (Get-ChildItem -Path "./src" -Filter "*.c*" -Recurse | Where-Object { $_.Extension.ToLowerInvariant() -in (".c", ".cpp")} | Select-Object -ExpandProperty FullName | ForEach-Object { """{0}""" -f $_ }  )

# Check environment variables. If Environment contains watcom install path we will assume it has been set correctly
if($env:PATH.contains($watcomInstallPath) -ne $true)
{
    # Deconstruct environment path
    $existingPath = $env:PATH -split ";"


    if($IsWindows)
    {
        # Add watcom paths
        $existingPath += ("$watcomInstallPath/binnt64", "$watcomInstallPath/binnt")
    }
    else
    {
        $existingPath += ("$watcomInstallPath/binl")
    }

    [string]$pathSeparator = ";"

    if($operatingSystem -ne "Windows")
    {
        $pathSeparator = ":"
    }

    # Set new PATH environment variables
    $env:PATH = ($existingPath | Join-String -Separator $pathSeparator)

    # Set relevant environment variables
    $env:WATCOM = $watcomInstallPath
    $env:EDPATH = "$watcomInstallPath/eddat"
    
    if($operatingSystem -eq "Windows")
    {
        $env:INCLUDE = "$watcomInstallPath/h;$watcomInstallPath/h/nt"
    }
    else
    {
        $env:INCLUDE = "$watcomInstallPath/h"
    }
}

# Create bin and obj directories if they don't exist
if(-not (Test-Path "./bin"))
{
    New-Item "./bin" -ItemType Directory
}

if(-not (Test-Path "./obj"))
{
    New-Item "./obj" -ItemType Directory
}

# define wcl arguments here
[string[]]$wclArguments = ("-fo=""./obj/""", "-bc", "-bt=DOS", "-fe=""./bin/main.exe""")

# append files to compile to arguments
$wclArguments += $files

# if($release -eq $false)
# {
     #$wclArguments += "-d2"
# }

[string]$command = "wcl"

# Compile and link. Output files to obj directory and put the binary in bin
Write-Host $architecture
if($architecture -eq "32bit")
{
    $command = "wcl386"
}

& $command $wclArguments
