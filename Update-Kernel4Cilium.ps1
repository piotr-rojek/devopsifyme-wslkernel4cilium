# https://harthoover.com/compiling-your-own-wsl2-kernel/
# https://wsl.dev/wslcilium/
[CmdletBinding()]
param(
    $WslConfigPath = "$env:USERPROFILE\.wslconfig",
    $WslKernelPath = "$env:USERPROFILE\.wslkernel",
    $ContainerName = 'cilium',
    $KernelOrigin='https://github.com/microsoft/WSL2-Linux-Kernel.git',
    $KernelBranch='linux-msft-wsl-5.15.y',
    $ImageTag = 'ubuntu:latest'
)

# build the kernel, checkout output folder for logs, kernel and config used
try
{
    docker run --name $ContainerName -d -it -e KERNEL_ORIGIN=$KernelOrigin -e KERNEL_BRANCH=$KernelBranch $ImageTag bash
    docker cp build.sh "$($ContainerName):/"
    docker exec $ContainerName sh /build.sh
    docker cp "$($ContainerName):/output" .
}
finally
{
    docker rm $ContainerName --force
}

# stop WSL
wsl --shutdown
Start-Sleep 10s

# copy kernel to user profile
Copy-Item output/bzImage $WslKernelPath -Force

# update wsl configiration
Install-Module -Scope CurrentUser PsIni -Force
New-Item $WslConfigPath -Type File -Force | Out-Null
$wslConfig = Get-IniContent $WslConfigPath
$wslConfig.wsl2 ??= @{}
$wslConfig.wsl2.kernel = $WslKernelPath -replace '\\','\\'
$wslConfig | Out-IniFile -FilePath $WslConfigPath -Force

# restart WsL
wsl --shutdown