@echo off
rem 6.0
rem 初始化
    chcp 936 >nul
    title Odyink User
    color 07
    cd /d %~dp0
    cls
    setlocal enabledelayedexpansion
rem 检测
    :check
    rem 检测配置
        if not exist odyink\website.bat goto :SetOdyink
        cd odyink\
    rem 检测设置下载器
        if exist ..\wget.exe copy ..\wget.exe .\wget.exe >nul
        rem 为兼容性不查证书(不安全)
        set WO=-q --no-check-certificate -P ./
        set pswget=PowerShell Invoke-WebRequest
        set PSO=-outfile
rem 看文章
    rem 下载列表
        :Get
        cls
        echo 正在下载列表请稍后...
        call website.bat
        if "%website:~-1%"==" " set website=%website:~0,-1%
        rem 删除旧文件
            if exist doc*.bat del doc*.bat
            if exist doc\*.*t del /f /s /q doc\*.*t >nul
        rem 下载新列表文件
            set net=ok
            echo 正在下载doclist.bat
                wget %WO% %website%/doclist.bat 2>nul
                if not exist doclist.bat %pswget% %website%/doclist.bat %PSO% doclist.bat >nul
                if not exist doclist.bat (
                    set net=error
                    goto :ViewDoc
                )
            echo 正在下载docnum.bat
                wget %WO% %website%/docnum.bat 2>nul
                if not exist docnum.bat %pswget% %website%/docnum.bat %PSO% docnum.bat >nul
                if not exist docnum.bat (
                    set net=error
                    goto :ViewDoc
                )
            echo 正在下载docexist.bat
                wget %WO% %website%/docexist.bat 2>nul
                if not exist docexist.bat %pswget% %website%/docexist.bat %PSO% docexist.bat >nul
                if not exist docexist.bat (
                    set net=error
                    goto :ViewDoc
                )
            echo 正在下载docdel.bat
                wget %WO% %website%/docdel.bat 2>nul
                if not exist docdel.bat %pswget% %website%/docdel.bat %PSO% docdel.bat >nul
                if not exist docdel.bat (
                    set net=error
                    goto :ViewDoc
                )
            echo 正在下载doctitle.bat
                wget %WO% %website%/doctitle.bat 2>nul
                if not exist doctitle.bat %pswget% %website%/doctitle.bat %PSO% doctitle.bat >nul
                if not exist doctitle.bat (
                    set net=error
                    goto :ViewDoc
                )
        cls
    rem 文章列表
        :ViewDoc
        title Odyink User
        cls
        if /i "%net%"=="ok" (
            call doclist.bat
        ) else (
            echo 网络出错
        )
        echo.
        echo.
        set docNum=0
        if /i "%net%"=="ok" call docnum.bat
        if "%docNum:~-1%"==" " set docNum=%docNum:~0,-1%
        echo 目前有%docNum%篇文章
        echo.
        echo r.刷新 q.退出
        echo  s.程序设置
        set inputDocNum=none
        set /p inputDocNum=文章序号：
        cls
        if /i "%inputDocNum%"=="r" goto :Get
        if /i "%inputDocNum%"=="q" goto :Exit
        if /i "%inputDocNum%"=="s" goto :Setting
    rem 下载浏览文章
        rem 预处理
            :NextBackDoc
            cls
            if "%inputDocNum:~-1%"==" " set inputDocNum=%inputDocNum:~0,-1%
            if exist doc\*.*t del /f /s /q doc\*.*t >nul
            cls
        rem 下载文章
            echo 下载文章中
                wget %WO%doc/ %website%/doc/%inputDocNum%.bat 2>nul
                if not exist %inputDocNum%.bat %pswget% %website%/doc/%inputDocNum%.bat %PSO% .\doc\%inputDocNum%.bat >nul
                wget %WO%doc/ %website%/doc/%inputDocNum%.txt 2>nul
                if not exist %inputDocNum%.txt %pswget% %website%/doc/%inputDocNum%.txt %PSO% .\doc\%inputDocNum%.txt >nul
            cls
        rem 检测文章是否存在
            if not exist doc\"%inputDocNum%.bat" (
                if not exist doc\"%inputDocNum%.txt" (
                    echo 文章不存在
                    timeout /t 2 /nobreak >nul
                    goto :ViewDoc
                )
            )
        rem 显示文本内容Batch
            rem 因复合句中变量为复合句前的变量,使用用延迟变量获得句中变量的动态值
            if exist doc\"%inputDocNum%.bat" (
                title Odyink User
                echo 这是Batch扩展
                echo 可在odyink\doc\%inputDocNum%.bat中查看代码
                echo 因Batch扩展特殊性执行后果自负
                echo 查看代码是为了防病毒!!!
                echo.
                echo y.确认执行 q.返回列表
                echo   b.上一篇 n.下一篇
                set batActCode=none
                set /p batActCode=操作序号:
                if /i "!batActCode!"=="b" goto :BackDoc
                if /i "!batActCode!"=="n" goto :NextDoc
                if /i "!batActCode!"=="y" (
                    cls
                    cmd /c .\doc\%inputDocNum%.bat
                    cls
                    rem 重新初始化
                        rem 这里if复合句不用@echo off和cd，它会自动恢复(原因不明)一用就会报错
                        chcp 936 >nul
                        title Odyink User
                        color 07
                    echo b.上一篇 q.返回列表 n.下一篇
                    echo          r.刷新扩展
                    goto :DocActInput
                ) else (
                    goto :ViewDoc
                )
            )
        rem 显示文本内容Text
            :ViewText
            type doc\%inputDocNum%.txt
            title !title%inputDocNum%!
            echo.
            echo.
            echo b.上一篇 q.返回列表 n.下一篇
            echo     r.刷新文章  s.保存文章
            echo.
        rem 文章操作
            :DocActInput
            set docActCode=none
            set /p docActCode=操作序号：
            if /i "%docActCode%"=="b" goto :BackDoc
            if /i "%docActCode%"=="n" goto :NextDoc
            if /i "%docActCode%"=="q" goto :ViewDoc
            if /i "%docActCode%"=="r" goto :NextBackDoc
            if /i "%docActCode%"=="s"  (
                if exist doc\%inputDocNum%.txt (
                    set getTureTitle=!title%inputDocNum%!
                    if "!getTureTitle:~-1!"==" " set getTureTitle=!getTureTitle:~0,-1!
                    copy doc\%inputDocNum%.txt "%homeDrive%%homePath%\downloads\!getTureTitle!.txt" >nul
                    if exist %homeDrive%%homePath%\downloads\!getTureTitle!.txt (
                        cls
                        echo 保存成功
                        echo 已保存至 "下载" 文件夹
                        timeout /t 5 /nobreak >nul
                        cls
                        goto :ViewText
                    ) else (
                        cls
                        echo 保存失败
                        timeout /t 2 /nobreak >nul
                        cls
                        goto :ViewText
                    )
                )
            )
            echo 输入无效请重新输入
            echo.
            goto :DocActInput
        rem 上一篇文章
            :BackDoc
            set startInputDocNum=%inputDocNum%
            cls
            echo 正在检索请稍后...
            :Back
            set /a inputDocNum=%inputDocNum%-1
            set /a AV=%startInputDocNum%-%inputDocNum%
            if "!NEB%inputDocNum%!"=="E" goto :NextBackDoc
            rem 两文章间距不可大于100
            if %AV%==100 goto :NextBackDoc
            goto :Back
        rem 下一篇文章
            :NextDoc
            set startInputDocNum=%inputDocNum%
            cls
            echo 正在检索请稍后...
            :Next
            set /a inputDocNum=%inputDocNum%+1
            set /a AV=%inputDocNum%-%startInputDocNum%
            if "!NEB%inputDocNum%!"=="E" goto :NextBackDoc
            rem 两文章间距不可大于100
            if %AV%==100 goto :NextBackDoc
            goto :Next
rem 设置
    :Setting
    cls
    echo u.检查更新
    echo c.更改网址
    echo d.卸载软件
    echo q.返回列表
    echo.
    set inputSettingNum=none
    set /p inputSettingNum=请输入:
    if /i "%inputSettingNum%"=="u" goto :Update
    if /i "%inputSettingNum%"=="d" goto :RemoveOdyink
    if /i "%inputSettingNum%"=="c" goto :ChangeWebsite
    if /i "%inputSettingNum%"=="q" goto :ViewDoc
    cls
    echo 输入无效
    timeout /t 2 /nobreak >nul
    goto :Setting
rem 更改网址
    :ChangeWebsite
    cls
    set newWebsite=none
    set /p newWebsite=新网址{域名或IP[/目录]}:
    if "%newWebsite:~-1%"=="/" set newWebsite=%newWebsite:~0,-1%
    set changeWebsiteyn=none
    set /p changeWebsiteyn=是否更新yn:
    if /i "%changeWebsiteyn%"=="y" (
        echo set website=%newWebsite% >website.bat
        cmd /c %0
        exit
    ) else (
        goto :Setting
    )
rem 卸载
    :RemoveOdyink
    cls
    echo 输入yes并回车以确认卸载Odyink
    echo 输入其他皆为取消卸载
    set delOdyinkyn=none
    set /p delOdyinkyn=请输入:
    if /i not "%delOdyinkyn%"=="yes" goto :Setting
    cls
    echo 卸载将在60秒后开始
    echo 您可以回车以立即卸载
    echo 也可以关闭程序中断卸载
    timeout /t 60 >nul
    cd /d %~p0
    rmdir /s /q %~p0odyink\
    del /f /s /q %~f0 & exit
    exit
rem 检查更新
    :Update
    cls
    cd ..\
    if exist Update.bat del /f Update.bat
    rem 设置更新源(结尾无斜杠)
    set updateWebsite=https://odyink-1302226504.cos.accelerate.myqcloud.com
    echo 正在检查更新
    wget %WO% %updateWebsite%/Update.bat 2>nul
    if not exist Update.bat %pswget% %updateWebsite%/Update.bat %PSO% Update.bat >nul
    cls
    if not exist Update.bat (
        echo 检查更新出错
        cd .\odyink\
        timeout /t 2 /nobreak >nul
        cls
        goto :Setting
    )
    set updateYN=
    call Update.bat
    rem 当前版本(整数)
    set version=6
    if %latestVersion% gtr %version% (
        echo 存在最新版本%latestVersion%
        echo 输入y确认更新其他键退出
        set updateYN=
        set /p updateYN=请输入:
        if /i "!updateYN!"=="y" (
            rem y是参数%1 %updateWebsite%是参数%2 %~nx1(包含后缀名的文件名)是参数%3
            start Update.bat y %updateWebsite% %~nx0
            exit
            ) else (
                if exist Update.bat del /f Update.bat
                cd .\odyink\
                set updateYN=
                goto :Setting
            )
    ) else (
        echo 当前已是最新版本
        if exist Update.bat del /f Update.bat
        cd .\odyink\
        timeout /t 2 /nobreak >nul
        cls
        goto :Setting
    )
rem 配置Odyink
    :SetOdyink
    echo 配置Odyink
        set website=https://ody.ink
        set /p website=域名或IP[/目录]：
        if "%website:~-1%"=="/" set website=%website:~0,-1%
    echo 正在配置Odyink...
        mkdir odyink\doc 2>nul
        cd odyink\
        if exist doc*.bat del doc*.bat
        if exist doc\*.*t del /f /s /q doc\*.*t >nul
        echo set website=%website% >website.bat
        cls
    echo 配置完毕
    timeout /t 2 /nobreak >nul
    %0
rem 退出
    :Exit
    echo 正在退出Odyink...
    if exist doc*.bat del doc*.bat
    if exist doc\*.*t del /f /s /q doc\*.*t >nul
    timeout /t 2 /nobreak >nul
    cls
    exit