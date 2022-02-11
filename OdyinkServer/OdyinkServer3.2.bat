@echo off
::3.2
::初始化
    chcp 936 >nul
    title Odyink Server
    color 07
    cd /d %~dp0
::检测安装
    :Check
    if not exist Odyink\Bloglist.bat goto install
    cd Odyink\
::菜单
    :menu
    cls
    echo 1.校阅文章
    echo 2.导入文章
    echo 3.删除文章
    echo 4.退出程序
    echo.
    set Munum=
    set /p Munum=序号：
    cls
    if "%Munum%"=="1" goto VB
    if "%Munum%"=="2" goto cpBlog
    if "%Munum%"=="3" goto DBlog
    if "%Munum%"=="4" exit
    echo 输入无效
    timeout /t 2 /nobreak >nul
    goto menu
::校阅文章
    :VB
    cls
    call Bloglist.bat
    echo.
    echo.
    call Blognum.bat
    if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
    echo 目前有%Blognum%篇文章
    echo.
    echo q.返回主页
    set EBlognum=
    set /p EBlognum=文章序号：
    cls
    if "%EBlognum%"=="q" goto menu
    ::预处理
        :NBBlog
    ::检测文章是否存在
        if not exist Blog\"%EBlognum%.txt" (
            echo 本文章不存在
            echo 即将返回列表
            timeout /t 2 /nobreak >nul
            goto VB
        )
    ::显示文本内容
        type Blog\%EBlognum%.txt
        echo.
        echo.
        echo b.上一篇 q.返回列表 n.下一篇
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
        echo 输入无效
        echo.
        goto BlogconNE
    ::上一篇文章
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
    ::下一篇文章
        :nextBlog
        set StartEBlognum=%EBlognum%
        cls
        :Next
        set /a EBlognum=%EBlognum%+1
        set /a AV=%EBlognum%-%StartEBlognum%
        if %AV%==101 goto NBBlog
        if exist Blog\%EBlognum%.txt goto NBBlog
        goto Next
::导入文章
    :cpBlog
    cls
    set Docname=
    set Blognum=
    set NewBlognum=
    set Blogtitle=
    ::输入需导入文章的信息
        echo 支持GBK编码的txt文件
        echo 支持拖放文件(记得回车)
        echo q.返回
        echo.
        set /p Docname=文章文件名(无后缀)：
        if "%Docname%"=="q" goto menu
        if exist "%Docname%" goto iptitle
        if not exist ..\"%Docname%.txt" goto CantcpBlog
        :iptitle
        call Blognum.bat
        if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
        set /a NewBlognum=%Blognum%+1
        call BlogAnum.bat
        if "%BlogAnum:~-1%"==" " set BlogAnum=%BlogAnum:~0,-1%
        set /a NewBlogAnum=%BlogAnum%+1
        set /p Blogtitle=文章标题：
        if "%Blogtitle%"=="q" goto cpBlog
    ::开始导入文章
        cls
        echo set Blognum=%NewBlognum% >Blognum.bat
        echo set BlogAnum=%NewBlogAnum% >BlogAnum.bat
        echo set NEB%NewBlogAnum%=E>>Blogexist.bat
        echo if not %%NEB%NewBlogAnum%%%==Del echo %NewBlogAnum%.%Blogtitle% >>Bloglist.bat
        echo %date:~0,-2%%time% copy "%Docname%" to .\Odyink\Blog\ (num:%NewBlogAnum%) >>Bloglog.log
        if exist ..\"%Docname%.txt" copy  ..\"%Docname%.txt" Blog\%NewBlogAnum%.txt >nul
        if exist "%Docname%" copy "%Docname%" Blog\%NewBlogAnum%.txt >nul
        echo 导入完毕
        timeout /t 2 /nobreak >nul
        goto cpBlog
    ::文章不存在
        :CantcpBlog
        cls
        echo 文章不存在
        timeout /t 3 /nobreak >nul
        goto cpBlog
::删除文章
    :DBlog
    cls
    set willDelBlog=
    set DelBlogyn=
    call Bloglist.bat
    call Blognum.bat
    ::输入需删除文章的信息
        :DelBlog
        echo 输入q退出删除
        set /p willDelBlog=要删除文章序号：
        if "%willDelBlog%"=="q" goto menu
        if not exist Blog\"%willDelBlog%.txt" goto DelBlogE
        :BackDelyn
        set /p DelBlogyn=是否删除yn:
        if "%DelBlogyn%"=="y" goto DelBlognow
        if "%DelBlogyn%"=="n" goto DelBlog
        echo 输入无效
        goto BackDelyn
    ::开始删除文章
        :DelBlognow
        echo set NEB%willDelBlog%=Del >>Blogdel.bat
        set /a NewBlognum=%Blognum%-1
        echo set Blognum=%NewBlognum% >Blognum.bat
        echo %date:~0,-2%%time% del %willDelBlog%.txt from .\Odyink\Blog\ (num:%willDelBlog%) >>Bloglog.log
        del Blog\%willDelBlog%.txt
        echo 删除完毕
        timeout /t 2 /nobreak >nul
        cls
        goto DBlog
    ::文章不存在
        :DelBlogE
        echo 文章不存在
        goto DelBlog
::安装
    :install
    echo 回车安装Odyink
    pause >nul
    cls
    mkdir Odyink >nul
    mkdir Odyink\Blog >nul
    cd Odyink
    if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
    ::新建文件写入信息
        echo set Blognum=1 >Blognum.bat
        echo set BlogAnum=0 >BlogAnum.bat
        echo set NEB0=E>>Blogexist.bat
        echo call Blogexist.bat >>Bloglist.bat
        echo call Blogdel.bat>>Bloglist.bat
        echo if not %%NEB0%%==Del echo 0.欢迎使用Odyink>>Bloglist.bat
        echo ::Blogdel>Blogdel.bat
        echo [Bloglog]>Bloglog.log
        echo Odyink是由Andy(python)和SMG(Batch)制作的命令行个人博客软件 >>Blog\0.txt
        cd ..\
        echo 安装完毕
        timeout /t 2 /nobreak >nul
        cls
        goto Check