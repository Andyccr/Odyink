@echo off
::3.0
chcp 936 >nul
title Odyink [for WindowsUser]
color 0b
cd /d %~dp0
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:check
if not exist Odyink\website.bat goto install
cd Odyink\
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
::checkfile
echo 检测是否存在PowerShell
if not exist %SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe (
    echo 查找不到PowerShell
    goto exit
)
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:checknet
echo 检测网络中
if exist index.html del index.html
PowerShell wget https://www.kernel.org/index.html -outfile index.html >nul
if exist index.html (
    if exist index.html del index.html
    goto get
)
echo 网络出错!
goto exit
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:get
cls
echo 正在下载列表请稍后...
call website.bat
if "%website:~-1%"==" " set website=%website:~0,-1%
if exist index.html del index.html
if exist ServerOK del ServerOK
if exist Blog*.bat del Blog*.bat
if exist exdoc.bat del exdoc.bat
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
PowerShell wget %website%/ServerOK -outfile ServerOK >nul
if not exist ServerOK goto ServerError
PowerShell wget %website%/BlogAnum.bat -outfile BlogAnum.bat >nul
PowerShell wget %website%/Blognum.bat -outfile Blognum.bat >nul
PowerShell wget %website%/Bloglist.bat -outfile Bloglist.bat >nul
PowerShell wget %website%/Blogexist.bat -outfile Blogexist.bat >nul
PowerShell wget %website%/Blogdel.bat -outfile Blogdel.bat >nul
if not exist BlogAnum.bat goto ServerError
if not exist Blognum.bat goto ServerError
if not exist Bloglist.bat goto ServerError
if not exist Blogdel.bat goto ServerError
if not exist Blogexist.bat goto ServerError
cls
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:VB
cls
echo       OdyInk
echo.
echo.
echo.
echo.
call Bloglist.bat
echo.
echo.
call Blognum.bat
if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
echo    目前有%Blognum%篇文章
echo.
echo.
echo      r.刷新  q.退出
set EBlognum=
set /p EBlognum=........文章序号：
cls
if "%EBlognum%"=="r" goto get
if "%EBlognum%"=="q" goto exit
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:NBBlog
cls
set jump=
set find=
if "%EBlognum:~-1%"==" " set EBlognum=%EBlognum:~0,-1%
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
if exist exdoc.bat del exdoc.bat
cls
::-----------------------------------------我是线-----------------------------------------
echo 正在查找并下载文章...
PowerShell wget %website%/Blog/"%EBlognum%.txt" -outfile Blog\%EBlognum%.txt >nul
cls
::-----------------------------------------我是线-----------------------------------------
if not exist Blog\"%EBlognum%.txt" (
    echo 本文章不存在或网络出错
    echo 即将返回列表
    timeout /t 2 /nobreak >nul
    goto VB
)
::-----------------------------------------我是线-----------------------------------------
type Blog\%EBlognum%.txt
echo.
echo.
echo.
echo b.上一篇 n.下一篇 q.返回列表
echo.
echo         r.刷新文章
echo.
:BlogconNE
set Blogcon=
set /p Blogcon=操作序号：
if "%Blogcon%"=="b" goto backBlog
if "%Blogcon%"=="n" goto nextBlog
if "%Blogcon%"=="q" goto VB
if "%Blogcon%"=="r" goto NBBlog
echo 输入无效请重新输入
echo.
goto BlogconNE
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:backBlog
set StartEBlognum=%EBlognum%
cls
echo 正在搜索数据库请稍后...
:Back
set /a EBlognum=%EBlognum%-1
set /a AV=%StartEBlognum%-%EBlognum%
echo if "%%NEB%EBlognum%%%"=="E" set EBlognum=%EBlognum% >>exdoc.bat
echo if "%%NEB%EBlognum%%%"=="E" set find=fd>>exdoc.bat
echo if "%%find%%"=="fd" set jump=jpn>>exdoc.bat
echo if "%%find%%"=="fd" goto :EOF>>exdoc.bat
if %AV%==101 goto NBBlog
if %AV%==100 call exdoc.bat
if "%jump%"=="jpn" goto NBBlog
goto Back
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:nextBlog
set StartEBlognum=%EBlognum%
cls
echo 正在搜索数据库请稍后...
:Next
set /a EBlognum=%EBlognum%+1
set /a AV=%EBlognum%-%StartEBlognum%
echo if "%%NEB%EBlognum%%%"=="E" set EBlognum=%EBlognum% >>exdoc.bat
echo if "%%NEB%EBlognum%%%"=="E" set find=fd>>exdoc.bat
echo if "%%find%%"=="fd" set jump=jpn>>exdoc.bat
echo if "%%find%%"=="fd" goto :EOF>>exdoc.bat
if %AV%==101 goto NBBlog
if %AV%==100 call exdoc.bat
if "%jump%"=="jpn" goto NBBlog
goto Next
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:install
echo 配置Odyink
set /p website=域名或IP[/目录]：
echo 正在配置Odyink...
if "%website:~-1%"=="/" set website=%website:~0,-1%
mkdir Odyink >nul
mkdir Odyink\Blog >nul
cd Odyink
if exist ServerOK del ServerOK
if exist Blog*.bat del Blog*.bat
if exist exdoc.bat del exdoc.bat
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
echo set website=%website% >website.bat
cd ..\
cls
echo 配置完毕
timeout /t 2 /nobreak >nul
cls
goto check
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:ServerError
echo 服务器出错
:exit
echo 正在退出Odyink...
if exist index.html del index.html
if exist ServerOK del ServerOK
if exist Blog*.bat del Blog*.bat
if exist exdoc.bat del exdoc.bat
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
timeout /t 2 /nobreak >nul
cls
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
exit