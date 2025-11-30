@echo off
echo 修复前端资源文件问题...

echo 1. 清理node_modules
if exist node_modules rmdir /s /q node_modules

echo 2. 清理缓存
if exist package-lock.json del package-lock.json

echo 3. 重新安装依赖
npm install

echo 4. 启动开发服务器
npm run dev

echo 修复完成！
echo 现在应该可以正常访问前端了
pause



















