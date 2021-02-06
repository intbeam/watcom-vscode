Clear-Host

[string]$binaryPath = '../tools/dosbox/dosbox.exe';

# Check if DosBox is in the tools directory
if($IsWindows)
{
    if(Test-Path -Path '../tools/dosbox/dosbox.exe')
    {
        $binaryPath = '../tools/dosbox/dosbox.exe'
    }
    else
    {
        # write error and return file not found
        Write-Error 'Copy dosbox binaries to (workspace)/tools/dosbox'
        exit 2
    }
}
else {
    if(Test-Path -Path '../tools/dosbox/dosbox')
    {
        $binaryPath = '../tools/dosbox/dosbox'   
    }
    else
    {
        $binaryPath = 'dosbox'
    }

}

& $binaryPath ('main.exe', '-exit')