@echo off
::2.0
chcp 936 >nul
title Odyink [for WindowsServer]
color 0b
if exist ServerOK del ServerOK
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:check
if not exist Odyink\Odyink.txt goto install
cd Odyink\
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
echo ����Ƿ����PowerShell
set ps=
if not exist %SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe ( 
    set ps=notps
    goto sign_admin
)
echo ���������
set net=
if exist index.html del index.html
PowerShell wget https://www.kernel.org/index.html -outfile index.html >nul
if exist index.html (
    if exist index.html del index.html
    set net=ok
    echo ServerOK >ServerOK
)
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:sign_admin
echo SF
cls
echo.
if "%ps%"=="notps" echo ���Ҳ���PowerShell�޷��������
if "%net%"=="ok" echo �������ɹ�����
if "%net%"=="" echo �������
echo.
echo.
echo.
echo �������˺�����
echo ����q�˳�
echo.
set /p usernum=�˺ţ�
if "%usernum%"=="q" goto end
echo.
set /p passwd=���룺
if "%passwd%"=="q" goto end
cls
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set /a ipkey=(%usernum%*%passwd:~-1%+%passwd%*%usernum:~0,1%)*(%usernum:~-1%-%passwd:~0,1%)
cls
::...............������4320960...............
if "%ipkey%" == "4320960" goto Admin
echo �˺��������
timeout /t 2 /nobreak >nul
cls
goto sign_admin
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:Admin
cls
echo ******************************
echo **          �����          **
echo ******************************
echo **                          **
echo **  1.У�Ĳ���              **
echo **  2.��������              **
echo **  3.ɾ������              **
echo **  4.ϵͳ��Ϣ              **
echo **  5.�˳���¼              **
echo **                          **
echo ******************************
echo.
echo.
set Adnum=
set /p Adnum=��ţ�
cls
if "%Adnum%"=="1" goto VB
if "%Adnum%"=="2" goto ipBlog
if "%Adnum%"=="3" goto DBlog
if "%Adnum%"=="4" goto C
if "%Adnum%"=="5" goto exitAdmin
echo ������Ч
timeout /t 2 /nobreak >nul
goto Admin
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:VB
cls
echo     OdyInkBlog
echo.
echo.
echo.
echo.
call Bloglist.bat
echo.
echo.
call Blognum.bat
if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
echo   Ŀǰ��%Blognum%ƪ����
echo.
echo.
echo         q.������ҳ
set EBlognum=
set /p EBlognum=������ţ�
cls
if "%EBlognum%"=="q" goto Admin
if "%EBlognum%"=="" (
    echo �����²����ڻ��ѱ�����Աɾ��
    echo ���������б�
    timeout /t 2 /nobreak >nul
    goto VB
)
if "%EBlognum%"==" " (
    echo �����²����ڻ��ѱ�����Աɾ��
    echo ���������б�
    timeout /t 2 /nobreak >nul
    goto VB
)
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:NBBlog
if not exist Blog\"%EBlognum%.txt" (
    echo �����²����ڻ��ѱ�����Աɾ��
    echo ���������б�
    timeout /t 2 /nobreak >nul
    goto VB
)
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
type Blog\%EBlognum%.txt
echo.
echo.
echo.
echo b.��һƪ q.�����б� n.��һƪ
echo.
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
echo ������Ч����������
echo.
goto BlogconNE
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:nextBlog
set StartEBlognum=%EBlognum%
cls
:Next
set /a EBlognum=%EBlognum%+1
set /a AV=%EBlognum%-%StartEBlognum%
if %AV%==101 goto NBBlog
if exist Blog\%EBlognum%.txt goto NBBlog
goto Next
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:ipBlog
cls
set Docname=
set Blognum=
set NewBlognum=
set Blogtitle=
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo.
echo ֧�ֱ���ANSI GBK (UTF-8��Ӣ�ģ�����)
echo ֧���ļ���ʽtxt
echo ֧���Ϸ��ļ�(�ǵûس�)
echo.
echo.
echo.
echo q.����
set /p Docname=�����ļ���(�޺�׺)��
if "%Docname%"=="q" goto Admin
if exist "%Docname%" goto iptitle
if not exist ..\"%Docname%.txt" goto CantipBlog
:iptitle
call Blognum.bat
if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
set /a NewBlognum=%Blognum%+1
call BlogAnum.bat
if "%BlogAnum:~-1%"==" " set BlogAnum=%BlogAnum:~0,-1%
set /a NewBlogAnum=%BlogAnum%+1
set /p Blogtitle=���±��⣺
if "%Blogtitle%"=="q" goto ipBlog
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cls
echo set Blognum=%NewBlognum% >Blognum.bat
echo set BlogAnum=%NewBlogAnum% >BlogAnum.bat
echo set NEB%NewBlogAnum%=E>>Bloglog.bat
echo if not %%NEB%NewBlogAnum%%%==Del echo %NewBlogAnum%.%Blogtitle% >>Bloglist.bat
if exist ..\"%Docname%.txt" copy  ..\"%Docname%.txt" Blog\%NewBlogAnum%.txt >nul
if exist "%Docname%" copy "%Docname%" Blog\%NewBlogAnum%.txt >nul
echo �������
timeout /t 2 /nobreak >nul
goto ipBlog
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:CantipBlog
cls
echo �����ļ��������Ϲ淶�������ļ�������
echo ��������Ч�����ļ���
timeout /t 3 /nobreak >nul
goto ipBlog
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:DBlog
cls
set willDelBlog=
set DelBlogyn=
call Bloglist.bat
call Blognum.bat
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:DelBlog
echo ����q�˳�ɾ��
set /p willDelBlog=Ҫɾ��������ţ�
if "%willDelBlog%"=="" goto DelBlogE
if "%willDelBlog%"=="q" goto Admin
if not exist Blog\"%willDelBlog%.txt" goto DelBlogE
:BackDelyn
set /p DelBlogyn=�Ƿ�ɾ��yn:
if "%DelBlogyn%"=="y" goto DelBlognow
if "%DelBlogyn%"=="n" goto DelBlog
echo ������Ч
goto BackDelyn
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:DelBlognow
del Blog\%willDelBlog%.txt
echo set NEB%willDelBlog%=Del >>Blogdel.bat
set /a NewBlognum=%Blognum%-1
echo set Blognum=%NewBlognum% >Blognum.bat
echo ɾ�����
timeout /t 2 /nobreak >nul
cls
goto DBlog
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:DelBlogE
echo �����²����ڻ��ѱ�����Աɾ��
goto DelBlog
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:C
echo ����Ƿ����PowerShell
set ps=
if not exist %SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe ( 
    set ps=notps
)
echo ���������
set net=
if exist index.html del index.html
PowerShell wget https://www.kernel.org/index.html -outfile index.html >nul
if exist index.html (
    if exist index.html del index.html
    set net=ok
    echo ServerOK >ServerOK
)
cls
echo.
if "%ps%"=="notps" echo ���Ҳ���PowerShell�޷��������
if "%net%"=="ok" echo �������ɹ�����
if "%net%"=="" echo �������
echo.
echo.
systeminfo
echo.
echo.
echo.
echo �س�����
pause >nul
goto Admin
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:install
echo �س���װOdyink
echo ����Ѱ�װ�����ʾ���ļ��𻵣����ֶ��˳�����ļ�������
pause >nul
echo ���ڰ�װOdyink
mkdir Odyink >nul
mkdir Odyink\Blog >nul
cd Odyink
if exist ServerOK del ServerOK
if exist BlogAnum.bat del BlogAnum.bat
if exist Blognum.bat del Blognum.bat
if exist Bloglist.bat del Bloglist.bat
if exist Bloglog.bat del Bloglog.bat
if exist Blogdel.bat del Blogdel.bat
if exist exdoc.bat del exdoc.bat
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Odyink for WindowsServer(By SMG)>Odyink.txt
echo set Blognum=1 >Blognum.bat
echo set BlogAnum=0 >BlogAnum.bat
echo set NEB0=E>>Bloglog.bat
echo call Bloglog.bat >>Bloglist.bat
echo if exist Blogdel.bat call Blogdel.bat>>Bloglist.bat
echo if not %%NEB0%%==Del echo 0.��ӭʹ��Odyink>>Bloglist.bat
echo ��ӭʹ��Odyink for Windows Server(By SMG)>>Blog\0.txt
echo.>>Blog\0.txt
echo.>>Blog\0.txt
echo.>>Blog\0.txt
echo Odyink����Andy(python)��SMG(Batch)�����������и��˲������ >>Blog\0.txt
echo.>>Blog\0.txt
cd ..\
timeout /t 2 /nobreak >nul
cls
echo ��װ���
timeout /t 2 /nobreak >nul
cls
echo ��ʼ�˺�:123456
echo ��ʼ����:123456
echo �����㷨:(�˺�X����ĩλ+����X�˺���λ)X(�˺�ĩλ-������λ)=������
echo �˺����붼�����Ǵ������Ҳ��ɳ���6λ
timeout /t 35
cls
goto check
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:exitAdmin
cls
set usernum=
set passwd=
set ipkey=
echo ���˳���¼
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:end
echo �����˳�Odyink...
if exist ServerOK del ServerOK
timeout /t 2 /nobreak >nul
cls
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
exit