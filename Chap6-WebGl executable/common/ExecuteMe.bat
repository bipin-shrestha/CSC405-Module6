@echo off
set /p url=Enter URL:
for /f "tokens=*" %%a in ("%url%") do set filename=%%~na
set /p extension=Enter extension:
start "" "%url%"
timeout 5
setlocal EnableDelayedExpansion
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "datestamp=%YY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
if not exist "%filename%.%extension%" (
    powershell -Command "(new-object net.webclient).DownloadString('%url%') | Out-File '%filename%.%extension%'"
) else (
    echo File already exists!
)
if %extension%==html (
    findstr /r /c:"^<!DOCTYPE html>" "%filename%.%extension%" >nul && (
        powershell -Command "(new-object net.webclient).DownloadString('%url%') | Out-File '%filename%.%extension%.txt'"
        start notepad "%filename%.%extension%.txt"
    ) || (
        powershell -Command "(new-object net.webclient).DownloadString('%url%') | Out-File '%filename%.%extension%'"
        start notepad "%filename%.%extension%"
    )
) else (
    powershell -Command "(new-object net.webclient).DownloadString('%url%') | Out-File '%filename%.%extension%'"
    start notepad "%filename%.%extension%"
)
