# Copyright 2021-2024 intbeam
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
    [parameter(Mandatory = $true)][string]$configuration
)

$cppConfig = ConvertFrom-Json -InputObject (Get-Content -Raw -Path "./.vscode/c_cpp_properties.json")


$configurations = ($cppConfig.configurations)

$currentConfig = $configurations | Where-Object { $_.name -eq $configuration}[0]


$watcomInstallPath = $env:WATCOM

if(!$watcomInstallPath)
{
    if($IsWindows)
    {
        $watcomInstallPath = "C:/WATCOM"
    }
    else
    {
        $watcomInstallPath = "/usr/bin/watcom"
    }
}

# Retrieve all source code files (c, cpp) from src directory
$files = (Get-ChildItem -Path "./src" -Filter "*" -Recurse | Where-Object { $_.Extension.ToLowerInvariant() -in (".c", ".cpp")} | Select-Object -ExpandProperty FullName | ForEach-Object { "{0}" -f $_ }  )

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

    if($IsWindows -ne "Windows")
    {
        $pathSeparator = ":"
    }

    # Set new PATH environment variables
    $env:PATH = ($existingPath | Join-String -Separator $pathSeparator)

    # Set relevant environment variables
    $env:WATCOM = $watcomInstallPath
    $env:EDPATH = "$watcomInstallPath/eddat"
    
    if($IsWindows)
    {
        $env:INCLUDE = "$watcomInstallPath/h;$watcomInstallPath/h/nt"
    }
    else
    {
        $env:INCLUDE = "$watcomInstallPath/h"
    }
    
}

if(!$env:INCLUDE)
{
    $env:INCLUDE = "$watcomInstallPath/h;$watcomInstallPath/h/nt"
}

write-host "include $env:INCLUDE"

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
[string[]]$wclArguments = $currentConfig.compilerArgs

# append files to compile to arguments
$wclArguments += $files


[string]$command = $currentConfig.compilerPath


& $command $wclArguments
