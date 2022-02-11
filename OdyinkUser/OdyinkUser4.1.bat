@echo off
rem 4.1
rem 初始化环境
    chcp 936 >nul
    title Odyink User
    color 07
    cd /d %~dp0
    cls
rem 检测
    :check
    rem 检测配置
        if not exist odyink\website.bat goto :setOdyink
        cd odyink\
    rem 检测设置下载器
        if exist ..\wget.exe copy ..\wget.exe .\wget.exe
        rem 为兼容性不查证书(不安全)
        set WO=-q --no-check-certificate -P ./
        set wget=PowerShell Invoke-WebRequest
        set PSO=-outfile
rem 看文章
    rem 下载列表
        :get
        cls
        echo 正在下载列表请稍后...
        call website.bat
        if "%website:~-1%"==" " set website=%website:~0,-1%
        rem 删除旧文件
            if exist index.html del index.html
            if exist Blog*.bat del Blog*.bat
            if exist exdoc.bat del exdoc.bat
            if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
        rem 下载新列表文件
            echo 正在下载Bloglist.bat
                %wget% %website%/Bloglist.bat %PSO% Bloglist.bat
                if not exist Bloglist.bat wget %WO% %website%/Bloglist.bat
                if not exist Bloglist.bat goto :ServerError
            echo 正在下载Blognum.bat
                %wget% %website%/Blognum.bat%PSO% Blognum.bat
                if not exist Blognum.bat wget %WO% %website%/Blognum.bat
                if not exist Blognum.bat goto :ServerError
            echo 正在下载Blogexist.bat
                %wget% %website%/Blogexist.bat%PSO% Blogexist.bat
                if not exist Blogexist.bat wget %WO% %website%/Blogexist.bat
                if not exist Blogexist.bat goto :ServerError
            echo 正在下载Blogdel.bat
                %wget% %website%/Blogdel.bat%PSO% Blogdel.bat
                if not exist Blogdel.bat wget %WO% %website%/Blogdel.bat
                if not exist Blogdel.bat goto :ServerError
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
            set findExistBlog=
            if "%EBlognum:~-1%"==" " set EBlognum=%EBlognum:~0,-1%
            if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
            cls
        rem 下载文章
            echo 下载文章中
                %wget% %website%/Blog/%EBlognum%.bat %PSO% .\Blog\%EBlognum%.bat
                if not exist %EBlognum%.bat wget %WO%Blog/ /Blog/%EBlognum%.bat
                %wget% %website%/Blog/%EBlognum%.txt %PSO% .\Blog\%EBlognum%.txt
                if not exist %EBlognum%.txt wget %WO%Blog/ /Blog/%EBlognum%.txt
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
                        rem 这里if复合句不用@echo off和cd，它会自动恢复(原因不明)一用就会报错
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
            call set findExistBlog=%%NEB%EBlognum%%%
            if "%findExistBlog%"=="E" goto :NBBlog
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
            call set findExistBlog=%%NEB%EBlognum%%%
            if "%findExistBlog%"=="E" goto :NBBlog
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