@echo off
rem 4.6
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
    echo 4.�˳�����
    echo.
    set Munum=
    set /p Munum=��ţ�
    cls
    if "%Munum%"=="1" goto :VB
    if "%Munum%"=="2" goto :cpBlog
    if "%Munum%"=="3" goto :DBlog
    if "%Munum%"=="4" ( cls & exit )
    echo ������Ч
    timeout /t 2 /nobreak >nul
    goto :menu
rem У������
    rem �����б�
        :VB
        cls
        call Bloglist.bat
        echo.
        echo.
        call Blognum.bat
        if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
        echo Ŀǰ��%Blognum%ƪ����
        echo.
        echo q.������ҳ
        set inputBlogNum=
        set /p inputBlogNum=������ţ�
        cls
        if /i "%inputBlogNum%"=="q" goto :menu
    rem �������
        rem Ԥ����
            :NBBlog
            set Doctype=
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
                echo ����Batch��չ
                echo ����odyink\Blog\%inputBlogNum%.bat�в鿴����
                echo ��Batch��չ������ִ�к���Ը�
                echo �鿴������Ϊ�˷�����!!!
                echo.
                echo y.ȷ��ִ�� c.�༭���� e.ȡ��ִ��
                echo   b.��һƪ q.�����б� n.��һƪ
                set batruncode=
                set /p batruncode=�������:
                if /i "!batruncode!"=="b" goto :backBlog
                if /i "!batruncode!"=="n" goto :nextBlog
                if /i "!batruncode!"=="c" (
                    notepad.exe .\Blog\%inputBlogNum%.%Doctype%
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
                    echo b.��һƪ q.�����б� n.��һƪ
                    echo          c.�༭����
                    goto :BlogconNE
                ) else (
                    goto :VB
                )
            )
        rem ��ʾ�ı�����Text
            set Doctype=txt
            type Blog\%inputBlogNum%.txt
            echo.
            echo.
            echo b.��һƪ q.�����б� n.��һƪ
            echo          c.�޸�����
            echo.
        rem ���²���
            :BlogconNE
            @echo off
            set Blogcon=
            set /p Blogcon=������ţ�
            if /i "%Blogcon%"=="b" goto :backBlog
            if /i "%Blogcon%"=="n" goto :nextBlog
            if /i "%Blogcon%"=="q" goto :VB
            if /i "%Blogcon%"=="c" (
                notepad.exe .\Blog\%inputBlogNum%.%Doctype%
                cls
                goto :NBBlog
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
rem ��������
    :cpBlog
    cls
    set Docname=
    set Blognum=
    set NewBlognum=
    set Blogtitle=
    set Doctype=
    rem �����赼�����µ���Ϣ
        echo ֧��GBK�����txt��bat�ļ�
        echo ֧���Ϸ��ļ�(��Ҫ�ּ�)
        echo q.����
        echo.
        rem �Թ���Ա��������޷��϶���������
        set /p Docname=�ļ�����·����
        if %Docname%==q goto :menu
        if not exist %Docname% goto :CantcpBlog
        if %Docname:~-4,-3%==. set Doctype=%Docname:~-3%
        if %Docname:~-5,-4%==. set Doctype=%Docname:~-4,-1%
        if not "%Doctype%"=="bat" (
            if not "%Doctype%"=="txt" (
                echo �ļ���֧��
                timeout /t 3 /nobreak >nul
                goto :cpBlog
            )
        )
        rem ���±��ⲻ�ܺ���Ӣ����
        echo ���±��ⲻ�ܺ�����������
        set /p Blogtitle=���±��⣺
        if /i "%Blogtitle%"=="q" goto :cpBlog
    rem ��ʼ��������
        cls
        rem Ԥ����
        call Blognum.bat
        if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
        set /a NewBlognum=%Blognum%+1
        call BlogAnum.bat
        if "%BlogAnum:~-1%"==" " set BlogAnum=%BlogAnum:~0,-1%
        set /a NewBlogAnum=%BlogAnum%+1
        rem д��
            rem д��������
                echo set Blognum=%NewBlognum% >Blognum.bat
                echo set BlogAnum=%NewBlogAnum% >BlogAnum.bat
                echo set NEB%NewBlogAnum%=E>>Blogexist.bat
                echo if not %%NEB%NewBlogAnum%%%==Del echo %NewBlogAnum%.%Blogtitle% >>Bloglist.bat
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
    set willDelBlog=
    set DelBlogyn=
    call Bloglist.bat
    call Blognum.bat
    rem ������ɾ�����µ���Ϣ
        :DelBlog
        echo ����q�˳�ɾ��
        set /p willDelBlog=Ҫɾ��������ţ�
        if /i "%willDelBlog%"=="q" goto :menu
        if not exist Blog\"%willDelBlog%.*t" goto :DelBlogE
        :BackDelyn
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
        echo call Blogexist.bat >>Bloglist.bat
        echo call Blogdel.bat>>Bloglist.bat
        echo if not %%NEB0%%==Del echo 0.��ӭʹ��Odyink>>Bloglist.bat
        echo rem Blogdel>Blogdel.bat
        echo [Bloglog]>Bloglog.log
        echo Odyink����Andy(python)��SMG(Batch)�����������и��˲������ >>Blog\0.txt
    rem Ϊ�˼����ϰ汾Odyink User
        echo ServerOK >ServerOK
    echo ��װ���
    timeout /t 2 /nobreak >nul
    %0