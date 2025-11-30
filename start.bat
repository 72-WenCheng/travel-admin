@echo off
echo ========================================
echo 旅游系统管理端启动脚本
echo ========================================

echo 检查Node.js环境...
node --version
if %errorlevel% neq 0 (
    echo 错误：未找到Node.js环境，请先安装Node.js 16+
    pause
    exit /b 1
)

echo.
echo 检查npm环境...
npm --version
if %errorlevel% neq 0 (
    echo 错误：未找到npm环境
    pause
    exit /b 1
)

echo.
echo 安装依赖包...
npm install
if %errorlevel% neq 0 (
    echo 错误：依赖安装失败
    pause
    exit /b 1
)

echo.
echo 启动开发服务器...
echo 访问地址：http://localhost:3000
echo.
echo 按 Ctrl+C 停止服务
echo.

npm run dev

pause