@echo off
rem 3.5
rem ��ʼ��
    chcp 936 >nul
    title Odyink User
    color 07
    cd /d %~dp0
    set wget=PowerShell Invoke-WebRequest
rem ���
    :check
    rem �������
        if not exist odyink\website.bat goto :setOdyink
        cd odyink\
    rem ���PowerShell
        echo ����Ƿ����PowerShell
        if not exist %SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe (
            echo ���Ҳ���PowerShell
            goto :exit
        )
    rem �������
        echo ���������
        if exist index.html del index.html
        %wget% https://www.kernel.org/index.html -outfile index.html >nul
        if exist index.html (
            del index.html
            goto :get
        )
        echo �������!
        goto :exit
rem ������
    rem �����б�
        :get
        cls
        echo ���������б����Ժ�...
        call website.bat
        if "%website:~-1%"==" " set website=%website:~0,-1%
        if exist index.html del index.html
        if exist Blog*.bat del Blog*.bat
        if exist exdoc.bat del exdoc.bat
        if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
        %wget% %website%/Bloglist.bat -outfile Bloglist.bat >nul
        if not exist Bloglist.bat goto :ServerError
        %wget% %website%/BlogAnum.bat -outfile BlogAnum.bat >nul
        %wget% %website%/Blognum.bat -outfile Blognum.bat >nul
        %wget% %website%/Blogexist.bat -outfile Blogexist.bat >nul
        %wget% %website%/Blogdel.bat -outfile Blogdel.bat >nul
        if not exist BlogAnum.bat goto :ServerError
        if not exist Blognum.bat goto :ServerError
        if not exist Bloglist.bat goto :ServerError
        if not exist Blogdel.bat goto :ServerError
        if not exist Blogexist.bat goto :ServerError
        cls
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
        echo r.ˢ�� q.�˳�
        set EBlognum=
        set /p EBlognum=������ţ�
        cls
        if "%EBlognum%"=="r" goto :get
        if "%EBlognum%"=="q" goto :exit
    rem �����������
        rem Ԥ����
            :NBBlog
            cls
            set NEBEB=
            if "%EBlognum:~-1%"==" " set EBlognum=%EBlognum:~0,-1%
            if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
            cls
        rem ��������
            echo ����������
            %wget% %website%/Blog/"%EBlognum%.bat" -outfile Blog\%EBlognum%.bat >nul
            %wget% %website%/Blog/"%EBlognum%.txt" -outfile Blog\%EBlognum%.txt >nul
            cls
        rem ��������Ƿ����
        if not exist Blog\"%EBlognum%.bat" (
            if not exist Blog\"%EBlognum%.txt" (
                echo ���²�����
                timeout /t 2 /nobreak >nul
                goto :VB
            )
        )
        rem ��ʾ�ı�����Batch
            if exist Blog\"%EBlognum%.bat" (
                echo ����Batch��չ
                echo ����odyink\Blog\%EBlognum%.bat�в鿴����
                echo �鿴������Ϊ�˷�����!!!
                echo �س�ȷ��ִ��
                pause >nul
                cls
                cmd /c .\Blog\%EBlognum%.bat
                cls
                rem ���³�ʼ��
                    rem ����if���Ͼ䲻����@echo off�ᱨ�����Ƶ�:BlogconNE��һ��
                    rem ����if���Ͼ䲻��cd�������Զ��ָ�(ԭ����)������cd�ᱨ��
                    chcp 936 >nul
                    title Odyink User
                    color 07
                echo b.��һƪ q.�����б� n.��һƪ
                echo         r.ˢ������
                goto :BlogconNE
            )
        rem ��ʾ�ı�����Text
            type Blog\%EBlognum%.txt
            echo.
            echo.
            echo b.��һƪ q.�����б� n.��һƪ
            echo         r.ˢ������
            echo.
        rem ���²���
            :BlogconNE
            @echo off
            set Blogcon=
            set /p Blogcon=������ţ�
            if "%Blogcon%"=="b" goto :backBlog
            if "%Blogcon%"=="n" goto :nextBlog
            if "%Blogcon%"=="q" goto :VB
            if "%Blogcon%"=="r" goto :NBBlog
            echo ������Ч����������
            echo.
            goto :BlogconNE
        rem ��һƪ����
            :backBlog
            set StartEBlognum=%EBlognum%
            cls
            echo ���ڼ������Ժ�...
            :Back
            set /a EBlognum=%EBlognum%-1
            set /a AV=%StartEBlognum%-%EBlognum%
            call set NEBEB=%%NEB%EBlognum%%%
            if "%NEBEB%"=="E" goto :NBBlog
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NBBlog
            goto :Back
        rem ��һƪ����
            :nextBlog
            set StartEBlognum=%EBlognum%
            cls
            echo ���ڼ������Ժ�...
            :Next
            set /a EBlognum=%EBlognum%+1
            set /a AV=%EBlognum%-%StartEBlognum%
            call set NEBEB=%%NEB%EBlognum%%%
            if "%NEBEB%"=="E" goto :NBBlog
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NBBlog
            goto :Next
rem ����Odyink
    :setOdyink
    echo ����Odyink
    set /p website=������IP[/Ŀ¼]��
    echo ��������Odyink...
    if "%website:~-1%"=="/" set website=%website:~0,-1%
    mkdir odyink >nul
    mkdir odyink\Blog >nul
    cd odyink
    if exist Blog*.bat del Blog*.bat
    if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
    echo set website=%website% >website.bat
    cd ..\
    cls
    echo �������
    timeout /t 2 /nobreak >nul
    cls
    goto :check
rem �˳�
    :ServerError
    echo ����������
    :exit
    echo �����˳�Odyink...
    if exist index.html del index.html
    if exist Blog*.bat del Blog*.bat
    if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
    timeout /t 2 /nobreak >nul
    exit