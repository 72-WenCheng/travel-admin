#!/bin/bash

echo "========================================"
echo "旅游系统管理端启动脚本"
echo "========================================"

# 检查Node.js环境
echo "检查Node.js环境..."
if ! command -v node &> /dev/null; then
    echo "错误：未找到Node.js环境，请先安装Node.js 16+"
    exit 1
fi

node --version

# 检查npm环境
echo ""
echo "检查npm环境..."
if ! command -v npm &> /dev/null; then
    echo "错误：未找到npm环境"
    exit 1
fi

npm --version

# 安装依赖
echo ""
echo "安装依赖包..."
npm install
if [ $? -ne 0 ]; then
    echo "错误：依赖安装失败"
    exit 1
fi

# 启动开发服务器
echo ""
echo "启动开发服务器..."
echo "访问地址：http://localhost:3000"
echo ""
echo "按 Ctrl+C 停止服务"
echo ""

npm run dev






