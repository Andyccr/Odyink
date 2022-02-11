@echo off
::2.0
chcp 936 >nul
title Odyink [for WindowsServer]
color 0b
if exist ServerOK del ServerOK
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:check
if not exist Odyink\Odyink.txt goto install
cd Odyink\
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
echo 检测是否存在PowerShell
set ps=
if not exist %SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe ( 
    set ps=notps
    goto sign_admin
)
echo 检测网络中
set net=
if exist index.html del index.html
PowerShell wget https://www.kernel.org/index.html -outfile index.html >nul
if exist index.html (
    if exist index.html del index.html
    set net=ok
    echo ServerOK >ServerOK
)
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:sign_admin
echo SF
cls
echo.
if "%ps%"=="notps" echo 查找不到PowerShell无法检测网络
if "%net%"=="ok" echo 网络服务成功运行
if "%net%"=="" echo 网络出错
echo.
echo.
echo.
echo 请输入账号密码
echo 输入q退出
echo.
set /p usernum=账号：
if "%usernum%"=="q" goto end
echo.
set /p passwd=密码：
if "%passwd%"=="q" goto end
cls
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set /a ipkey=(%usernum%*%passwd:~-1%+%passwd%*%usernum:~0,1%)*(%usernum:~-1%-%passwd:~0,1%)
cls
::...............密码结果4320960...............
if "%ipkey%" == "4320960" goto Admin
echo 账号密码错误
timeout /t 2 /nobreak >nul
cls
goto sign_admin
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:Admin
cls
echo ******************************
echo **          服务端          **
echo ******************************
echo **                          **
echo **  1.校阅博客              **
echo **  2.导入文章              **
echo **  3.删除文章              **
echo **  4.系统信息              **
echo **  5.退出登录              **
echo **                          **
echo ******************************
echo.
echo.
set Adnum=
set /p Adnum=序号：
cls
if "%Adnum%"=="1" goto VB
if "%Adnum%"=="2" goto ipBlog
if "%Adnum%"=="3" goto DBlog
if "%Adnum%"=="4" goto C
if "%Adnum%"=="5" goto exitAdmin
echo 输入无效
timeout /t 2 /nobreak >nul
goto Admin
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:VB
cls
echo     OdyInkBlog
echo.
echo.
echo.
echo.
call Bloglist.bat
echo.
echo.
call Blognum.bat
if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
echo   目前有%Blognum%篇文章
echo.
echo.
echo         q.返回主页
set EBlognum=
set /p EBlognum=文章序号：
cls
if "%EBlognum%"=="q" goto Admin
if "%EBlognum%"=="" (
    echo 本文章不存在或已被管理员删除
    echo 即将返回列表
    timeout /t 2 /nobreak >nul
    goto VB
)
if "%EBlognum%"==" " (
    echo 本文章不存在或已被管理员删除
    echo 即将返回列表
    timeout /t 2 /nobreak >nul
    goto VB
)
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:NBBlog
if not exist Blog\"%EBlognum%.txt" (
    echo 本文章不存在或已被管理员删除
    echo 即将返回列表
    timeout /t 2 /nobreak >nul
    goto VB
)
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
type Blog\%EBlognum%.txt
echo.
echo.
echo.
echo b.上一篇 q.返回列表 n.下一篇
echo.
echo          c.修改文章
echo.
:BlogconNE
set Blogcon=
set /p Blogcon=操作序号：
if "%Blogcon%"=="b" goto backBlog
if "%Blogcon%"=="n" goto nextBlog
if "%Blogcon%"=="q" goto VB
if "%Blogcon%"=="c" (
    notepad.exe .\Blog\%EBlognum%.txt
    cls
    goto NBBlog
)
echo 输入无效请重新输入
echo.
goto BlogconNE
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:backBlog
set StartEBlognum=%EBlognum%
cls
:Back
set /a EBlognum=%EBlognum%-1
set /a AV=%StartEBlognum%-%EBlognum%
if %AV%==101 goto NBBlog
if %EBlognum%==-1 goto NBBlog
if exist Blog\%EBlognum%.txt goto NBBlog
goto Back
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:nextBlog
set StartEBlognum=%EBlognum%
cls
:Next
set /a EBlognum=%EBlognum%+1
set /a AV=%EBlognum%-%StartEBlognum%
if %AV%==101 goto NBBlog
if exist Blog\%EBlognum%.txt goto NBBlog
goto Next
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:ipBlog
cls
set Docname=
set Blognum=
set NewBlognum=
set Blogtitle=
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo.
echo 支持编码ANSI GBK (UTF-8仅英文，数字)
echo 支持文件格式txt
echo 支持拖放文件(记得回车)
echo.
echo.
echo.
echo q.返回
set /p Docname=文章文件名(无后缀)：
if "%Docname%"=="q" goto Admin
if exist "%Docname%" goto iptitle
if not exist ..\"%Docname%.txt" goto CantipBlog
:iptitle
call Blognum.bat
if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
set /a NewBlognum=%Blognum%+1
call BlogAnum.bat
if "%BlogAnum:~-1%"==" " set BlogAnum=%BlogAnum:~0,-1%
set /a NewBlogAnum=%BlogAnum%+1
set /p Blogtitle=文章标题：
if "%Blogtitle%"=="q" goto ipBlog
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cls
echo set Blognum=%NewBlognum% >Blognum.bat
echo set BlogAnum=%NewBlogAnum% >BlogAnum.bat
echo set NEB%NewBlogAnum%=E>>Bloglog.bat
echo if not %%NEB%NewBlogAnum%%%==Del echo %NewBlogAnum%.%Blogtitle% >>Bloglist.bat
if exist ..\"%Docname%.txt" copy  ..\"%Docname%.txt" Blog\%NewBlogAnum%.txt >nul
if exist "%Docname%" copy "%Docname%" Blog\%NewBlogAnum%.txt >nul
echo 导入完毕
timeout /t 2 /nobreak >nul
goto ipBlog
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:CantipBlog
cls
echo 文章文件名不符合规范或文章文件不存在
echo 请输入有效文章文件名
timeout /t 3 /nobreak >nul
goto ipBlog
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:DBlog
cls
set willDelBlog=
set DelBlogyn=
call Bloglist.bat
call Blognum.bat
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:DelBlog
echo 输入q退出删除
set /p willDelBlog=要删除文章序号：
if "%willDelBlog%"=="" goto DelBlogE
if "%willDelBlog%"=="q" goto Admin
if not exist Blog\"%willDelBlog%.txt" goto DelBlogE
:BackDelyn
set /p DelBlogyn=是否删除yn:
if "%DelBlogyn%"=="y" goto DelBlognow
if "%DelBlogyn%"=="n" goto DelBlog
echo 输入无效
goto BackDelyn
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:DelBlognow
del Blog\%willDelBlog%.txt
echo set NEB%willDelBlog%=Del >>Blogdel.bat
set /a NewBlognum=%Blognum%-1
echo set Blognum=%NewBlognum% >Blognum.bat
echo 删除完毕
timeout /t 2 /nobreak >nul
cls
goto DBlog
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:DelBlogE
echo 本文章不存在或已被管理员删除
goto DelBlog
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:C
echo 检测是否存在PowerShell
set ps=
if not exist %SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe ( 
    set ps=notps
)
echo 检测网络中
set net=
if exist index.html del index.html
PowerShell wget https://www.kernel.org/index.html -outfile index.html >nul
if exist index.html (
    if exist index.html del index.html
    set net=ok
    echo ServerOK >ServerOK
)
cls
echo.
if "%ps%"=="notps" echo 查找不到PowerShell无法检测网络
if "%net%"=="ok" echo 网络服务成功运行
if "%net%"=="" echo 网络出错
echo.
echo.
systeminfo
echo.
echo.
echo.
echo 回车返回
pause >nul
goto Admin
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:install
echo 回车安装Odyink
echo 如果已安装过则表示有文件损坏，请手动退出检查文件完整性
pause >nul
echo 正在安装Odyink
mkdir Odyink >nul
mkdir Odyink\Blog >nul
cd Odyink
if exist ServerOK del ServerOK
if exist BlogAnum.bat del BlogAnum.bat
if exist Blognum.bat del Blognum.bat
if exist Bloglist.bat del Bloglist.bat
if exist Bloglog.bat del Bloglog.bat
if exist Blogdel.bat del Blogdel.bat
if exist exdoc.bat del exdoc.bat
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Odyink for WindowsServer(By SMG)>Odyink.txt
echo set Blognum=1 >Blognum.bat
echo set BlogAnum=0 >BlogAnum.bat
echo set NEB0=E>>Bloglog.bat
echo call Bloglog.bat >>Bloglist.bat
echo if exist Blogdel.bat call Blogdel.bat>>Bloglist.bat
echo if not %%NEB0%%==Del echo 0.欢迎使用Odyink>>Bloglist.bat
echo 欢迎使用Odyink for Windows Server(By SMG)>>Blog\0.txt
echo.>>Blog\0.txt
echo.>>Blog\0.txt
echo.>>Blog\0.txt
echo Odyink是由Andy(python)和SMG(Batch)制作的命令行个人博客软件 >>Blog\0.txt
echo.>>Blog\0.txt
cd ..\
timeout /t 2 /nobreak >nul
cls
echo 安装完毕
timeout /t 2 /nobreak >nul
cls
echo 初始账号:123456
echo 初始密码:123456
echo 密码算法:(账号X密码末位+密码X账号首位)X(账号末位-密码首位)=密码结果
echo 账号密码都必须是纯数字且不可超过6位
timeout /t 35
cls
goto check
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
:exitAdmin
cls
set usernum=
set passwd=
set ipkey=
echo 已退出登录
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~我是小分界线~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:end
echo 正在退出Odyink...
if exist ServerOK del ServerOK
timeout /t 2 /nobreak >nul
cls
::::::::::::::::::::::::::::::::::::::::::::::::::我是分界线::::::::::::::::::::::::::::::::::::::::::::::::::
exit