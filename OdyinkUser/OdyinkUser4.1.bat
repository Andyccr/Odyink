@echo off
rem 4.1
rem ��ʼ������
    chcp 936 >nul
    title Odyink User
    color 07
    cd /d %~dp0
    cls
rem ���
    :check
    rem �������
        if not exist odyink\website.bat goto :setOdyink
        cd odyink\
    rem �������������
        if exist ..\wget.exe copy ..\wget.exe .\wget.exe
        rem Ϊ�����Բ���֤��(����ȫ)
        set WO=-q --no-check-certificate -P ./
        set wget=PowerShell Invoke-WebRequest
        set PSO=-outfile
rem ������
    rem �����б�
        :get
        cls
        echo ���������б����Ժ�...
        call website.bat
        if "%website:~-1%"==" " set website=%website:~0,-1%
        rem ɾ�����ļ�
            if exist index.html del index.html
            if exist Blog*.bat del Blog*.bat
            if exist exdoc.bat del exdoc.bat
            if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
        rem �������б��ļ�
            echo ��������Bloglist.bat
                %wget% %website%/Bloglist.bat %PSO% Bloglist.bat
                if not exist Bloglist.bat wget %WO% %website%/Bloglist.bat
                if not exist Bloglist.bat goto :ServerError
            echo ��������Blognum.bat
                %wget% %website%/Blognum.bat%PSO% Blognum.bat
                if not exist Blognum.bat wget %WO% %website%/Blognum.bat
                if not exist Blognum.bat goto :ServerError
            echo ��������Blogexist.bat
                %wget% %website%/Blogexist.bat%PSO% Blogexist.bat
                if not exist Blogexist.bat wget %WO% %website%/Blogexist.bat
                if not exist Blogexist.bat goto :ServerError
            echo ��������Blogdel.bat
                %wget% %website%/Blogdel.bat%PSO% Blogdel.bat
                if not exist Blogdel.bat wget %WO% %website%/Blogdel.bat
                if not exist Blogdel.bat goto :ServerError
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
            set findExistBlog=
            if "%EBlognum:~-1%"==" " set EBlognum=%EBlognum:~0,-1%
            if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
            cls
        rem ��������
            echo ����������
                %wget% %website%/Blog/%EBlognum%.bat %PSO% .\Blog\%EBlognum%.bat
                if not exist %EBlognum%.bat wget %WO%Blog/ /Blog/%EBlognum%.bat
                %wget% %website%/Blog/%EBlognum%.txt %PSO% .\Blog\%EBlognum%.txt
                if not exist %EBlognum%.txt wget %WO%Blog/ /Blog/%EBlognum%.txt
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
            rem �򸴺Ͼ��б���Ϊ���Ͼ�ǰ�ı���,ʹ�����ӳٱ�����þ��б����Ķ�ֵ̬
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
                        rem ����if���Ͼ䲻��@echo off��cd�������Զ��ָ�(ԭ����)һ�þͻᱨ��
                        chcp 936 >nul
                        title Odyink User
                        color 07
                    echo b.��һƪ q.�����б� n.��һƪ
                    echo         r.ˢ����չ
                    goto :BlogconNE
                ) else (
                    goto :VB
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
            call set findExistBlog=%%NEB%EBlognum%%%
            if "%findExistBlog%"=="E" goto :NBBlog
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
            call set findExistBlog=%%NEB%EBlognum%%%
            if "%findExistBlog%"=="E" goto :NBBlog
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