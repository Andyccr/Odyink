@echo off
::3.2
::��ʼ��
    chcp 936 >nul
    title Odyink User
    color 07
    cd /d %~dp0
::���
    :check
    ::�������
        if not exist Odyink\website.bat goto setOdyink
        cd Odyink\
    ::���PowerShell
        echo ����Ƿ����PowerShell
        if not exist %SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe (
            echo ���Ҳ���PowerShell
            goto exit
        )
    ::�������
        echo ���������
        if exist index.html del index.html
        PowerShell wget https://www.kernel.org/index.html -outfile index.html >nul
        if exist index.html (
            if exist index.html del index.html
            goto get
        )
        echo �������!
        goto exit
::������
    ::�����ļ�
        :get
        cls
        echo ���������б����Ժ�...
        call website.bat
        if "%website:~-1%"==" " set website=%website:~0,-1%
        if exist index.html del index.html
        if exist ServerOK del ServerOK
        if exist Blog*.bat del Blog*.bat
        if exist exdoc.bat del exdoc.bat
        if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
        PowerShell wget %website%/ServerOK -outfile ServerOK >nul
        if not exist ServerOK goto ServerError
        PowerShell wget %website%/BlogAnum.bat -outfile BlogAnum.bat >nul
        PowerShell wget %website%/Blognum.bat -outfile Blognum.bat >nul
        PowerShell wget %website%/Bloglist.bat -outfile Bloglist.bat >nul
        PowerShell wget %website%/Blogexist.bat -outfile Blogexist.bat >nul
        PowerShell wget %website%/Blogdel.bat -outfile Blogdel.bat >nul
        if not exist BlogAnum.bat goto ServerError
        if not exist Blognum.bat goto ServerError
        if not exist Bloglist.bat goto ServerError
        if not exist Blogdel.bat goto ServerError
        if not exist Blogexist.bat goto ServerError
        cls
    ::�����б�
        :VB
        cls
        call Bloglist.bat
        echo.
        echo.
        call Blognum.bat
        if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
        echo Ŀǰ��%Blognum%ƪ����
        echo.
        echo r.ˢ�� q.�˳�
        set EBlognum=
        set /p EBlognum=������ţ�
        cls
        if "%EBlognum%"=="r" goto get
        if "%EBlognum%"=="q" goto exit
    ::Ԥ����
        :NBBlog
        cls
        set NEBEB=
        if "%EBlognum:~-1%"==" " set EBlognum=%EBlognum:~0,-1%
        if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
        cls
        ::��������
            echo ��������
            PowerShell wget %website%/Blog/"%EBlognum%.txt" -outfile Blog\%EBlognum%.txt >nul
            cls
        ::��������Ƿ����
            if not exist Blog\"%EBlognum%.txt" (
                echo �����²����ڻ��������
                echo ���������б�
                timeout /t 2 /nobreak >nul
                goto VB
            )
        ::��ʾ�ı�����
            type Blog\%EBlognum%.txt
            echo.
            echo.
            echo b.��һƪ q.�����б� n.��һƪ
            echo         r.ˢ������
            echo.
            :BlogconNE
            set Blogcon=
            set /p Blogcon=������ţ�
            if "%Blogcon%"=="b" goto backBlog
            if "%Blogcon%"=="n" goto nextBlog
            if "%Blogcon%"=="q" goto VB
            if "%Blogcon%"=="r" goto NBBlog
            echo ������Ч����������
            echo.
            goto BlogconNE
        ::��һƪ����
            :backBlog
            set StartEBlognum=%EBlognum%
            cls
            echo ���ڼ������Ժ�...
            :Back
            set /a EBlognum=%EBlognum%-1
            set /a AV=%StartEBlognum%-%EBlognum%
            call set NEBEB=%%NEB%EBlognum%%%
            if "%NEBEB%"=="E " goto NBBlog
            if %AV%==101 goto NBBlog
            goto Back
        ::��һƪ����
            :nextBlog
            set StartEBlognum=%EBlognum%
            cls
            echo ���ڼ������Ժ�...
            :Next
            set /a EBlognum=%EBlognum%+1
            set /a AV=%EBlognum%-%StartEBlognum%
            call set NEBEB=%%NEB%EBlognum%%%
            if "%NEBEB%"=="E " goto NBBlog
            if %AV%==101 goto NBBlog
            goto Next
::����Odyink
    :setOdyink
    echo ����Odyink
    set /p website=������IP[/Ŀ¼]��
    echo ��������Odyink...
    if "%website:~-1%"=="/" set website=%website:~0,-1%
    mkdir Odyink >nul
    mkdir Odyink\Blog >nul
    cd Odyink
    if exist Blog*.bat del Blog*.bat
    if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
    echo set website=%website% >website.bat
    cd ..\
    cls
    echo �������
    timeout /t 2 /nobreak >nul
    cls
    goto check
::�˳�
    :ServerError
    echo ����������
    :exit
    echo �����˳�Odyink...
    if exist index.html del index.html
    if exist Blog*.bat del Blog*.bat
    if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
    timeout /t 2 /nobreak >nul
    exit