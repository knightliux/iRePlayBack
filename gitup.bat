
@echo off
set url=%1%
set commit=%2%
::echo ��ǰ�̷���·����%~dp0
if not exist .git (
 echo ������
 git init
 git remote add origin %url%
)
git pull origin master
git add -A
git commit -m "%commit%"
git push origin master 
pause