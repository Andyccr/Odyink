@echo off
rem 5.5
rem ��ʼ��
    chcp 936 >nul
    title Odyink Server
    color 07
    cd /d %~dp0
    cls
    setlocal enabledelayedexpansion
rem ��ⰲװ
    :Check
    if not exist odyink\Bloglist.bat goto :install
    cd odyink\
rem �˵�
    :menu
    cls
    echo 1.У������
    echo 2.��������
    echo 3.ɾ������
    echo 4.��������
    echo 5.�˳�����
    echo.
    set Munum=none
    set /p Munum=��ţ�
    cls
    if "%Munum%"=="1" goto :VB
    if "%Munum%"=="2" goto :cpBlog
    if "%Munum%"=="3" goto :DBlog
    if "%Munum%"=="4" goto :setting
    if "%Munum%"=="5" ( cls & exit )
    echo ������Ч
    timeout /t 2 /nobreak >nul
    goto :menu
rem У������
    :VB
    title Odyink Server
    cls
    rem �����б�
        call Bloglist.bat
        echo.
        echo.
        call Blognum.bat
        if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
        echo Ŀǰ��%Blognum%ƪ����
        echo.
        echo q.������ҳ
        set inputBlogNum=none
        set /p inputBlogNum=������ţ�
        cls
        if /i "%inputBlogNum%"=="q" goto :menu
    rem �������
        rem Ԥ����
            :NBBlog
            set Doctype=none
        rem ��������Ƿ����
            if not exist Blog\"%inputBlogNum%.bat" (
                if not exist Blog\"%inputBlogNum%.txt" (
                    echo ���²�����
                    timeout /t 2 /nobreak >nul
                    goto :VB
                )
            )
        rem ��ʾ�ı�����Batch
            rem �򸴺Ͼ��б���Ϊ���Ͼ�ǰ�ı���ʹ�����ӳٱ�����þ��б����Ķ�ֵ̬
            if exist Blog\"%inputBlogNum%.bat" (
                set Doctype=bat
                title Odyink Server
                echo ����Batch��չ
                echo ����odyink\Blog\%inputBlogNum%.bat�в鿴����
                echo ��Batch��չ������ִ�к���Ը�
                echo �鿴������Ϊ�˷�����!!!
                echo.
                echo      y.ȷ��ִ�� e.ȡ��ִ��
                echo      c.�༭���� t.���ı���
                echo   b.��һƪ q.�����б� n.��һƪ
                set batruncode=none
                set /p batruncode=�������:
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
                    rem ���³�ʼ��
                        rem ����if���Ͼ䲻����@echo off�ᱨ�����Ƶ�:BlogconNE��һ��
                        rem ����if���Ͼ䲻��cd�������Զ��ָ�(ԭ����)������cd�ᱨ��
                        chcp 936 >nul
                        title Odyink Server
                        color 07
                    echo   b.��һƪ q.�����б� n.��һƪ
                    echo c.�༭���� t.���ı��� r.����ִ��
                    goto :BlogconNE
                ) else (
                    goto :VB
                )
            )
        rem ��ʾ�ı�����Text
            set Doctype=txt
            title !title%inputBlogNum%!
            type Blog\%inputBlogNum%.txt
            echo.
            echo.
            echo b.��һƪ q.�����б� n.��һƪ
            echo     c.�޸�����  t.���ı���
            echo.
        rem ���²���
            :BlogconNE
            @echo off
            set Blogcon=none
            set /p Blogcon=������ţ�
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
            echo ������Ч
            echo.
            goto :BlogconNE
        rem ��һƪ����
            :backBlog
            set StartinputBlogNum=%inputBlogNum%
            cls
            :Back
            set /a inputBlogNum=%inputBlogNum%-1
            set /a AV=%StartinputBlogNum%-%inputBlogNum%
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NBBlog
            if %inputBlogNum%==-1 goto :NBBlog
            if exist Blog\%inputBlogNum%.bat goto :NBBlog
            if exist Blog\%inputBlogNum%.txt goto :NBBlog
            goto :Back
        rem ��һƪ����
            :nextBlog
            set StartinputBlogNum=%inputBlogNum%
            cls
            :Next
            set /a inputBlogNum=%inputBlogNum%+1
            set /a AV=%inputBlogNum%-%StartinputBlogNum%
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NBBlog
            if exist Blog\%inputBlogNum%.bat goto :NBBlog
            if exist Blog\%inputBlogNum%.txt goto :NBBlog
            goto :Next
        rem ���ı���
            :changeTitle
            cls
            echo ����q�˳�
            set newTitle=!title%inputBlogNum%!
            set /p newTitle=�±���:
            echo set title%inputBlogNum%=%newTitle% >>Blogtitle.bat
            call Blogtitle.bat
            cls
            goto :NBBlog
rem ��������
    :cpBlog
    cls
    rem �����赼�����µ���Ϣ
        echo ֧��GBK�����txt��bat�ļ�
        echo ֧���Ϸ��ļ�(��Ҫ�ּ�)
        echo q.����
        echo.
        rem �Թ���Ա��������޷��϶���������
        set Docname=none
        set /p Docname=�ļ�����·����
        if %Docname%==q goto :menu
        if not exist %Docname% goto :CantcpBlog
        set Doctype=none
        if %Docname:~-4,-3%==. set Doctype=%Docname:~-3%
        if %Docname:~-5,-4%==. set Doctype=%Docname:~-4,-1%
        if /i not "%Doctype%"=="bat" (
            if /i not "%Doctype%"=="txt" (
                echo �ļ���֧��
                timeout /t 3 /nobreak >nul
                goto :cpBlog
            )
        )
        rem ���±��ⲻ�ܺ���Ӣ����
        echo ���±��ⲻ�ܺ�����������
        echo ���ļ����Ǳ�����ֱ�ӻس�
        set newBlogtitle=none
        set /p newBlogtitle=���±��⣺
        if /i "%newBlogtitle%"=="q" goto :cpBlog
        if "%newBlogtitle%"=="none" call :GetDocName %Docname%
        goto :jump1
            :GetDocName
                set newBlogtitle=%~n1
                goto :eof
        :jump1
    rem Ԥ������(Text)
        rem Ϊ��ȷ���Ƿ�ΪGB*����
        if /i "%Doctype%"=="txt" (
            cls
            type %Docname%
            echo.
            echo.
            echo ���������ʾ���� "�س�" ��ʼ����
            echo ����쳣����"q"�˳���������¼������
            set addTextCheck=none
            set /p addTextCheck=������:
            if /i "!addTextCheck!"=="none" (
                rem ռλ
            ) else (
                goto :cpBlog
            )
        )
    rem ��ʼ��������
        cls
        rem Ԥ����
            set Blognum=none
            call Blognum.bat
            if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
            set NewBlognum=none
            set /a NewBlognum=%Blognum%+1
            call BlogAnum.bat
            if "%BlogAnum:~-1%"==" " set BlogAnum=%BlogAnum:~0,-1%
            set /a NewBlogAnum=%BlogAnum%+1
        rem д��
            rem д��������
                echo set Blognum=%NewBlognum% >Blognum.bat
                echo set BlogAnum=%NewBlogAnum% >BlogAnum.bat
                echo set NEB%NewBlogAnum%=E>>Blogexist.bat
                echo set title%NewBlogAnum%=%newBlogtitle% >>Blogtitle.bat
                echo if not %%NEB%NewBlogAnum%%%==Del echo %NewBlogAnum%.%%title%NewBlogAnum%%% >>Bloglist.bat
            rem д����־
                echo %date:~0,-2%%time% copy %Docname% to .\odyink\Blog\ (num:%NewBlogAnum%) >>Bloglog.log
            rem ��������
                if exist %Docname% copy %Docname% Blog\%NewBlogAnum%.%Doctype% >nul
            echo �������
            timeout /t 2 /nobreak >nul
            goto :cpBlog
    rem ���²�����
        :CantcpBlog
        cls
        echo ���²�����
        timeout /t 3 /nobreak >nul
        goto :cpBlog
rem ɾ������
    :DBlog
    cls
    call Bloglist.bat
    set Blognum=none
    call Blognum.bat
    rem ������ɾ�����µ���Ϣ
        :DelBlog
        echo ����q�˳�ɾ��
        set willDelBlog=none
        set /p willDelBlog=Ҫɾ��������ţ�
        if /i "%willDelBlog%"=="q" goto :menu
        if not exist Blog\"%willDelBlog%.*t" goto :DelBlogE
        :BackDelyn
        set DelBlogyn=none
        set /p DelBlogyn=�Ƿ�ɾ��yn:
        if /i "%DelBlogyn%"=="y" goto :DelBlognow
        if /i "%DelBlogyn%"=="n" goto :DelBlog
        echo ������Ч
        goto :BackDelyn
    rem ��ʼɾ������
        :DelBlognow
        echo set NEB%willDelBlog%=Del >>Blogdel.bat
        set /a NewBlognum=%Blognum%-1
        echo set Blognum=%NewBlognum% >Blognum.bat
        echo %date:~0,-2%%time% del %willDelBlog% from .\odyink\Blog\ (num:%willDelBlog%) >>Bloglog.log
        del /q Blog\%willDelBlog%.*t
        echo ɾ�����
        timeout /t 2 /nobreak >nul
        cls
        goto :DBlog
    rem ���²�����
        :DelBlogE
        echo ���²�����
        goto :DelBlog
rem ����
    :setting
    cls
    echo d.ж�����
    echo q.������ҳ
    echo.
    set inputSettingNum=none
    set /p inputSettingNum=������:
    if /i "%inputSettingNum%"=="d" goto :removeOdyink
    if /i "%inputSettingNum%"=="q" goto :menu
    cls
    echo ������Ч
    timeout /t 2 /nobreak >nul
    goto :setting
rem ж��
    :removeOdyink
    cls
    echo ����yes���س���ȷ��ж��Odyink
    echo ����������Ϊȡ��ж��
    set delOdyinkyn=none
    set /p delOdyinkyn=������:
    if /i not "%delOdyinkyn%"=="yes" goto :setting
    cls
    echo ж�ؽ���60���ʼ
    echo �����Իس�������ж��
    echo Ҳ���Թرճ����ж�ж��
    timeout /t 60 >nul
    cd /d %~p0
    rmdir /s /q %~p0odyink\
    del /f /s /q %~f0 & exit
    exit
rem ��װ
    :install
    echo �س���װOdyink
    pause >nul
    cls
    mkdir odyink\Blog 2>nul
    cd Odyink
    if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
    rem �½��ļ�д����Ϣ
        echo set Blognum=1 >Blognum.bat
        echo set BlogAnum=0 >BlogAnum.bat
        echo set NEB0=E>>Blogexist.bat
        echo set title0=��ӭʹ��Odyink >Blogtitle.bat
        echo call Blogexist.bat >>Bloglist.bat
        echo call Blogdel.bat>>Bloglist.bat
        echo call Blogtitle.bat>>Bloglist.bat
        echo if not %%NEB0%%==Del echo 0.%%title0%%>>Bloglist.bat
        echo rem Blogdel>Blogdel.bat
        echo [Bloglog]>Bloglog.log
        echo Odyink����Andy(python)��SMG(Batch)�����������и��˲������ >>Blog\0.txt
    echo ��װ���
    timeout /t 2 /nobreak >nul
    cls
    echo ������վ·��Ϊ��%~dp0odyink\
    echo �س�������װ
    pause >nul
    %0