@echo off
rem 6.1
rem ��ʼ��
    chcp 936 >nul
    title Odyink Server
    color 07
    cd /d %~dp0
    cls
    setlocal enabledelayedexpansion
rem ��ⰲװ
    :Check
    if not exist odyink\doclist.bat goto :Install
    cd odyink\
rem У������
    :ViewDoc
    cls
    title Odyink Server
    rem �����б�
        call doclist.bat
        echo.
        echo.
        call docnum.bat
        if "%docNum:~-1%"==" " set docNum=%docNum:~0,-1%
        echo Ŀǰ��%docNum%ƪ����
        echo.
        if /i "%inputDocNum%"=="d" goto :DelDoc
        echo a.�������� f.�������� d.ɾ������
        echo s.��������            q.�˳�����
        set inputDocNum=none
        set /p inputDocNum=������ţ�
        cls
        if /i "%inputDocNum%"=="a" goto :AddDoc
        if /i "%inputDocNum%"=="f" goto :FindDoc
        rem goto :ViewDoc��������ԭ���ô������б�֪
        rem ps: inputDocNum%=d
        if /i "%inputDocNum%"=="d" goto :ViewDoc
        if /i "%inputDocNum%"=="s" goto :Setting
        if /i "%inputDocNum%"=="q" ( cls & exit )
    rem �������
        rem Ԥ����
            :NextBackDoc
            set docType=none
        rem ��������Ƿ����
            if not exist doc\"%inputDocNum%.bat" (
                if not exist doc\"%inputDocNum%.txt" (
                    echo ���²�����
                    timeout /t 2 /nobreak >nul
                    goto :ViewDoc
                )
            )
        rem ��ʾ�ı�����Batch
            rem �򸴺Ͼ��б���Ϊ���Ͼ�ǰ�ı���ʹ�����ӳٱ�����þ��б����Ķ�ֵ̬
            if exist doc\"%inputDocNum%.bat" (
                set docType=bat
                title Odyink Server
                echo ����Batch��չ
                echo ����odyink\doc\%inputDocNum%.bat�в鿴����
                echo ��Batch��չ������ִ�к���Ը�
                echo �鿴������Ϊ�˷�����!!!
                echo.
                echo     y.ȷ��ִ��  q.�����б�
                echo     c.�༭����  t.���ı���
                echo       b.��һƪ  n.��һƪ
                set batActCode=none
                set /p batActCode=�������:
                if /i "!batActCode!"=="b" goto :BackDoc
                if /i "!batActCode!"=="n" goto :NextDoc
                if /i "!batActCode!"=="t" goto :ChangeTitle
                if /i "!batActCode!"=="c" (
                    notepad.exe .\doc\%inputDocNum%.!docType!
                    cls
                    goto :NextBackDoc
                )
                if /i "!batActCode!"=="y" (
                    cls
                    cmd /c .\doc\%inputDocNum%.bat
                    cls
                    rem ���³�ʼ��
                        rem ����if���Ͼ䲻����@echo off�ᱨ�����Ƶ�:DocActInput��һ��
                        rem ����if���Ͼ䲻��cd�������Զ��ָ�(ԭ����)������cd�ᱨ��
                        chcp 936 >nul
                        title Odyink Server
                        color 07
                    echo   b.��һƪ q.�����б� n.��һƪ
                    echo c.�༭���� t.���ı��� r.����ִ��
                    goto :DocActInput
                ) else (
                    goto :ViewDoc
                )
            )
        rem ��ʾ�ı�����Text
            set docType=txt
            title !title%inputDocNum%!
            type doc\%inputDocNum%.txt
            echo.
            echo.
            echo b.��һƪ q.�����б� n.��һƪ
            echo     c.�޸�����  t.���ı���
            echo.
        rem ���²���
            :DocActInput
            @echo off
            set docActCode=none
            set /p docActCode=������ţ�
            if /i "%docActCode%"=="b" goto :BackDoc
            if /i "%docActCode%"=="n" goto :NextDoc
            if /i "%docActCode%"=="q" goto :ViewDoc
            if /i "%docActCode%"=="t" goto :ChangeTitle
            if /i "%docActCode%"=="c" (
                notepad.exe .\doc\%inputDocNum%.%docType%
                cls
                goto :NextBackDoc
            )
            if /i "%docActCode%"=="r" (
                if /i "%docType%"=="bat" (
                    cls
                    goto :NextBackDoc
                )
            )
            echo ������Ч
            echo.
            goto :DocActInput
        rem ��һƪ����
            :BackDoc
            set startInputDocNum=%inputDocNum%
            cls
            :Back
            set /a inputDocNum=%inputDocNum%-1
            set /a AV=%startInputDocNum%-%inputDocNum%
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NextBackDoc
            if %inputDocNum%==-1 goto :NextBackDoc
            if exist doc\%inputDocNum%.bat goto :NextBackDoc
            if exist doc\%inputDocNum%.txt goto :NextBackDoc
            goto :Back
        rem ��һƪ����
            :NextDoc
            set startInputDocNum=%inputDocNum%
            cls
            :Next
            set /a inputDocNum=%inputDocNum%+1
            set /a AV=%inputDocNum%-%startInputDocNum%
            rem �����¼�಻�ɴ���100
            if %AV%==100 goto :NextBackDoc
            if exist doc\%inputDocNum%.bat goto :NextBackDoc
            if exist doc\%inputDocNum%.txt goto :NextBackDoc
            goto :Next
        rem ���ı���
            :ChangeTitle
            cls
            echo ����q�˳�
            echo �س�Ϊԭ����:!title%inputDocNum%!
            set newTitle=!title%inputDocNum%!
            set /p newTitle=�±���:
            if /i "%newTitle%"=="q" goto :NextBackDoc
            echo set title%inputDocNum%=%newTitle% >>doctitle.bat
            call doctitle.bat
            cls
            goto :NextBackDoc
    rem ��������
        :FindDoc
        rem Print title
            if exist titlelist.tmp del /f /q titlelist.tmp
            set printTitleNum=0
            :PrintTitleLoop
                if "!NEB%printTitleNum%!"=="E" (
                    rem ע��
                    echo %printTitleNum%.!title%printTitleNum%!>>titlelist.tmp
                    set /a printTitleNum+=1
                    goto :PrintTitleLoop
                )
                if /i not "!NEB%printTitleNum%!"=="Del" goto :Find
                set /a printTitleNum+=1
                goto :PrintTitleLoop
            :Find
                set /p keywords=�ؼ���:
                findstr "%keywords%" .\titlelist.tmp
                if exist titlelist.tmp del /f /q titlelist.tmp
                echo.
                echo q.������ҳ
                set inputDocNum=none
                set /p inputDocNum=������ţ�
                cls
                if /i "%inputDocNum%"=="q" goto :ViewDoc
                goto :NextBackDoc
rem ��������
    :AddDoc
    cls
    rem �����赼�����µ���Ϣ
        echo ֧��GB*�����txt��bat�ļ�
        echo ֧���Ϸ��ļ�(��Ҫ�ּ�)
        echo q.����
        echo.
        rem �Թ���Ա��������޷��϶���������
        set docPath=none
        set /p docPath=�ļ�����·����
        if %docPath%==q goto :ViewDoc
        if not exist %docPath% goto :NotExistDoc
        rem �������Ի�ȡ������
            set docType=none
            if %docPath:~-4,-3%==. set docType=%docPath:~-3%
            if %docPath:~-5,-4%==. set docType=%docPath:~-4,-1%
            if /i not "%docType%"=="bat" (
                if /i not "%docType%"=="txt" (
                    echo �ļ���֧��
                    timeout /t 3 /nobreak >nul
                    goto :AddDoc
                )
            )
            if /i "%docType%"=="txt" set docType=txt
            if /i "%docType%"=="bat" set docType=bat
        rem ���±��ⲻ�ܺ���Ӣ����
        echo ���±��ⲻ�ܺ�����������
        echo ���ļ����Ǳ�����ֱ�ӻس�
        set newDocTitle=none
        set /p newDocTitle=���±��⣺
        if /i "%newDocTitle%"=="q" goto :AddDoc
        if "%newDocTitle%"=="none" call :GetDocName %docPath%
        goto :Jump1
            :GetDocName
                set newDocTitle=%~n1
                goto :eof
        :Jump1
    rem Ԥ������(Text)
        rem Ϊ��ȷ���Ƿ�ΪGB*����
        if /i "%docType%"=="txt" (
            cls
            type %docPath%
            echo.
            echo.
            echo ���������ʾ���� "�س�" ��ʼ����
            echo ����쳣����"q"�˳���������¼������
            set addTextCheck=none
            set /p addTextCheck=������:
            if /i "!addTextCheck!"=="none" (
                rem ռλ
            ) else (
                goto :AddDoc
            )
        )
    rem ��ʼ��������
        cls
        rem Ԥ����
            set docNum=none
            call docnum.bat
            if "%docNum:~-1%"==" " set docNum=%docNum:~0,-1%
            set newDocNum=none
            set /a newDocNum=%docNum%+1
            call docallnum.bat
            if "%docAllnum:~-1%"==" " set docAllnum=%docAllnum:~0,-1%
            set /a newDocAllNum=%docAllnum%+1
        rem д��
            rem д��������
                echo set docNum=%newDocNum% >docnum.bat
                echo set docAllnum=%newDocAllNum% >docallnum.bat
                echo set NEB%newDocAllNum%=E>>docexist.bat
                echo set title%newDocAllNum%=%newDocTitle% >>doctitle.bat
                echo if not %%NEB%newDocAllNum%%%==Del echo %newDocAllNum%.%%title%newDocAllNum%%% >>doclist.bat
            rem д����־
                echo %date:~0,-2%%time% copy %docPath% to .\odyink\doc\ (num:%newDocAllNum%) >>doclog.log
            rem ��������
                if exist %docPath% copy %docPath% doc\%newDocAllNum%.%docType% >nul
                if exist doc\%newDocAllNum%.%docType% (
                    echo ����ɹ�
                ) else (
                    echo ����ʧ��
                )
            timeout /t 2 /nobreak >nul
            goto :AddDoc
    rem ���²�����
        :NotExistDoc
        cls
        echo ���²�����
        timeout /t 3 /nobreak >nul
        goto :AddDoc
rem ɾ������
    :DelDoc
    set docNum=none
    call docnum.bat
    rem ������ɾ�����µ���Ϣ
        :InputDelDocNum
        echo ����q�˳�ɾ��
        set willDelDocNum=none
        set /p willDelDocNum=Ҫɾ��������ţ�
        if /i "%willDelDocNum%"=="q" (
            set inputDocNum=none
            goto :ViewDoc
        )
        if not exist doc\"%willDelDocNum%.*t" goto :DelDocError
        :BackDelyn
        set delDocyn=none
        set /p delDocyn=�Ƿ�ɾ��yn:
        if /i "%delDocyn%"=="y" goto :DelDocNow
        if /i "%delDocyn%"=="n" goto :InputDelDocNum
        echo ������Ч
        goto :BackDelyn
    rem ��ʼɾ������
        :DelDocNow
        echo set NEB%willDelDocNum%=Del >>docdel.bat
        set /a newDocNum=%docNum%-1
        echo set docNum=%newDocNum% >docnum.bat
        echo %date:~0,-2%%time% del %willDelDocNum% from .\odyink\doc\ (num:%willDelDocNum%) >>doclog.log
        del /q doc\%willDelDocNum%.*t
        echo ɾ�����
        timeout /t 2 /nobreak >nul
        cls
        goto :ViewDoc
    rem ���²�����
        :DelDocError
        echo ���²�����
        goto :InputDelDocNum
rem ����
    :Setting
    cls
    echo c.�������
    echo d.ж�����
    echo q.������ҳ
    echo.
    set inputSettingNum=none
    set /p inputSettingNum=������:
    if /i "%inputSettingNum%"=="c" goto :CleanData
    if /i "%inputSettingNum%"=="d" goto :RemoveOdyink
    if /i "%inputSettingNum%"=="q" goto :ViewDoc
    cls
    echo ������Ч
    timeout /t 2 /nobreak >nul
    goto :Setting
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
rem �������
    :CleanData
    cls
    echo ����yes���س���ȷ���������
    echo ����������Ϊȡ��
    set cleanOdyinkyn=none
    set /p cleanOdyinkyn=������:
    if /i not "%cleanOdyinkyn%"=="yes" goto :Setting
    cls
    echo ����yes���س��ٴ�ȷ��
    echo ����������Ϊȡ��
    set cleanOdyinkyn=none
    set /p cleanOdyinkyn=������:
    if /i not "%cleanOdyinkyn%"=="yes" goto :Setting
    cd /d %~p0
    rmdir /s /q %~p0odyink\
    echo ����re���㿪ʼ������������
    cls
    echo ����re���㿪ʼ
    echo �س��˳�
    set reOrNot=none
    set /p reOrNot=
    cls
    if /i "%reOrNot%"=="re���㿪ʼ������������" start https://www.bilibili.com/bangumi/play/ep373924
    if /i "%reOrNot%"=="re" (
        cmd /c %~f0
    ) else (
        exit
    )
rem ��װ
    :Install
    echo �س���װOdyink
    pause >nul
    cls
    mkdir odyink\doc 2>nul
    cd odyink\
    if exist doc\*.*t del /f /s /q doc\*.*t >nul
    rem �½��ļ�д����Ϣ
        echo set docNum=1 >docnum.bat
        echo set docAllnum=0 >docallnum.bat
        echo set NEB0=E>>docexist.bat
        echo set title0=��ӭʹ��Odyink >doctitle.bat
        echo call docexist.bat >>doclist.bat
        echo call docdel.bat>>doclist.bat
        echo call doctitle.bat>>doclist.bat
        echo if not %%NEB0%%==Del echo 0.%%title0%%>>doclist.bat
        echo rem Docdel>docdel.bat
        echo [Doclog]>doclog.log
        echo Odyink����Andy(python)��SMG(Batch)�����������и��˲������ >>doc\0.txt
    echo ��װ���
    timeout /t 2 /nobreak >nul
    cls
    echo ������վ·��Ϊ��%~dp0odyink\
    echo �س�������װ
    pause >nul
    %0