@echo off
setlocal EnableExtensions
chcp 65001 >nul
rem ==========================================================================
rem  Push-Update.bat - commit + push update.xml len GitHub
rem  Dat file nay trong thu muc repo phat hanh (cung cho voi update.xml):
rem    D:\AI\Codex\Loan12SuQuan\iLSQ_Release\ilsq
rem  Cach dung:
rem    Push-Update.bat                 -> message mac dinh "v<version trong update.xml>"
rem    Push-Update.bat "noi dung"      -> dung "noi dung" lam message commit
rem ==========================================================================

cd /d "%~dp0"

where git >nul 2>&1
if errorlevel 1 (
    echo [LOI] Khong tim thay git. Cai Git for Windows roi chay lai.
    goto :fail
)

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [LOI] Thu muc "%cd%" khong phai git repo.
    goto :fail
)

if not exist "update.xml" (
    echo [LOI] Khong thay update.xml trong "%cd%".
    goto :fail
)

for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set "BRANCH=%%b"
if "%BRANCH%"=="HEAD" (
    echo [LOI] Repo dang o trang thai detached HEAD. Checkout nhanh chinh truoc.
    goto :fail
)

rem Message mac dinh lay theo <version> trong update.xml, vi du "v1.0.2.31" (giong cac commit truoc).
set "VER="
for /f "delims=" %%v in ('powershell -NoProfile -Command "$m=Select-String -Path 'update.xml' -Pattern '<version>([^<]+)</version>'; if($m){$m.Matches[0].Groups[1].Value}"') do set "VER=%%v"
if defined VER (set "MSG=v%VER%") else (
    for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm'"') do set "MSG=Update update.xml %%t"
)
if not "%~1"=="" set "MSG=%~1"

echo === Repo  : %cd%
echo === Nhanh : %BRANCH%
echo === Commit: %MSG%
echo.

echo [1/4] Lay ban moi nhat tu GitHub...
git pull --rebase --autostash origin "%BRANCH%"
if errorlevel 1 (
    echo [LOI] git pull that bai. Xu ly xung dot roi chay lai.
    goto :fail
)

echo [2/4] Them update.xml...
git add -- "update.xml"
if errorlevel 1 goto :fail

git diff --cached --quiet -- "update.xml"
if not errorlevel 1 (
    echo update.xml khong co thay doi nao - khong can commit.
    goto :done
)

echo [3/4] Commit...
git commit -m "%MSG%" -- "update.xml"
if errorlevel 1 (
    echo [LOI] git commit that bai.
    goto :fail
)

echo [4/4] Push len GitHub...
git push origin "%BRANCH%"
if errorlevel 1 (
    echo [LOI] git push that bai. Kiem tra mang / quyen truy cap GitHub.
    goto :fail
)

echo.
echo === XONG: da push update.xml len origin/%BRANCH%.
goto :done

:fail
echo.
echo === THAT BAI.
pause
exit /b 1

:done
echo.
pause
exit /b 0
