@echo off
rem 5.6
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
        if not exist odyink\website.bat goto :SetOdyink
        cd odyink\
    rem �������������
        if exist ..\wget.exe copy ..\wget.exe .\wget.exe
        rem Ϊ�����Բ���֤��(����ȫ)
        set WO=-q --no-check-certificate -P ./
        set pswget=PowerShell Invoke-WebRequest
        set PSO=-outfile
rem ������
    rem �����б�
        :Get
        cls
        echo ���������б����Ժ�...
        call website.bat
        if "%website:~-1%"==" " set website=%website:~0,-1%
        rem ɾ�����ļ�
            if exist doc*.bat del doc*.bat
            if exist doc\*.*t del /f /s /q doc\*.*t >nul
        rem �������б��ļ�
            set net=ok
            echo ��������doclist.bat
                wget %WO% %website%/doclist.bat 2>nul
                if not exist doclist.bat %pswget% %website%/doclist.bat %PSO% doclist.bat >nul
                if not exist doclist.bat (
                    set net=error
                    goto :ViewDoc
                )
            echo ��������docnum.bat
                wget %WO% %website%/docnum.bat 2>nul
                if not exist docnum.bat %pswget% %website%/docnum.bat %PSO% docnum.bat >nul
                if not exist docnum.bat (
                    set net=error
                    goto :ViewDoc
                )
            echo ��������docexist.bat
                wget %WO% %website%/docexist.bat 2>nul
                if not exist docexist.bat %pswget% %website%/docexist.bat %PSO% docexist.bat >nul
                if not exist docexist.bat (
                    set net=error
                    goto :ViewDoc
                )
            echo ��������docdel.bat
                wget %WO% %website%/docdel.bat 2>nul
                if not exist docdel.bat %pswget% %website%/docdel.bat %PSO% docdel.bat >nul
                if not exist docdel.bat (
                    set net=error
                    goto :ViewDoc
                )
            echo ��������doctitle.bat
                wget %WO% %website%/doctitle.bat 2>nul
                if not exist doctitle.bat %pswget% %website%/doctitle.bat %PSO% doctitle.bat >nul
                if not exist doctitle.bat (
                    set net=error
                    goto :ViewDoc
                )
        cls
    rem �����б�
        :ViewDoc
        title Odyink User
        cls
        if /i "%net%"=="ok" (
            call doclist.bat
        ) else (
            echo �������
        )
        echo.
        echo.
        set docNum=0
        if /i "%net%"=="ok" call docnum.bat
        if "%docNum:~-1%"==" " set docNum=%docNum:~0,-1%
        echo Ŀǰ��%docNum%ƪ����
        echo.
        echo r.ˢ�� q.�˳�
        echo  s.��������
        set inputDocNum=none
        set /p inputDocNum=������ţ�
        cls
        if /i "%inputDocNum%"=="r" goto :Get
        if /i "%inputDocNum%"=="q" goto :Exit
        if /i "%inputDocNum%"=="s" goto :Setting
    rem �����������
        rem Ԥ����
            :NextBackDoc
            cls
            set findExistDoc=none
            if "%inputDocNum:~-1%"==" " set inputDocNum=%inputDocNum:~0,-1%
            if exist doc\*.*t del /f /s /q doc\*.*t >nul
            cls
        rem ��������
            echo ����������
                wget %WO%doc/ %website%/doc/%inputDocNum%.bat 2>nul
                if not exist %inputDocNum%.bat %pswget% %website%/doc/%inputDocNum%.bat %PSO% .\doc\%inputDocNum%.bat >nul
                wget %WO%doc/ %website%/doc/%inputDocNum%.txt 2>nul
                if not exist %inputDocNum%.txt %pswget% %website%/doc/%inputDocNum%.txt %PSO% .\doc\%inputDocNum%.txt >nul
            cls
        rem ��������Ƿ����
            if not exist doc\"%inputDocNum%.bat" (
                if not exist doc\"%inputDocNum%.txt" (
                    echo ���²�����
                    timeout /t 2 /nobreak >nul
                    goto :ViewDoc
                )
            )
        rem ��ʾ�ı�����Batch
            rem �򸴺Ͼ��б���Ϊ���Ͼ�ǰ�ı���,ʹ�����ӳٱ�����þ��б����Ķ�ֵ̬
            if exist doc\"%inputDocNum%.bat" (
                title Odyink User
                echo ����Batch��չ
                echo ����odyink\doc\%inputDocNum%.bat�в鿴����
                echo ��Batch��չ������ִ�к���Ը�
                echo �鿴������Ϊ�˷�����!!!
                echo.
                echo y.ȷ��ִ�� q.�����б�
                echo   b.��һƪ n.��һƪ
                set batActCode=none
                set /p batActCode=�������:
                if /i "!batActCode!"=="b" goto :BackDoc
                if /i "!batActCode!"=="n" goto :NextDoc
                if /i "!batActCode!"=="y" (
                    cls
                    cmd /c .\doc\%inputDocNum%.bat
                    cls
                    rem ���³�ʼ��
                        rem ����if���Ͼ䲻��@echo off��cd�������Զ��ָ�(ԭ����)һ�þͻᱨ��
                        chcp 936 >nul
                        title Odyink User
                        color 07
                    echo b.��һƪ q.�����б� n.��һƪ
                    echo          r.ˢ����չ
                    goto :DocActInput
                ) else (
                    goto :ViewDoc
                )
            )
        rem ��ʾ�ı�����Text
            :ViewText
            type doc\%inputDocNum%.txt
            title !title%inputDocNum%!
            echo.
            echo.
            echo b.��һƪ q.�����б� n.��һƪ
            echo     r.ˢ������  s.��������
            echo.
        rem ���²���
            :DocActInput
            set docActCode=none
            set /p docActCode=������ţ�
            if /i "%docActCode%"=="b" goto :BackDoc
            if /i "%docActCode%"=="n" goto :NextDoc
            if /i "%docActCode%"=="q" goto :ViewDoc
            if /i "%docActCode%"=="r" goto :NextBackDoc
            if /i "%docActCode%"=="s"  (
                if exist doc\%inputDocNum%.txt (
                    set getTureTitle=!title%inputDocNum%!
                    if "!getTureTitle:~-1!"==" " set getTureTitle=!getTureTitle:~0,-1!
                    copy doc\%inputDocNum%.txt "%homeDrive%%homePath%\downloads\!getTureTitle!.txt"
                    if exist %homeDrive%%homePath%\downloads\!getTureTitle!.txt (
                        cls
                        echo ����ɹ�
                        echo �ѱ����� "����" �ļ���
                        timeout /t 5 /nobreak >nul
                        cls
                        goto :ViewText
                    ) else (
                        cls
                        echo ����ʧ��
                        timeout /t 2 /nobreak >nul
                        cls
                        goto :ViewText
                    )
                )
            )
            echo ������Ч����������
            echo.
            goto :DocActInput
        rem ��һƪ����
            :BackDoc
            set startInputDocNum=%inputDocNum%
            cls
            echo ���ڼ������Ժ�...
            :Back
            set /a inputDocNum=%inputDocNum%-1
            set /a AV=%startInputDocNum%-%inputDocNum%
            call set findExistDoc=%%NEB%inputDocNum%%%
            if "%findExistDoc%"=="E" goto :NextBackDoc
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NextBackDoc
            goto :Back
        rem ��һƪ����
            :NextDoc
            set startInputDocNum=%inputDocNum%
            cls
            echo ���ڼ������Ժ�...
            :Next
            set /a inputDocNum=%inputDocNum%+1
            set /a AV=%inputDocNum%-%startInputDocNum%
            call set findExistDoc=%%NEB%inputDocNum%%%
            if "%findExistDoc%"=="E" goto :NextBackDoc
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NextBackDoc
            goto :Next
rem ����
    :Setting
    cls
    echo u.������
    echo d.ж�����
    echo c.������ַ
    echo q.�����б�
    echo.
    set inputSettingNum=none
    set /p inputSettingNum=������:
    if /i "%inputSettingNum%"=="u" goto :Update
    if /i "%inputSettingNum%"=="d" goto :RemoveOdyink
    if /i "%inputSettingNum%"=="c" goto :ChangeWebsite
    if /i "%inputSettingNum%"=="q" goto :ViewDoc
    cls
    echo ������Ч
    timeout /t 2 /nobreak >nul
    goto :Setting
rem ������ַ
    :ChangeWebsite
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
        goto :Setting
    )
rem ж��
    :RemoveOdyink
    cls
    echo ����yes���س���ȷ��ж��Odyink
    echo ����������Ϊȡ��ж��
    set delOdyinkyn=none
    set /p delOdyinkyn=������:
    if /i not "%delOdyinkyn%"=="yes" goto :Setting
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
    :Update
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
        cd .\odyink\
        timeout /t 2 /nobreak >nul
        cls
        goto :Setting
    )
    set updateYN=
    call Update.bat
    rem ��ǰ�汾(����)
    set version=6
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
                goto :Setting
            )
    ) else (
        echo ��ǰ�������°汾
        if exist Update.bat del /f Update.bat
        cd .\odyink\
        timeout /t 2 /nobreak >nul
        cls
        goto :Setting
    )
rem ����Odyink
    :SetOdyink
    echo ����Odyink
        set website=https://ody.ink
        set /p website=������IP[/Ŀ¼]��
        if "%website:~-1%"=="/" set website=%website:~0,-1%
    echo ��������Odyink...
        mkdir odyink\doc 2>nul
        cd odyink\
        if exist doc*.bat del doc*.bat
        if exist doc\*.*t del /f /s /q doc\*.*t >nul
        echo set website=%website% >website.bat
        cls
    echo �������
    timeout /t 2 /nobreak >nul
    %0
rem �˳�
    :Exit
    echo �����˳�Odyink...
    if exist index.html del index.html
    if exist doc*.bat del doc*.bat
    if exist doc\*.*t del /f /s /q doc\*.*t >nul
    timeout /t 2 /nobreak >nul
    cls
    exit