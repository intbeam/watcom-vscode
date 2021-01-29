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
    [parameter(Mandatory = $false)][switch]$release = $false
)

# Watcom install path - assume root
[string]$watcomInstallPath = "C:\WATCOM"

# Retrieve all source code files (c, cpp) from src directory
$files = (Get-ChildItem -Path "./src" -Filter "*.c*" -Recurse | Where-Object { $_.Extension.ToLowerInvariant() -in (".c", ".cpp")} | Select-Object -ExpandProperty FullName | ForEach-Object { """{0}""" -f $_ }  )
[string]$fileString = $files | Join-String -Separator " "

# Check environment variables. If Environment contains watcom install path we will assume it has been set correctly
if($env:Path.contains($watcomInstallPath) -ne $true)
{
    # Deconstruct environment path
    $existingPath = $env:Path -split ";"

    # Add watcom paths
    $existingPath = $existingPath + ("$watcomInstallPath\binnt64", "$watcomInstallPath\binnt")

    # Set new PATH environment variables
    $env:Path = ($existingPath | Join-String -Separator ";")

    # Set relevant environment variables
    $env:WATCOM = $watcomInstallPath
    $env:EDPATH = "$watcomInstallPath\EDDAT"
    $env:INCLUDE = "$watcomInstallPath\H;$watcomInstallPath\H\NT"
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
[string[]]$wclArguments = ("/fo=""./obj/""", "/bc", "/fe=""./bin/main.exe""")

# append files to compile to arguments
$wclArguments += $files

# Compile and link. Output files to obj directory and put the binary in bin
& 'wcl.exe' $wclArguments
