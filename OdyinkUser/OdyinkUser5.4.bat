@echo off
rem 5.4
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
            if exist Blog*.bat del Blog*.bat
            if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
        rem �������б��ļ�
            set net=ok
            echo ��������Bloglist.bat
                wget %WO% %website%/Bloglist.bat 2>nul
                if not exist Bloglist.bat %pswget% %website%/Bloglist.bat %PSO% Bloglist.bat >nul
                if not exist Bloglist.bat (
                    set net=error
                    goto :VB
                )
            echo ��������Blognum.bat
                wget %WO% %website%/Blognum.bat 2>nul
                if not exist Blognum.bat %pswget% %website%/Blognum.bat %PSO% Blognum.bat >nul
                if not exist Blognum.bat (
                    set net=error
                    goto :VB
                )
            echo ��������Blogexist.bat
                wget %WO% %website%/Blogexist.bat 2>nul
                if not exist Blogexist.bat %pswget% %website%/Blogexist.bat %PSO% Blogexist.bat >nul
                if not exist Blogexist.bat (
                    set net=error
                    goto :VB
                )
            echo ��������Blogdel.bat
                wget %WO% %website%/Blogdel.bat 2>nul
                if not exist Blogdel.bat %pswget% %website%/Blogdel.bat %PSO% Blogdel.bat >nul
                if not exist Blogdel.bat (
                    set net=error
                    goto :VB
                )
            echo ��������Blogtitle.bat
                wget %WO% %website%/Blogtitle.bat 2>nul
                if not exist Blogtitle.bat %pswget% %website%/Blogtitle.bat %PSO% Blogtitle.bat >nul
                if not exist Blogtitle.bat (
                    set net=error
                    goto :VB
                )
        cls
    rem �����б�
        :VB
        title Odyink User
        cls
        if /i "%net%"=="ok" (
            call Bloglist.bat
        ) else (
            echo �������
        )
        echo.
        echo.
        set Blognum=0
        if /i "%net%"=="ok" call Blognum.bat
        if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
        echo Ŀǰ��%Blognum%ƪ����
        echo.
        echo r.ˢ�� q.�˳�
        echo  s.��������
        set inputBlogNum=none
        set /p inputBlogNum=������ţ�
        cls
        if /i "%inputBlogNum%"=="r" goto :get
        if /i "%inputBlogNum%"=="q" goto :exit
        if /i "%inputBlogNum%"=="s" goto :setting
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
                title Odyink User
                echo ����Batch��չ
                echo ����odyink\Blog\%inputBlogNum%.bat�в鿴����
                echo ��Batch��չ������ִ�к���Ը�
                echo �鿴������Ϊ�˷�����!!!
                echo.
                echo y.ȷ��ִ�� e.ȡ��ִ��
                echo   b.��һƪ n.��һƪ
                set batruncode=none
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
            title !title%inputBlogNum%!
            echo.
            echo.
            echo b.��һƪ q.�����б� n.��һƪ
            echo          r.ˢ������
            echo.
        rem ���²���
            :BlogconNE
            set Blogcon=none
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
rem ����
    :setting
    cls
    echo u.������
    echo d.ж�����
    echo c.������ַ
    echo q.�����б�
    echo.
    set inputSettingNum=none
    set /p inputSettingNum=������:
    if /i "%inputSettingNum%"=="u" goto :update
    if /i "%inputSettingNum%"=="d" goto :removeOdyink
    if /i "%inputSettingNum%"=="c" goto :changeWebsite
    if /i "%inputSettingNum%"=="q" goto :VB
    cls
    echo ������Ч
    timeout /t 2 /nobreak >nul
    goto :setting
rem ������ַ
    :changeWebsite
    cls
    set newWebsite=none
    set /p newWebsite=����ַ{������IP[/Ŀ¼]}:
    if "%newWebsite:~-1%"=="/" set newWebsite=%newWebsite:~0,-1%
    set changeWebsiteyn=none
    set /p changeWebsiteyn=�Ƿ����yn:
    if /i "%changeWebsiteyn%"=="y" (
        echo set website=%newWebsite% >website.bat
        cmd /c %0
        exit
    ) else (
        goto :setting
    )
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
rem ������
    :update
    cls
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
        goto :setting
    )
    set updateYN=
    call Update.bat
    rem ��ǰ�汾(����)
    set version=5
    if %latestVersion% gtr %version% (
        echo �������°汾%latestVersion%
        echo ����yȷ�ϸ����������˳�
        set updateYN=
        set /p updateYN=������:
        if /i "!updateYN!"=="y" (
            rem y�ǲ���%1 %updateWebsite%�ǲ���%2 %~nx1(������׺�����ļ���)�ǲ���%3
            start Update.bat y %updateWebsite% %~nx0
            exit
            ) else (
                if exist Update.bat del /f Update.bat
                cd .\odyink\
                set updateYN=
                goto :setting
            )
    ) else (
        echo ��ǰ�������°汾
        if exist Update.bat del /f Update.bat
        timeout /t 2 /nobreak >nul
        cls
        goto :setting
    )
rem ����Odyink
    :setOdyink
    echo ����Odyink
    set website=https://ody.ink/odyink
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
    :exit
    echo �����˳�Odyink...
    if exist index.html del index.html
    if exist Blog*.bat del Blog*.bat
    if exist Blog\*.*t del /f /s /q Blog\*.*t >nul
    timeout /t 2 /nobreak >nul
    cls
    exit