# DevOpsify Me - WSL Kernel 4 Cilium

Docker image and a script for building and configuring WSL custom kernel that is capable of running Cilium CNI for Kubernetes.

## Local Build

```sh
docker build . --file Dockerfile --tag devopsifyme/wslkernel4cilium
```

## Usage

Environmental Variables
* KERNEL_BRANCH = linux-msft-wsl-5.15.y, see https://github.com/microsoft/WSL2-Linux-Kernel/branches for available values

```ps1
./Update-Kernel4Cilium.ps1
```

## Remarks

Checkk https://devopsifyme.com for more information