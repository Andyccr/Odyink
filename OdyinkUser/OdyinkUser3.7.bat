@echo off
rem 3.7
rem ��ʼ������
    chcp 936 >nul
    title Odyink User
    color 07
    cd /d %~dp0
rem ���
    :check
    rem �������
        if not exist odyink\website.bat goto :setOdyink
        cd odyink\
    rem �������������
        set wgetparameter=
        set psparameter=
        set ps=
        if exist ..\wget.exe set wget=..\wget.exe
        if exist .\wget.exe set wget=wget.exe
        if exist %SystemRoot%\System32\wget.exe set wget=wget.exe
        if exist %SystemRoot%\SysWOW64\wget.exe set wget=wget.exe
        if %wget:~-8%==wget.exe (
            rem -qǰ��1�ո�
            rem win10����https��7����Ϊ�����Բ���֤��(����ȫ)
            set wgetparameter= -q --no-check-certificate -P ./
            goto :checknet
        ) else (
            set ps=use
            set wget=PowerShell Invoke-WebRequest
            rem -outfile ǰ�����1�ո�
            set psparameter= -outfile 
        )
    rem �������
        :checknet
        echo ���������
        if exist index.html del index.html
        rem psdf=PowerShell Download File
        if "%ps%"=="use" set psdf=index.html
        %wget%%wgetparameter% https://www.kernel.org/index.html%psparameter%%psdf%
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
        if "%ps%"=="use" set psdf=Bloglist.bat
        %wget%%wgetparameter% %website%/Bloglist.bat%psparameter%%psdf%
        if not exist Bloglist.bat goto :ServerError
        if "%ps%"=="use" set psdf=BlogAnum.bat
        %wget%%wgetparameter% %website%/BlogAnum.bat%psparameter%%psdf%
        if "%ps%"=="use" set psdf=Blognum.bat
        %wget%%wgetparameter% %website%/Blognum.bat%psparameter%%psdf%
        if "%ps%"=="use" set psdf=Blogexist.bat
        %wget%%wgetparameter% %website%/Blogexist.bat%psparameter%%psdf%
        if "%ps%"=="use" set psdf=Blogdel.bat
        %wget%%wgetparameter% %website%/Blogdel.bat%psparameter%%psdf%
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
        if /i "%EBlognum%"=="r" goto :get
        if /i "%EBlognum%"=="q" goto :exit
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
            rem �����Ŀ¼Ϊ./Blog/
            if %wget:~-8%==wget.exe set wgetparameter= -q --no-check-certificate -P ./Blog/
            if "%ps%"=="use" set psdf=Blog\%EBlognum%.bat
            %wget%%wgetparameter% %website%/Blog/"%EBlognum%.bat"%psparameter%%psdf%
            if "%ps%"=="use" set psdf=Blog\%EBlognum%.txt
            %wget%%wgetparameter% %website%/Blog/"%EBlognum%.txt"%psparameter%%psdf%
            rem �Ļ�Ŀ¼Ϊ./
            if %wget:~-8%==wget.exe set wgetparameter= -q --no-check-certificate -P ./
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
            rem �򸴺Ͼ��б���Ϊ���Ͼ�ǰ�ı���ʹ�����ӳٱ�����þ��б����Ķ�ֵ̬
            setlocal enabledelayedexpansion
            if exist Blog\"%EBlognum%.bat" (
                echo ����Batch��չ
                echo ����odyink\Blog\%EBlognum%.bat�в鿴����
                echo ��Batch��չ������ִ�к���Ը�
                echo �鿴������Ϊ�˷�����!!!
                set batrunyn=
                set /p batrunyn=�Ƿ�ȷ��ִ��yn:
                if /i "!batrunyn!"=="y" (
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
            if /i "%Blogcon%"=="b" goto :backBlog
            if /i "%Blogcon%"=="n" goto :nextBlog
            if /i "%Blogcon%"=="q" goto :VB
            if /i "%Blogcon%"=="r" goto :NBBlog
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