@echo off
rem 4.2
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
        set pswget=PowerShell Invoke-WebRequest
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
                wget %WO% %website%/Bloglist.bat >nul
                if not exist Bloglist.bat %pswget% %website%/Bloglist.bat %PSO% Bloglist.bat >nul
                if not exist Bloglist.bat goto :ServerError
            echo ��������Blognum.bat
                wget %WO% %website%/Blognum.bat >nul
                if not exist Blognum.bat %pswget% %website%/Blognum.bat %PSO% Blognum.bat >nul
                if not exist Blognum.bat goto :ServerError
            echo ��������Blogexist.bat
                wget %WO% %website%/Blogexist.bat >nul
                if not exist Blogexist.bat %pswget% %website%/Blogexist.bat %PSO% Blogexist.bat >nul
                if not exist Blogexist.bat goto :ServerError
            echo ��������Blogdel.bat
                wget %WO% %website%/Blogdel.bat >nul
                if not exist Blogdel.bat %pswget% %website%/Blogdel.bat %PSO% Blogdel.bat >nul
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
        set inputBlogNum=
        set /p inputBlogNum=������ţ�
        cls
        if /i "%inputBlogNum%"=="r" goto :get
        if /i "%inputBlogNum%"=="q" goto :exit
    rem �����������
        rem Ԥ����
            :NBBlog
            cls
            set findExistBlog=
            if "%inputBlogNum:~-1%"==" " set inputBlogNum=%inputBlogNum:~0,-1%
            if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
            cls
        rem ��������
            echo ����������
                wget %WO%Blog/ %website%/Blog/%inputBlogNum%.bat >nul
                if not exist %inputBlogNum%.bat %pswget% %website%/Blog/%inputBlogNum%.bat %PSO% .\Blog\%inputBlogNum%.bat >nul
                wget %WO%Blog/ %website%/Blog/%inputBlogNum%.txt >nul
                if not exist %inputBlogNum%.txt %pswget% %website%/Blog/%inputBlogNum%.txt %PSO% .\Blog\%inputBlogNum%.txt >nul
            cls
        rem ��������Ƿ����
        if not exist Blog\"%inputBlogNum%.bat" (
            if not exist Blog\"%inputBlogNum%.txt" (
                echo ���²�����
                timeout /t 2 /nobreak >nul
                goto :VB
            )
        )
        rem ��ʾ�ı�����Batch
            rem �򸴺Ͼ��б���Ϊ���Ͼ�ǰ�ı���,ʹ�����ӳٱ�����þ��б����Ķ�ֵ̬
            setlocal enabledelayedexpansion
            if exist Blog\"%inputBlogNum%.bat" (
                echo ����Batch��չ
                echo ����odyink\Blog\%inputBlogNum%.bat�в鿴����
                echo ��Batch��չ������ִ�к���Ը�
                echo �鿴������Ϊ�˷�����!!!
                set batrunyn=
                set /p batrunyn=�Ƿ�ȷ��ִ��yn:
                if /i "!batrunyn!"=="y" (
                    cls
                    cmd /c .\Blog\%inputBlogNum%.bat
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
            type Blog\%inputBlogNum%.txt
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
            set StartinputBlogNum=%inputBlogNum%
            cls
            echo ���ڼ������Ժ�...
            :Back
            set /a inputBlogNum=%inputBlogNum%-1
            set /a AV=%StartinputBlogNum%-%inputBlogNum%
            call set findExistBlog=%%NEB%inputBlogNum%%%
            if "%findExistBlog%"=="E" goto :NBBlog
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NBBlog
            goto :Back
        rem ��һƪ����
            :nextBlog
            set StartinputBlogNum=%inputBlogNum%
            cls
            echo ���ڼ������Ժ�...
            :Next
            set /a inputBlogNum=%inputBlogNum%+1
            set /a AV=%inputBlogNum%-%StartinputBlogNum%
            call set findExistBlog=%%NEB%inputBlogNum%%%
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
    cls
    echo �������
    timeout /t 2 /nobreak >nul
    %0
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