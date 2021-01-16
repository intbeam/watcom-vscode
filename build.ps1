param(
    [parameter(Mandatory = $false)][switch]$release = $false
)

# Watcom install path - assume root
[string]$watcomInstallPath = "C:\WATCOM"

# Retrieve all source code files (c, cpp) from src directory
$files = (Get-ChildItem -Path "./src" -Filter "*.c??" -Recurse | Where-Object { $_.Extension.ToLowerInvariant() -in (".c", ".cpp")} | Select-Object -ExpandProperty FullName | ForEach-Object { """{0}""" -f $_ }  )
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

# Compile and link. Output files to obj directory and put the binary in bin
wcl.exe $fileString /fo="obj/" /bc /fe="bin/main.exe"

