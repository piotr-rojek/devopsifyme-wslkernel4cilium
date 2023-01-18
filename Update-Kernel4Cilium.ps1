# https://harthoover.com/compiling-your-own-wsl2-kernel/
# https://wsl.dev/wslcilium/

$wslConfigPath = "$env:USERPROFILE\.wslconfig" 
$wslKernelPath = "$env:USERPROFILE\.wslkernel" 

# calculate paths for WSL
New-Item -Type Directory output -Force | Out-Null

# build the kernel, checkout output folder for logs, kernel and config used
docker run --name kernel4cilium devopsifyme/wslkernel4cilium
docker cp kernel4cilium:/output/ output/
docker container rm kernel4cilium

# copy kernel to user profile
Copy-Item output/bzImage $wslKernelPath -Force

# update wsl configiration
Install-Module -Scope CurrentUser PsIni -Force
New-Item $wslConfigPath -Type File
$wslConfig = Get-IniContent $wslConfigPath
$wslConfig.wsl2 ??= @{}
$wslConfig.wsl2.kernel = $wslKernelPath -replace '\\','\\'
$wslConfig | Out-IniFile -FilePath $wslConfigPath -Force

# restart
wsl --shutdown