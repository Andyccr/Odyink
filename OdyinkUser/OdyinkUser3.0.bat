@echo off
::3.0
chcp 936 >nul
title Odyink [for WindowsUser]
color 0b
cd /d %~dp0
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:check
if not exist Odyink\website.bat goto install
cd Odyink\
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
::checkfile
echo ����Ƿ����PowerShell
if not exist %SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe (
    echo ���Ҳ���PowerShell
    goto exit
)
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:checknet
echo ���������
if exist index.html del index.html
PowerShell wget https://www.kernel.org/index.html -outfile index.html >nul
if exist index.html (
    if exist index.html del index.html
    goto get
)
echo �������!
goto exit
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
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
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:VB
cls
echo       OdyInk
echo.
echo.
echo.
echo.
call Bloglist.bat
echo.
echo.
call Blognum.bat
if "%Blognum:~-1%"==" " set Blognum=%Blognum:~0,-1%
echo    Ŀǰ��%Blognum%ƪ����
echo.
echo.
echo      r.ˢ��  q.�˳�
set EBlognum=
set /p EBlognum=........������ţ�
cls
if "%EBlognum%"=="r" goto get
if "%EBlognum%"=="q" goto exit
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:NBBlog
cls
set jump=
set find=
if "%EBlognum:~-1%"==" " set EBlognum=%EBlognum:~0,-1%
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
if exist exdoc.bat del exdoc.bat
cls
::-----------------------------------------������-----------------------------------------
echo ���ڲ��Ҳ���������...
PowerShell wget %website%/Blog/"%EBlognum%.txt" -outfile Blog\%EBlognum%.txt >nul
cls
::-----------------------------------------������-----------------------------------------
if not exist Blog\"%EBlognum%.txt" (
    echo �����²����ڻ��������
    echo ���������б�
    timeout /t 2 /nobreak >nul
    goto VB
)
::-----------------------------------------������-----------------------------------------
type Blog\%EBlognum%.txt
echo.
echo.
echo.
echo b.��һƪ n.��һƪ q.�����б�
echo.
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
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:backBlog
set StartEBlognum=%EBlognum%
cls
echo �����������ݿ����Ժ�...
:Back
set /a EBlognum=%EBlognum%-1
set /a AV=%StartEBlognum%-%EBlognum%
echo if "%%NEB%EBlognum%%%"=="E" set EBlognum=%EBlognum% >>exdoc.bat
echo if "%%NEB%EBlognum%%%"=="E" set find=fd>>exdoc.bat
echo if "%%find%%"=="fd" set jump=jpn>>exdoc.bat
echo if "%%find%%"=="fd" goto :EOF>>exdoc.bat
if %AV%==101 goto NBBlog
if %AV%==100 call exdoc.bat
if "%jump%"=="jpn" goto NBBlog
goto Back
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����С�ֽ���~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:nextBlog
set StartEBlognum=%EBlognum%
cls
echo �����������ݿ����Ժ�...
:Next
set /a EBlognum=%EBlognum%+1
set /a AV=%EBlognum%-%StartEBlognum%
echo if "%%NEB%EBlognum%%%"=="E" set EBlognum=%EBlognum% >>exdoc.bat
echo if "%%NEB%EBlognum%%%"=="E" set find=fd>>exdoc.bat
echo if "%%find%%"=="fd" set jump=jpn>>exdoc.bat
echo if "%%find%%"=="fd" goto :EOF>>exdoc.bat
if %AV%==101 goto NBBlog
if %AV%==100 call exdoc.bat
if "%jump%"=="jpn" goto NBBlog
goto Next
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:install
echo ����Odyink
set /p website=������IP[/Ŀ¼]��
echo ��������Odyink...
if "%website:~-1%"=="/" set website=%website:~0,-1%
mkdir Odyink >nul
mkdir Odyink\Blog >nul
cd Odyink
if exist ServerOK del ServerOK
if exist Blog*.bat del Blog*.bat
if exist exdoc.bat del exdoc.bat
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
echo set website=%website% >website.bat
cd ..\
cls
echo �������
timeout /t 2 /nobreak >nul
cls
goto check
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
:ServerError
echo ����������
:exit
echo �����˳�Odyink...
if exist index.html del index.html
if exist ServerOK del ServerOK
if exist Blog*.bat del Blog*.bat
if exist exdoc.bat del exdoc.bat
if exist Blog\*.txt del /f /s /q Blog\*.txt >nul
timeout /t 2 /nobreak >nul
cls
::::::::::::::::::::::::::::::::::::::::::::::::::���Ƿֽ���::::::::::::::::::::::::::::::::::::::::::::::::::
exit