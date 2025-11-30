@echo off
echo 修复前端依赖和文件问题...

echo 1. 清理node_modules和package-lock.json
if exist node_modules rmdir /s /q node_modules
if exist package-lock.json del package-lock.json

echo 2. 重新安装依赖
npm install

echo 3. 启动开发服务器
npm run dev

echo 修复完成！
echo 如果仍有问题，请检查：
echo 1. Node.js版本是否为16+
echo 2. 网络连接是否正常
echo 3. 端口3000是否被占用
pause



















