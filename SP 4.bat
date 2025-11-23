@echo off
if "%1"=="hidden" goto script_caché
(
    echo Set WshShell = CreateObject("WScript.Shell"^)
    echo WshShell.Run "cmd /c ""%~f0"" hidden", 0, False
) > "%temp%\relancer_cache.vbs"

cscript //nologo "%temp%\relancer_cache.vbs"

:: Quitte le script visible
exit

:script_caché
:loop
:: Vérifie si le fichier "stop.flag" existe
if exist "%~dp0stop.flag" (
    del "%~dp0stop.flag" >nul 2>&1
    exit
)

echo [CACHÉ] Script en cours : %time%
timeout /t 2 >nul

:home
for /f "tokens=2 delims==" %%A in ('wmic cpu get loadpercentage /value') do set "cpu=%%A"

for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set datetime=%%G

set HEURE=%datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%

for /f "tokens=2 delims==" %%A in ('wmic OS get FreePhysicalMemory /value') do set FreeMem=%%A

for /f "tokens=2 delims==" %%B in ('wmic OS get TotalVisibleMemorySize /value') do set TotalMem=%%B

set /a "usedRAM = (TotalMem - FreeMem) * 100 / TotalMem"

set RAM=%usedRAM%


set date_actuelle=%date%
for /f "tokens=*" %%a in ("%date_actuelle%") do set date_actuelle=%%a

set date=%date_actuelle:/=-%

if %cpu% lss 0 (goto home)

if exist %date%.txt (
echo %heure% - %cpu% - %RAM% >> %date%.txt
) else (
type nul > %date%.txt
echo %heure% - %cpu% - %RAM% >> %date%.txt
)
goto loop

