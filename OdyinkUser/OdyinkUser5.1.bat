@echo off
rem 5.1
rem ��ʼ��
    chcp 936 >nul
    title Odyink User
    color 07
    cd /d %~dp0
    cls
    setlocal enabledelayedexpansion
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
                wget %WO% %website%/Bloglist.bat 2>nul
                if not exist Bloglist.bat %pswget% %website%/Bloglist.bat %PSO% Bloglist.bat >nul
                if not exist Bloglist.bat goto :ServerError
            echo ��������Blognum.bat
                wget %WO% %website%/Blognum.bat 2>nul
                if not exist Blognum.bat %pswget% %website%/Blognum.bat %PSO% Blognum.bat >nul
                if not exist Blognum.bat goto :ServerError
            echo ��������Blogexist.bat
                wget %WO% %website%/Blogexist.bat 2>nul
                if not exist Blogexist.bat %pswget% %website%/Blogexist.bat %PSO% Blogexist.bat >nul
                if not exist Blogexist.bat goto :ServerError
            echo ��������Blogdel.bat
                wget %WO% %website%/Blogdel.bat 2>nul
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
        echo u.������
        set inputBlogNum=
        set /p inputBlogNum=������ţ�
        cls
        if /i "%inputBlogNum%"=="r" goto :get
        if /i "%inputBlogNum%"=="q" goto :exit
        if /i "%inputBlogNum%"=="u" goto :update
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
                wget %WO%Blog/ %website%/Blog/%inputBlogNum%.bat 2>nul
                if not exist %inputBlogNum%.bat %pswget% %website%/Blog/%inputBlogNum%.bat %PSO% .\Blog\%inputBlogNum%.bat >nul
                wget %WO%Blog/ %website%/Blog/%inputBlogNum%.txt 2>nul
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
            if exist Blog\"%inputBlogNum%.bat" (
                echo ����Batch��չ
                echo ����odyink\Blog\%inputBlogNum%.bat�в鿴����
                echo ��Batch��չ������ִ�к���Ը�
                echo �鿴������Ϊ�˷�����!!!
                echo.
                echo y.ȷ��ִ�� e.ȡ��ִ��
                echo   b.��һƪ n.��һƪ
                set batruncode=
                set /p batruncode=�������:
                if /i "!batruncode!"=="b" goto :backBlog
                if /i "!batruncode!"=="n" goto :nextBlog
                if /i "!batruncode!"=="y" (
                    cls
                    cmd /c .\Blog\%inputBlogNum%.bat
                    cls
                    rem ���³�ʼ��
                        rem ����if���Ͼ䲻��@echo off��cd�������Զ��ָ�(ԭ����)һ�þͻᱨ��
                        chcp 936 >nul
                        title Odyink User
                        color 07
                    echo b.��һƪ q.�����б� n.��һƪ
                    echo          r.ˢ����չ
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
rem ������
    :update
    cd ..\
    if exist Update.bat del /f Update.bat
    rem ���ø���Դ(��β��б��)
    set updateWebsite=https://odyink-1302226504.cos.accelerate.myqcloud.com
    echo ���ڼ�����
    wget %WO% %updateWebsite%/Update.bat 2>nul
    if not exist Update.bat %pswget% %updateWebsite%/Update.bat %PSO% Update.bat >nul
    cls
    if not exist Update.bat (
        echo �����³���
        timeout /t 2 /nobreak >nul
        cls
        goto :VB
    )
    set updateYN=
    call Update.bat
    rem ��ǰ�汾(����)
    set version=5
    if %latestVersion% gtr %version% (
        echo �������°汾%latestVersion%
        echo ����yȷ�ϸ����������˳�
        set /p updateYN=������:
        if /i "!updateYN!"=="y" (
            rem y�ǲ���%1 %updateWebsite%�ǲ���%2 %~nx1(������׺�����ļ���)�ǲ���%3
            start Update.bat y %updateWebsite% %~nx0
            exit
            ) else (
                if exist Update.bat del /f Update.bat
                cd .\odyink\
                set updateYN=
                goto :VB
            )
    ) else (
        echo ��ǰ�������°汾
        timeout /t 2 /nobreak >nul
        cls
        goto :VB
    )
rem ����Odyink
    :setOdyink
    echo ����Odyink
    set /p website=������IP[/Ŀ¼]��
    echo ��������Odyink...
    if "%website:~-1%"=="/" set website=%website:~0,-1%
    mkdir odyink\Blog 2>nul
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
    cls
    exit