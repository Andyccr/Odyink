@echo off
rem 6.0
rem 初始化
    chcp 936 >nul
    title Odyink Server
    color 07
    cd /d %~dp0
    cls
    setlocal enabledelayedexpansion
rem 检测安装
    :Check
    if not exist odyink\doclist.bat goto :Install
    cd odyink\
rem 校阅文章
    :ViewDoc
    cls
    title Odyink Server
    rem 文章列表
        call doclist.bat
        echo.
        echo.
        call docnum.bat
        if "%docNum:~-1%"==" " set docNum=%docNum:~0,-1%
        echo 目前有%docNum%篇文章
        echo.
        if /i "%inputDocNum%"=="d" goto :DelDoc
        echo a.导入文章 d.删除文章
        echo s.程序设置 q.退出程序
        set inputDocNum=none
        set /p inputDocNum=文章序号：
        cls
        if /i "%inputDocNum%"=="a" goto :AddDoc
        if /i "%inputDocNum%"=="d" goto :ViewDoc
        if /i "%inputDocNum%"=="s" goto :Setting
        if /i "%inputDocNum%"=="q" ( cls & exit )
    rem 浏览文章
        rem 预处理
            :NextBackDoc
            set docType=none
        rem 检测文章是否存在
            if not exist doc\"%inputDocNum%.bat" (
                if not exist doc\"%inputDocNum%.txt" (
                    echo 文章不存在
                    timeout /t 2 /nobreak >nul
                    goto :ViewDoc
                )
            )
        rem 显示文本内容Batch
            rem 因复合句中变量为复合句前的变量使用用延迟变量获得句中变量的动态值
            if exist doc\"%inputDocNum%.bat" (
                set docType=bat
                title Odyink Server
                echo 这是Batch扩展
                echo 可在odyink\doc\%inputDocNum%.bat中查看代码
                echo 因Batch扩展特殊性执行后果自负
                echo 查看代码是为了防病毒!!!
                echo.
                echo     y.确认执行  q.返回列表
                echo     c.编辑代码  t.更改标题
                echo       b.上一篇  n.下一篇
                set batActCode=none
                set /p batActCode=操作序号:
                if /i "!batActCode!"=="b" goto :BackDoc
                if /i "!batActCode!"=="n" goto :NextDoc
                if /i "!batActCode!"=="t" goto :ChangeTitle
                if /i "!batActCode!"=="c" (
                    notepad.exe .\doc\%inputDocNum%.!docType!
                    cls
                    goto :NextBackDoc
                )
                if /i "!batActCode!"=="y" (
                    cls
                    cmd /c .\doc\%inputDocNum%.bat
                    cls
                    rem 重新初始化
                        rem 这里if复合句不能用@echo off会报错现移到:DocActInput下一行
                        rem 这里if复合句不用cd，它会自动恢复(原因不明)而且用cd会报错
                        chcp 936 >nul
                        title Odyink Server
                        color 07
                    echo   b.上一篇 q.返回列表 n.下一篇
                    echo c.编辑代码 t.更改标题 r.重新执行
                    goto :DocActInput
                ) else (
                    goto :ViewDoc
                )
            )
        rem 显示文本内容Text
            set docType=txt
            title !title%inputDocNum%!
            type doc\%inputDocNum%.txt
            echo.
            echo.
            echo b.上一篇 q.返回列表 n.下一篇
            echo     c.修改文章  t.更改标题
            echo.
        rem 文章操作
            :DocActInput
            @echo off
            set docActCode=none
            set /p docActCode=操作序号：
            if /i "%docActCode%"=="b" goto :BackDoc
            if /i "%docActCode%"=="n" goto :NextDoc
            if /i "%docActCode%"=="q" goto :ViewDoc
            if /i "%docActCode%"=="t" goto :ChangeTitle
            if /i "%docActCode%"=="c" (
                notepad.exe .\doc\%inputDocNum%.%docType%
                cls
                goto :NextBackDoc
            )
            if /i "%docActCode%"=="r" (
                if /i "%docType%"=="bat" (
                    cls
                    goto :NextBackDoc
                )
            )
            echo 输入无效
            echo.
            goto :DocActInput
        rem 上一篇文章
            :BackDoc
            set startInputDocNum=%inputDocNum%
            cls
            :Back
            set /a inputDocNum=%inputDocNum%-1
            set /a AV=%startInputDocNum%-%inputDocNum%
            rem 两文章间距不可大于100
            if %AV%==100 goto :NextBackDoc
            if %inputDocNum%==-1 goto :NextBackDoc
            if exist doc\%inputDocNum%.bat goto :NextBackDoc
            if exist doc\%inputDocNum%.txt goto :NextBackDoc
            goto :Back
        rem 下一篇文章
            :NextDoc
            set startInputDocNum=%inputDocNum%
            cls
            :Next
            set /a inputDocNum=%inputDocNum%+1
            set /a AV=%inputDocNum%-%startInputDocNum%
            rem 两文章间距不可大于100
            if %AV%==100 goto :NextBackDoc
            if exist doc\%inputDocNum%.bat goto :NextBackDoc
            if exist doc\%inputDocNum%.txt goto :NextBackDoc
            goto :Next
        rem 更改标题
            :ChangeTitle
            cls
            echo 输入q退出
            echo 回车为原标题:!title%inputDocNum%!
            set newTitle=!title%inputDocNum%!
            set /p newTitle=新标题:
            if /i "%newTitle%"=="q" goto :NextBackDoc
            echo set title%inputDocNum%=%newTitle% >>doctitle.bat
            call doctitle.bat
            cls
            goto :NextBackDoc
rem 导入文章
    :AddDoc
    cls
    rem 输入需导入文章的信息
        echo 支持GB*编码的txt和bat文件
        echo 支持拖放文件(不要手贱)
        echo q.返回
        echo.
        rem 以管理员身份运行无法拖动导入文章
        set docPath=none
        set /p docPath=文件绝对路径：
        if %docPath%==q goto :ViewDoc
        if not exist %docPath% goto :NotExistDoc
        rem 文章属性获取及设置
            set docType=none
            if %docPath:~-4,-3%==. set docType=%docPath:~-3%
            if %docPath:~-5,-4%==. set docType=%docPath:~-4,-1%
            if /i not "%docType%"=="bat" (
                if /i not "%docType%"=="txt" (
                    echo 文件不支持
                    timeout /t 3 /nobreak >nul
                    goto :AddDoc
                )
            )
            if /i "%docType%"=="txt" set docType=txt
            if /i "%docType%"=="bat" set docType=bat
        rem 文章标题不能含有英引号
        echo 文章标题不能含有奇数引号
        echo 若文件名是标题请直接回车
        set newDocTitle=none
        set /p newDocTitle=文章标题：
        if /i "%newDocTitle%"=="q" goto :AddDoc
        if "%newDocTitle%"=="none" call :GetDocName %docPath%
        goto :Jump1
            :GetDocName
                set newDocTitle=%~n1
                goto :eof
        :Jump1
    rem 预览文章(Text)
        rem 为了确认是否为GB*编码
        if /i "%docType%"=="txt" (
            cls
            type %docPath%
            echo.
            echo.
            echo 如果文章显示正常 "回车" 开始导入
            echo 如果异常输入"q"退出并检查文章及其编码
            set addTextCheck=none
            set /p addTextCheck=请输入:
            if /i "!addTextCheck!"=="none" (
                rem 占位
            ) else (
                goto :AddDoc
            )
        )
    rem 开始导入文章
        cls
        rem 预处理
            set docNum=none
            call docnum.bat
            if "%docNum:~-1%"==" " set docNum=%docNum:~0,-1%
            set newDocNum=none
            set /a newDocNum=%docNum%+1
            call docallnum.bat
            if "%docAllnum:~-1%"==" " set docAllnum=%docAllnum:~0,-1%
            set /a newDocAllNum=%docAllnum%+1
        rem 写入
            rem 写入新配置
                echo set docNum=%newDocNum% >docnum.bat
                echo set docAllnum=%newDocAllNum% >docallnum.bat
                echo set NEB%newDocAllNum%=E>>docexist.bat
                echo set title%newDocAllNum%=%newDocTitle% >>doctitle.bat
                echo if not %%NEB%newDocAllNum%%%==Del echo %newDocAllNum%.%%title%newDocAllNum%%% >>doclist.bat
            rem 写入日志
                echo %date:~0,-2%%time% copy %docPath% to .\odyink\doc\ (num:%newDocAllNum%) >>doclog.log
            rem 复制文章
                if exist %docPath% copy %docPath% doc\%newDocAllNum%.%docType% >nul
                if exist doc\%newDocAllNum%.%docType% (
                    echo 导入成功
                ) else (
                    echo 导入失败
                )
            timeout /t 2 /nobreak >nul
            goto :AddDoc
    rem 文章不存在
        :NotExistDoc
        cls
        echo 文章不存在
        timeout /t 3 /nobreak >nul
        goto :AddDoc
rem 删除文章
    :DelDoc
    set docNum=none
    call docnum.bat
    rem 输入需删除文章的信息
        :InputDelDocNum
        echo 输入q退出删除
        set willDelDocNum=none
        set /p willDelDocNum=要删除文章序号：
        if /i "%willDelDocNum%"=="q" (
            set inputDocNum=none
            goto :ViewDoc
        )
        if not exist doc\"%willDelDocNum%.*t" goto :DelDocError
        :BackDelyn
        set delDocyn=none
        set /p delDocyn=是否删除yn:
        if /i "%delDocyn%"=="y" goto :DelDocNow
        if /i "%delDocyn%"=="n" goto :InputDelDocNum
        echo 输入无效
        goto :BackDelyn
    rem 开始删除文章
        :DelDocNow
        echo set NEB%willDelDocNum%=Del >>docdel.bat
        set /a newDocNum=%docNum%-1
        echo set docNum=%newDocNum% >docnum.bat
        echo %date:~0,-2%%time% del %willDelDocNum% from .\odyink\doc\ (num:%willDelDocNum%) >>doclog.log
        del /q doc\%willDelDocNum%.*t
        echo 删除完毕
        timeout /t 2 /nobreak >nul
        cls
        goto :ViewDoc
    rem 文章不存在
        :DelDocError
        echo 文章不存在
        goto :InputDelDocNum
rem 设置
    :Setting
    cls
    echo c.清除数据
    echo d.卸载软件
    echo q.返回主页
    echo.
    set inputSettingNum=none
    set /p inputSettingNum=请输入:
    if /i "%inputSettingNum%"=="c" goto :CleanData
    if /i "%inputSettingNum%"=="d" goto :RemoveOdyink
    if /i "%inputSettingNum%"=="q" goto :ViewDoc
    cls
    echo 输入无效
    timeout /t 2 /nobreak >nul
    goto :Setting
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
rem 清除数据
    :CleanData
    cls
    echo 输入yes并回车以确认清除数据
    echo 输入其他皆为取消
    set cleanOdyinkyn=none
    set /p cleanOdyinkyn=请输入:
    if /i not "%cleanOdyinkyn%"=="yes" goto :Setting
    cls
    echo 输入yes并回车再次确认
    echo 输入其他皆为取消
    set cleanOdyinkyn=none
    set /p cleanOdyinkyn=请输入:
    if /i not "%cleanOdyinkyn%"=="yes" goto :Setting
    cd /d %~p0
    rmdir /s /q %~p0odyink\
    echo 输入re从零开始的异世界生活
    cls
    echo 输入re从零开始
    echo 回车退出
    set reOrNot=none
    set /p reOrNot=
    cls
    if /i "%reOrNot%"=="re从零开始的异世界生活" start https://www.bilibili.com/bangumi/play/ep373924
    if /i "%reOrNot%"=="re" (
        cmd /c %~f0
    ) else (
        exit
    )
rem 安装
    :Install
    echo 回车安装Odyink
    pause >nul
    cls
    mkdir odyink\doc 2>nul
    cd odyink\
    if exist doc\*.*t del /f /s /q doc\*.*t >nul
    rem 新建文件写入信息
        echo set docNum=1 >docnum.bat
        echo set docAllnum=0 >docallnum.bat
        echo set NEB0=E>>docexist.bat
        echo set title0=欢迎使用Odyink >doctitle.bat
        echo call docexist.bat >>doclist.bat
        echo call docdel.bat>>doclist.bat
        echo call doctitle.bat>>doclist.bat
        echo if not %%NEB0%%==Del echo 0.%%title0%%>>doclist.bat
        echo rem Docdel>docdel.bat
        echo [Doclog]>doclog.log
        echo Odyink是由Andy(python)和SMG(Batch)制作的命令行个人博客软件 >>doc\0.txt
    echo 安装完毕
    timeout /t 2 /nobreak >nul
    cls
    echo 设置网站路径为：%~dp0odyink\
    echo 回车结束安装
    pause >nul
    %0