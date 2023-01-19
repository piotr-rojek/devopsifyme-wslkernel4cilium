# https://docs.cilium.io/en/v1.12/operations/system_requirements/#linux-kernel
apt-get update && apt-get -y install git python3 bc build-essential flex bison dwarves libssl-dev libelf-dev

git clone --progress --branch $KERNEL_BRANCH --single-branch --no-recurse-submodules --no-tags --depth 1 $KERNEL_ORIGIN /src

cd /src

# Base Requirements
echo '
CONFIG_BPF=y
CONFIG_BPF_SYSCALL=y
CONFIG_NET_CLS_BPF=y
CONFIG_BPF_JIT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_BPF=y
' >> Microsoft/config-wsl

# Iptables-based Masquerading
echo '
CONFIG_NETFILTER_XT_SET=m
CONFIG_IP_SET=m
CONFIG_IP_SET_HASH_IP=m
' >> Microsoft/config-wsl

# L7 and FQDN Policies
echo '
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
' >> Microsoft/config-wsl

# IPsec
echo '
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
CONFIG_INET{,6}_ESP=m
CONFIG_INET{,6}_IPCOMP=m
CONFIG_INET{,6}_XFRM_TUNNEL=m
CONFIG_INET{,6}_TUNNEL=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_AES=m
' >> Microsoft/config-wsl

# Bandwidth Manager
echo '
CONFIG_NET_SCH_FQ=m
' >> Microsoft/config-wsl

echo 'Starting to build... may take 10-20 minutes to complete'
make -j8 KCONFIG_CONFIG=Microsoft/config-wsl > log.txt

mkdir /output
cp Microsoft/config-wsl /output/
cp log.txt /output/
cp arch/x86/boot/bzImage /output/