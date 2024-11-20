#!/bin/bash

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]; then 
    echo "请使用sudo运行此脚本"
    exit 1
fi

# 设置颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 打印带颜色的状态信息
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

print_error() {
    echo -e "${RED}[!] $1${NC}"
}

# 检查命令是否执行成功
check_status() {
    if [ $? -eq 0 ]; then
        print_status "$1 成功"
    else
        print_error "$1 失败"
        exit 1
    fi
}

# 更新软件包列表
print_status "更新软件包列表..."
apt-get update
check_status "更新软件包列表"

# 安装基本开发工具
print_status "安装基本开发工具..."
apt-get install -y build-essential
check_status "安装基本开发工具"

# 安装mingw-w64
print_status "安装mingw-w64..."
apt-get install -y mingw-w64
check_status "安装mingw-w64"

# 安装NASM
print_status "安装NASM..."
apt-get install -y nasm
check_status "安装NASM"

# 安装Python3和pip
print_status "安装Python3和pip..."
apt-get install -y python3 python3-pip
check_status "安装Python3和pip"

# 安装pycryptodome
print_status "安装pycryptodome..."
pip3 install pycryptodome
check_status "安装pycryptodome"

# 验证安装
print_status "验证安装..."

# 检查mingw
if command -v x86_64-w64-mingw32-g++ >/dev/null 2>&1; then
    print_status "mingw-w64已安装: $(x86_64-w64-mingw32-g++ --version | head -n1)"
else
    print_error "mingw-w64安装失败"
    exit 1
fi

# 检查nasm
if command -v nasm >/dev/null 2>&1; then
    print_status "NASM已安装: $(nasm --version | head -n1)"
else
    print_error "NASM安装失败"
    exit 1
fi

# 检查Python3
if command -v python3 >/dev/null 2>&1; then
    print_status "Python3已安装: $(python3 --version)"
else
    print_error "Python3安装失败"
    exit 1
fi

# 检查pycryptodome
if python3 -c "from Crypto.Cipher import AES; print('AES available')" >/dev/null 2>&1; then
    print_status "pycryptodome已安装并可用"
else
    print_error "pycryptodome安装失败或不可用"
    exit 1
fi

print_status "所有组件安装完成!"
print_status "下面运行GhostLoader构建脚本"
