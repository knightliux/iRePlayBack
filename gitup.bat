
@echo off
set url=%1%
set commit=%2%
::echo 当前盘符和路径：%~dp0
if not exist .git (
 echo 不存在
 git init
 git remote add origin %url%
)
git pull origin master
git add -A
git commit -m "%commit%"
git push origin master 
pause