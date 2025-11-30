@echo off
echo Clearing Vite cache...
rmdir /s /q node_modules\.vite 2>nul
echo Clearing dist folder...
rmdir /s /q dist 2>nul
echo Done! Now restart your dev server.
pause

