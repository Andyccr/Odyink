@echo off
::3.2
::��ʼ��
    chcp 936 >nul
    title Odyink Server
    color 07
    cd /d %~dp0
::��ⰲװ
    :Check
    if not exist Odyink\Bloglist.bat goto install
    cd Odyink\
::�˵�
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
    if "%Munum%"=="1" goto VB
    if "%Munum%"=="2" goto cpBlog
    if "%Munum%"=="3" goto DBlog
    if "%Munum%"=="4" exit
    echo ������Ч
    timeout /t 2 /nobreak >nul
    goto menu
::У������
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
    set EBlognum=
    set /p EBlognum=������ţ�
    cls
    if "%EBlognum%"=="q" goto menu
    ::Ԥ����
        :NBBlog
    ::��������Ƿ����
        if not exist Blog\"%EBlognum%.txt" (
            echo �����²�����
            echo ���������б�
            timeout /t 2 /nobreak >nul
            goto VB
        )
    ::��ʾ�ı�����
        type Blog\%EBlognum%.txt
        echo.
        echo.
        echo b.��һƪ q.�����б� n.��һƪ
        echo          c.�޸�����
        echo.
        :BlogconNE
        set Blogcon=
        set /p Blogcon=������ţ�
        if "%Blogcon%"=="b" goto backBlog
        if "%Blogcon%"=="n" goto nextBlog
        if "%Blogcon%"=="q" goto VB
        if "%Blogcon%"=="c" (
            notepad.exe .\Blog\%EBlognum%.txt
            cls
            goto NBBlog
        )
        echo ������Ч
        echo.
        goto BlogconNE
    ::��һƪ����
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
    ::��һƪ����
        :nextBlog
        set StartEBlognum=%EBlognum%
        cls
        :Next
        set /a EBlognum=%EBlognum%+1
        set /a AV=%EBlognum%-%StartEBlognum%
        if %AV%==101 goto NBBlog
        if exist Blog\%EBlognum%.txt goto NBBlog
        goto Next
::��������
    :cpBlog
    cls
    set Docname=
    set Blognum=
    set NewBlognum=
    set Blogtitle=
    ::�����赼�����µ���Ϣ
        echo ֧��GBK�����txt�ļ�
        echo ֧���Ϸ��ļ�(�ǵûس�)
        echo q.����
        echo.
        set /p Docname=�����ļ���(�޺�׺)��
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
        set /p Blogtitle=���±��⣺
        if "%Blogtitle%"=="q" goto cpBlog
    ::��ʼ��������
        cls
        echo set Blognum=%NewBlognum% >Blognum.bat
        echo set BlogAnum=%NewBlogAnum% >BlogAnum.bat
        echo set NEB%NewBlogAnum%=E>>Blogexist.bat
        echo if not %%NEB%NewBlogAnum%%%==Del echo %NewBlogAnum%.%Blogtitle% >>Bloglist.bat
        echo %date:~0,-2%%time% copy "%Docname%" to .\Odyink\Blog\ (num:%NewBlogAnum%) >>Bloglog.log
        if exist ..\"%Docname%.txt" copy  ..\"%Docname%.txt" Blog\%NewBlogAnum%.txt >nul
        if exist "%Docname%" copy "%Docname%" Blog\%NewBlogAnum%.txt >nul
        echo �������
        timeout /t 2 /nobreak >nul
        goto cpBlog
    ::���²�����
        :CantcpBlog
        cls
        echo ���²�����
        timeout /t 3 /nobreak >nul
        goto cpBlog
::ɾ������
    :DBlog
    cls
    set willDelBlog=
    set DelBlogyn=
    call Bloglist.bat
    call Blognum.bat
    ::������ɾ�����µ���Ϣ
        :DelBlog
        echo ����q�˳�ɾ��
        set /p willDelBlog=Ҫɾ��������ţ�
        if "%willDelBlog%"=="q" goto menu
        if not exist Blog\"%willDelBlog%.txt" goto DelBlogE
        :BackDelyn
        set /p DelBlogyn=�Ƿ�ɾ��yn:
        if "%DelBlogyn%"=="y" goto DelBlognow
        if "%DelBlogyn%"=="n" goto DelBlog
        echo ������Ч
        goto BackDelyn
    ::��ʼɾ������
        :DelBlognow
        echo set NEB%willDelBlog%=Del >>Blogdel.bat
        set /a NewBlognum=%Blognum%-1
        echo set Blognum=%NewBlognum% >Blognum.bat
        echo %date:~0,-2%%time% del %willDelBlog%.txt from .\Odyink\Blog\ (num:%willDelBlog%) >>Bloglog.log
        del Blog\%willDelBlog%.txt
        echo ɾ�����
        timeout /t 2 /nobreak >nul
        cls
        goto DBlog
    ::���²�����
        :DelBlogE
        echo ���²�����
        goto DelBlog
::��װ
    :install
    echo �س���װOdyink
    pause >nul
    cls
    mkdir Odyink >nul
    mkdir Odyink\Blog >nul
    cd Odyink
    if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
    ::�½��ļ�д����Ϣ
        echo set Blognum=1 >Blognum.bat
        echo set BlogAnum=0 >BlogAnum.bat
        echo set NEB0=E>>Blogexist.bat
        echo call Blogexist.bat >>Bloglist.bat
        echo call Blogdel.bat>>Bloglist.bat
        echo if not %%NEB0%%==Del echo 0.��ӭʹ��Odyink>>Bloglist.bat
        echo ::Blogdel>Blogdel.bat
        echo [Bloglog]>Bloglog.log
        echo Odyink����Andy(python)��SMG(Batch)�����������и��˲������ >>Blog\0.txt
        cd ..\
        echo ��װ���
        timeout /t 2 /nobreak >nul
        cls
        goto Check