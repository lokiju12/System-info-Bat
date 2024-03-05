@echo off
mode con: cols=120 lines=200
setlocal enabledelayedexpansion

title 시스템 정보 조회

echo.
set bar=echo =======================================================
%bar%
echo.
echo 1. 사용자 정보
echo.
for /f "tokens=* delims=" %%a in ('wmic useraccount where name^='%USERNAME%' get Caption /value ^| findstr "Caption"') do set "Caption=%%a"
set "Caption_slice=!Caption:~8!"
echo 도메인 계정 : %Caption_slice%
echo.
for /f "tokens=* delims=" %%a in ('wmic useraccount where name^='%USERNAME%' get Description /value ^| findstr "Description"') do set "Description=%%a"
set "Description_slice=!Description:~12!"
echo 사용자 정보 : %Description_slice%
echo.
for /f "tokens=* delims=" %%a in ('hostname') do set "pcname=%%a"
echo 컴퓨터 이름 : %pcname%
echo.
for /f "tokens=* delims=" %%a in ('ipconfig ^| findstr IPv4') do set "ipinfo=%%a"
set "ipinfo_slice=!ipinfo:~31!"
echo IP주소 : %ipinfo_slice%
echo.
%bar%
echo.
echo 2. 하드웨어 정보
echo.
for /f "tokens=1* delims==" %%a in ('wmic bios get serialnumber /value') do (
    set "line=%%a"
    if "!line!"=="SerialNumber" (
        set "serial=%%b"
    )
)
echo 데스크탑 : %serial%
echo.
for /f "tokens=* delims=" %%a in ('powershell "[System.Text.Encoding]::ASCII.GetString((Get-CimInstance WmiMonitorID -Namespace root\wmi)[0].SerialNumberID -notmatch 0)"') do set "monitor1=%%a"
for /f "tokens=* delims=" %%a in ('powershell "[System.Text.Encoding]::ASCII.GetString((Get-CimInstance WmiMonitorID -Namespace root\wmi)[1].SerialNumberID -notmatch 0)"') do set "monitor2=%%a"
echo 모니터 1 : %monitor1%
echo.
echo 모니터 2 : %monitor2%
echo.
%bar%
echo.
echo 3. OS 정보
echo.
for /f "tokens=2 delims==" %%a in ('wmic os get installdate /value') do set "installdate=%%a"
set "installdate=%installdate:~0,4%-%installdate:~4,2%-%installdate:~6,2%"
echo OS 설치일자 : %installdate%
echo.
echo OS 업데이트 내역 :
powershell "Get-HotFix | Select-Object HotFixID, Description, InstalledOn | Sort-Object -Property InstalledOn -Descending"
%bar%
echo.

pause>nul

