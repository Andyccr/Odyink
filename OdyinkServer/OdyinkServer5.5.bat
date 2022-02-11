@echo off
rem 5.5
rem 初始化
    chcp 936 >nul
    title Odyink Server
    color 07
    cd /d %~dp0
    cls
    setlocal enabledelayedexpansion
rem 检测安装
    :Check
    if not exist odyink\Bloglist.bat goto :install
    cd odyink\
rem 菜单
    :menu
    cls
    echo 1.校阅文章
    echo 2.导入文章
    echo 3.删除文章
    echo 4.程序设置
    echo 5.退出程序
    echo.
    set Munum=none
    set /p Munum=序号：
    cls
    if "%Munum%"=="1" goto :VB
    if "%Munum%"=="2" goto :cpBlog
    if "%Munum%"=="3" goto :DBlog
    if "%Munum%"=="4" goto :setting
    if "%Munum%"=="5" ( cls & exit )
    echo 输入无效
    timeout /t 2 /nobreak >nul
    goto :menu
rem 校阅文章
    :VB
    title Odyink Server
    cls
    rem 文章列表
        call Bloglist.bat
        echo.
        echo.
        call Blognum.bat
        if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
        echo 目前有%Blognum%篇文章
        echo.
        echo q.返回主页
        set inputBlogNum=none
        set /p inputBlogNum=文章序号：
        cls
        if /i "%inputBlogNum%"=="q" goto :menu
    rem 浏览文章
        rem 预处理
            :NBBlog
            set Doctype=none
        rem 检测文章是否存在
            if not exist Blog\"%inputBlogNum%.bat" (
                if not exist Blog\"%inputBlogNum%.txt" (
                    echo 文章不存在
                    timeout /t 2 /nobreak >nul
                    goto :VB
                )
            )
        rem 显示文本内容Batch
            rem 因复合句中变量为复合句前的变量使用用延迟变量获得句中变量的动态值
            if exist Blog\"%inputBlogNum%.bat" (
                set Doctype=bat
                title Odyink Server
                echo 这是Batch扩展
                echo 可在odyink\Blog\%inputBlogNum%.bat中查看代码
                echo 因Batch扩展特殊性执行后果自负
                echo 查看代码是为了防病毒!!!
                echo.
                echo      y.确认执行 e.取消执行
                echo      c.编辑代码 t.更改标题
                echo   b.上一篇 q.返回列表 n.下一篇
                set batruncode=none
                set /p batruncode=操作序号:
                if /i "!batruncode!"=="b" goto :backBlog
                if /i "!batruncode!"=="n" goto :nextBlog
                if /i "!batruncode!"=="t" goto :changeTitle
                if /i "!batruncode!"=="c" (
                    notepad.exe .\Blog\%inputBlogNum%.!Doctype!
                    cls
                    goto :NBBlog
                )
                if /i "!batruncode!"=="y" (
                    cls
                    cmd /c .\Blog\%inputBlogNum%.bat
                    cls
                    rem 重新初始化
                        rem 这里if复合句不能用@echo off会报错现移到:BlogconNE下一行
                        rem 这里if复合句不用cd，它会自动恢复(原因不明)而且用cd会报错
                        chcp 936 >nul
                        title Odyink Server
                        color 07
                    echo   b.上一篇 q.返回列表 n.下一篇
                    echo c.编辑代码 t.更改标题 r.重新执行
                    goto :BlogconNE
                ) else (
                    goto :VB
                )
            )
        rem 显示文本内容Text
            set Doctype=txt
            title !title%inputBlogNum%!
            type Blog\%inputBlogNum%.txt
            echo.
            echo.
            echo b.上一篇 q.返回列表 n.下一篇
            echo     c.修改文章  t.更改标题
            echo.
        rem 文章操作
            :BlogconNE
            @echo off
            set Blogcon=none
            set /p Blogcon=操作序号：
            if /i "%Blogcon%"=="b" goto :backBlog
            if /i "%Blogcon%"=="n" goto :nextBlog
            if /i "%Blogcon%"=="q" goto :VB
            if /i "%Blogcon%"=="t" goto :changeTitle
            if /i "%Blogcon%"=="c" (
                notepad.exe .\Blog\%inputBlogNum%.%Doctype%
                cls
                goto :NBBlog
            )
            if /i "%Blogcon%"=="r" (
                if /i "%Doctype%"=="bat" (
                    cls
                    goto :NBBlog
                )
            )
            echo 输入无效
            echo.
            goto :BlogconNE
        rem 上一篇文章
            :backBlog
            set StartinputBlogNum=%inputBlogNum%
            cls
            :Back
            set /a inputBlogNum=%inputBlogNum%-1
            set /a AV=%StartinputBlogNum%-%inputBlogNum%
            rem 两文章间距不可大于100
            if %AV%==100 goto :NBBlog
            if %inputBlogNum%==-1 goto :NBBlog
            if exist Blog\%inputBlogNum%.bat goto :NBBlog
            if exist Blog\%inputBlogNum%.txt goto :NBBlog
            goto :Back
        rem 下一篇文章
            :nextBlog
            set StartinputBlogNum=%inputBlogNum%
            cls
            :Next
            set /a inputBlogNum=%inputBlogNum%+1
            set /a AV=%inputBlogNum%-%StartinputBlogNum%
            rem 两文章间距不可大于100
            if %AV%==100 goto :NBBlog
            if exist Blog\%inputBlogNum%.bat goto :NBBlog
            if exist Blog\%inputBlogNum%.txt goto :NBBlog
            goto :Next
        rem 更改标题
            :changeTitle
            cls
            echo 输入q退出
            set newTitle=!title%inputBlogNum%!
            set /p newTitle=新标题:
            echo set title%inputBlogNum%=%newTitle% >>Blogtitle.bat
            call Blogtitle.bat
            cls
            goto :NBBlog
rem 导入文章
    :cpBlog
    cls
    rem 输入需导入文章的信息
        echo 支持GBK编码的txt和bat文件
        echo 支持拖放文件(不要手贱)
        echo q.返回
        echo.
        rem 以管理员身份运行无法拖动导入文章
        set Docname=none
        set /p Docname=文件绝对路径：
        if %Docname%==q goto :menu
        if not exist %Docname% goto :CantcpBlog
        set Doctype=none
        if %Docname:~-4,-3%==. set Doctype=%Docname:~-3%
        if %Docname:~-5,-4%==. set Doctype=%Docname:~-4,-1%
        if /i not "%Doctype%"=="bat" (
            if /i not "%Doctype%"=="txt" (
                echo 文件不支持
                timeout /t 3 /nobreak >nul
                goto :cpBlog
            )
        )
        rem 文章标题不能含有英引号
        echo 文章标题不能含有奇数引号
        echo 若文件名是标题请直接回车
        set newBlogtitle=none
        set /p newBlogtitle=文章标题：
        if /i "%newBlogtitle%"=="q" goto :cpBlog
        if "%newBlogtitle%"=="none" call :GetDocName %Docname%
        goto :jump1
            :GetDocName
                set newBlogtitle=%~n1
                goto :eof
        :jump1
    rem 预览文章(Text)
        rem 为了确认是否为GB*编码
        if /i "%Doctype%"=="txt" (
            cls
            type %Docname%
            echo.
            echo.
            echo 如果文章显示正常 "回车" 开始导入
            echo 如果异常输入"q"退出并检查文章及其编码
            set addTextCheck=none
            set /p addTextCheck=请输入:
            if /i "!addTextCheck!"=="none" (
                rem 占位
            ) else (
                goto :cpBlog
            )
        )
    rem 开始导入文章
        cls
        rem 预处理
            set Blognum=none
            call Blognum.bat
            if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
            set NewBlognum=none
            set /a NewBlognum=%Blognum%+1
            call BlogAnum.bat
            if "%BlogAnum:~-1%"==" " set BlogAnum=%BlogAnum:~0,-1%
            set /a NewBlogAnum=%BlogAnum%+1
        rem 写入
            rem 写入新配置
                echo set Blognum=%NewBlognum% >Blognum.bat
                echo set BlogAnum=%NewBlogAnum% >BlogAnum.bat
                echo set NEB%NewBlogAnum%=E>>Blogexist.bat
                echo set title%NewBlogAnum%=%newBlogtitle% >>Blogtitle.bat
                echo if not %%NEB%NewBlogAnum%%%==Del echo %NewBlogAnum%.%%title%NewBlogAnum%%% >>Bloglist.bat
            rem 写入日志
                echo %date:~0,-2%%time% copy %Docname% to .\odyink\Blog\ (num:%NewBlogAnum%) >>Bloglog.log
            rem 复制文章
                if exist %Docname% copy %Docname% Blog\%NewBlogAnum%.%Doctype% >nul
            echo 导入完毕
            timeout /t 2 /nobreak >nul
            goto :cpBlog
    rem 文章不存在
        :CantcpBlog
        cls
        echo 文章不存在
        timeout /t 3 /nobreak >nul
        goto :cpBlog
rem 删除文章
    :DBlog
    cls
    call Bloglist.bat
    set Blognum=none
    call Blognum.bat
    rem 输入需删除文章的信息
        :DelBlog
        echo 输入q退出删除
        set willDelBlog=none
        set /p willDelBlog=要删除文章序号：
        if /i "%willDelBlog%"=="q" goto :menu
        if not exist Blog\"%willDelBlog%.*t" goto :DelBlogE
        :BackDelyn
        set DelBlogyn=none
        set /p DelBlogyn=是否删除yn:
        if /i "%DelBlogyn%"=="y" goto :DelBlognow
        if /i "%DelBlogyn%"=="n" goto :DelBlog
        echo 输入无效
        goto :BackDelyn
    rem 开始删除文章
        :DelBlognow
        echo set NEB%willDelBlog%=Del >>Blogdel.bat
        set /a NewBlognum=%Blognum%-1
        echo set Blognum=%NewBlognum% >Blognum.bat
        echo %date:~0,-2%%time% del %willDelBlog% from .\odyink\Blog\ (num:%willDelBlog%) >>Bloglog.log
        del /q Blog\%willDelBlog%.*t
        echo 删除完毕
        timeout /t 2 /nobreak >nul
        cls
        goto :DBlog
    rem 文章不存在
        :DelBlogE
        echo 文章不存在
        goto :DelBlog
rem 设置
    :setting
    cls
    echo d.卸载软件
    echo q.返回主页
    echo.
    set inputSettingNum=none
    set /p inputSettingNum=请输入:
    if /i "%inputSettingNum%"=="d" goto :removeOdyink
    if /i "%inputSettingNum%"=="q" goto :menu
    cls
    echo 输入无效
    timeout /t 2 /nobreak >nul
    goto :setting
rem 卸载
    :removeOdyink
    cls
    echo 输入yes并回车以确认卸载Odyink
    echo 输入其他皆为取消卸载
    set delOdyinkyn=none
    set /p delOdyinkyn=请输入:
    if /i not "%delOdyinkyn%"=="yes" goto :setting
    cls
    echo 卸载将在60秒后开始
    echo 您可以回车以立即卸载
    echo 也可以关闭程序中断卸载
    timeout /t 60 >nul
    cd /d %~p0
    rmdir /s /q %~p0odyink\
    del /f /s /q %~f0 & exit
    exit
rem 安装
    :install
    echo 回车安装Odyink
    pause >nul
    cls
    mkdir odyink\Blog 2>nul
    cd Odyink
    if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
    rem 新建文件写入信息
        echo set Blognum=1 >Blognum.bat
        echo set BlogAnum=0 >BlogAnum.bat
        echo set NEB0=E>>Blogexist.bat
        echo set title0=欢迎使用Odyink >Blogtitle.bat
        echo call Blogexist.bat >>Bloglist.bat
        echo call Blogdel.bat>>Bloglist.bat
        echo call Blogtitle.bat>>Bloglist.bat
        echo if not %%NEB0%%==Del echo 0.%%title0%%>>Bloglist.bat
        echo rem Blogdel>Blogdel.bat
        echo [Bloglog]>Bloglog.log
        echo Odyink是由Andy(python)和SMG(Batch)制作的命令行个人博客软件 >>Blog\0.txt
    echo 安装完毕
    timeout /t 2 /nobreak >nul
    cls
    echo 设置网站路径为：%~dp0odyink\
    echo 回车结束安装
    pause >nul
    %0