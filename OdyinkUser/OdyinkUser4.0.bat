@echo off
rem 4.0
rem 初始化环境
    chcp 936 >nul
    title Odyink User
    color 07
    cd /d %~dp0
rem 检测
    :check
    rem 检测配置
        if not exist odyink\website.bat goto :setOdyink
        cd odyink\
    rem 检测设置下载器
        set wgetparameter=
        set psparameter=
        set ps=
        if exist ..\wget.exe set wget=..\wget.exe
        if exist .\wget.exe set wget=wget.exe
        if exist %SystemRoot%\System32\wget.exe set wget=wget.exe
        if exist %SystemRoot%\SysWOW64\wget.exe set wget=wget.exe
        if %wget:~-8%==wget.exe (
            rem -q前有1空格
            rem win10可用https而7不行为兼容性不查证书(不安全)
            set wgetparameter= -q --no-check-certificate -P ./
        ) else (
            set ps=use
            set wget=PowerShell Invoke-WebRequest
            rem -outfile 前后各有1空格
            set psparameter= -outfile 
        )
rem 看文章
    rem 下载列表
        :get
        cls
        echo 正在下载列表请稍后...
        call website.bat
        if "%website:~-1%"==" " set website=%website:~0,-1%
        if exist index.html del index.html
        if exist Blog*.bat del Blog*.bat
        if exist exdoc.bat del exdoc.bat
        if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
        echo 正在下载Bloglist.bat
        if "%ps%"=="use" set psdf=Bloglist.bat
        %wget%%wgetparameter% %website%/Bloglist.bat%psparameter%%psdf%
        if not exist Bloglist.bat goto :ServerError
        echo 正在下载Blognum.bat
        if "%ps%"=="use" set psdf=Blognum.bat
        %wget%%wgetparameter% %website%/Blognum.bat%psparameter%%psdf%
        echo 正在下载Blogexist.bat
        if "%ps%"=="use" set psdf=Blogexist.bat
        %wget%%wgetparameter% %website%/Blogexist.bat%psparameter%%psdf%
        echo 正在下载Blogdel.bat
        if "%ps%"=="use" set psdf=Blogdel.bat
        %wget%%wgetparameter% %website%/Blogdel.bat%psparameter%%psdf%
        if exist ..\.wget-hsts del ..\.wget-hsts
        if not exist Blognum.bat goto :ServerError
        if not exist Bloglist.bat goto :ServerError
        if not exist Blogdel.bat goto :ServerError
        if not exist Blogexist.bat goto :ServerError
        cls
    rem 文章列表
        :VB
        cls
        call Bloglist.bat
        echo.
        echo.
        call Blognum.bat
        if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
        echo 目前有%Blognum%篇文章
        echo.
        echo r.刷新 q.退出
        set EBlognum=
        set /p EBlognum=文章序号：
        cls
        if /i "%EBlognum%"=="r" goto :get
        if /i "%EBlognum%"=="q" goto :exit
    rem 下载浏览文章
        rem 预处理
            :NBBlog
            cls
            set NEBEB=
            if "%EBlognum:~-1%"==" " set EBlognum=%EBlognum:~0,-1%
            if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
            cls
        rem 下载文章
            echo 下载文章中
            rem 改输出目录为./Blog/
            rem 因正常bat和txt中只存在一者,至少一条报错用nul屏蔽
            if %wget:~-8%==wget.exe set wgetparameter= -q --no-check-certificate -P ./Blog/
            if "%ps%"=="use" set psdf=Blog\%EBlognum%.bat
            %wget%%wgetparameter% %website%/Blog/"%EBlognum%.bat"%psparameter%%psdf% >nul
            if "%ps%"=="use" set psdf=Blog\%EBlognum%.txt
            %wget%%wgetparameter% %website%/Blog/"%EBlognum%.txt"%psparameter%%psdf% >nul
            if exist ..\.wget-hsts del ..\.wget-hsts
            rem 改回目录为./
            if %wget:~-8%==wget.exe set wgetparameter= -q --no-check-certificate -P ./
            cls
        rem 检测文章是否存在
        if not exist Blog\"%EBlognum%.bat" (
            if not exist Blog\"%EBlognum%.txt" (
                echo 文章不存在
                timeout /t 2 /nobreak >nul
                goto :VB
            )
        )
        rem 显示文本内容Batch
            rem 因复合句中变量为复合句前的变量,使用用延迟变量获得句中变量的动态值
            setlocal enabledelayedexpansion
            if exist Blog\"%EBlognum%.bat" (
                echo 这是Batch扩展
                echo 可在odyink\Blog\%EBlognum%.bat中查看代码
                echo 因Batch扩展特殊性执行后果自负
                echo 查看代码是为了防病毒!!!
                set batrunyn=
                set /p batrunyn=是否确认执行yn:
                if /i "!batrunyn!"=="y" (
                    cls
                    cmd /c .\Blog\%EBlognum%.bat
                    cls
                    rem 重新初始化
                        rem 这里if复合句不能用@echo off会报错现移到:BlogconNE下一行
                        rem 这里if复合句不用cd，它会自动恢复(原因不明)而且用cd会报错
                        chcp 936 >nul
                        title Odyink User
                        color 07
                    echo b.上一篇 q.返回列表 n.下一篇
                    echo         r.刷新扩展
                    goto :BlogconNE
                ) else (
                    goto :VB
                )
            )
        rem 显示文本内容Text
            type Blog\%EBlognum%.txt
            echo.
            echo.
            echo b.上一篇 q.返回列表 n.下一篇
            echo         r.刷新文章
            echo.
        rem 文章操作
            :BlogconNE
            @echo off
            set Blogcon=
            set /p Blogcon=操作序号：
            if /i "%Blogcon%"=="b" goto :backBlog
            if /i "%Blogcon%"=="n" goto :nextBlog
            if /i "%Blogcon%"=="q" goto :VB
            if /i "%Blogcon%"=="r" goto :NBBlog
            echo 输入无效请重新输入
            echo.
            goto :BlogconNE
        rem 上一篇文章
            :backBlog
            set StartEBlognum=%EBlognum%
            cls
            echo 正在检索请稍后...
            :Back
            set /a EBlognum=%EBlognum%-1
            set /a AV=%StartEBlognum%-%EBlognum%
            call set NEBEB=%%NEB%EBlognum%%%
            if "%NEBEB%"=="E" goto :NBBlog
            rem 两文章间距不可大于100
            if %AV%==100 goto :NBBlog
            goto :Back
        rem 下一篇文章
            :nextBlog
            set StartEBlognum=%EBlognum%
            cls
            echo 正在检索请稍后...
            :Next
            set /a EBlognum=%EBlognum%+1
            set /a AV=%EBlognum%-%StartEBlognum%
            call set NEBEB=%%NEB%EBlognum%%%
            if "%NEBEB%"=="E" goto :NBBlog
            rem 两文章间距不可大于100
            if %AV%==100 goto :NBBlog
            goto :Next
rem 配置Odyink
    :setOdyink
    echo 配置Odyink
    set /p website=域名或IP[/目录]：
    echo 正在配置Odyink...
    if "%website:~-1%"=="/" set website=%website:~0,-1%
    mkdir odyink\Blog >nul
    cd odyink
    if exist Blog*.bat del Blog*.bat
    if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
    echo set website=%website% >website.bat
    cd ..\
    cls
    echo 配置完毕
    timeout /t 2 /nobreak >nul
    cls
    goto :check
rem 退出
    :ServerError
    echo 服务器出错
    :exit
    echo 正在退出Odyink...
    if exist index.html del index.html
    if exist Blog*.bat del Blog*.bat
    if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
    timeout /t 2 /nobreak >nul
    exit