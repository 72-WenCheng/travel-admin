@echo off
chcp 65001 >nul
echo ========================================
echo    清除管理平台缓存并重启开发服务器
echo ========================================
echo.

echo [1/4] 正在清除 node_modules/.cache 目录...
if exist "node_modules\.cache" (
    rmdir /s /q "node_modules\.cache"
    echo ✓ 已删除 node_modules\.cache
) else (
    echo - node_modules\.cache 不存在
)
echo.

echo [2/4] 正在清除 dist 目录...
if exist "dist" (
    rmdir /s /q "dist"
    echo ✓ 已删除 dist
) else (
    echo - dist 不存在
)
echo.

echo [3/4] 正在清除 .vite 缓存目录...
if exist ".vite" (
    rmdir /s /q ".vite"
    echo ✓ 已删除 .vite
) else (
    echo - .vite 不存在
)
echo.

echo [4/4] 清除浏览器缓存提示...
echo.
echo ========================================
echo    重要提示！
echo ========================================
echo.
echo 请在浏览器中执行以下操作：
echo.
echo 1. 按 Ctrl + Shift + Delete 打开清除浏览器数据
echo 2. 选择"缓存的图片和文件"
echo 3. 点击"清除数据"
echo.
echo 或者直接按：Ctrl + F5 进行硬刷新
echo.
echo ========================================
echo.

pause

echo.
echo 正在重启开发服务器...
echo.

npm run dev


