@echo off
chcp 65001 >nul
setlocal

:: Устанавливаем пути
set "LOGFILE=%~dp0MoveMods.log"
set "DESTINATION=%APPDATA%\.minecraft\mods"
set "GIT_REPO=https://github.com/kekstm989/Quarion.git"
set "CLONE_DIR=%~dp0QuarionRepo"
set "GIT_INSTALLER=%~dp0GitInstaller.exe"
set "GIT_DOWNLOAD=https://github.com/git-for-windows/git/releases/latest/download/Git-64-bit.exe"

:: Очистка лога (только ошибки будут записываться)
echo. > "%LOGFILE%"

:: Очищаем экран и выводим ASCII-арт
cls
echo ███╗   ██╗███████╗██╗  ██╗ ██████╗ ███╗   ██╗    ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗
echo ████╗  ██║██╔════╝╚██╗██╔╝██╔═══██╗████╗  ██║    ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝
echo ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║██╔██╗ ██║    ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║   
echo ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║██║╚██╗██║    ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║   
echo ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝██║ ╚████║    ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║   
echo ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝   
echo ========================================================
echo          АВТОМАТИЧЕСКАЯ УСТАНОВКА МОДОВ В .minecraft                  
echo ========================================================
echo.

:: Выбор языка
echo Select language / Выберите язык:
echo [1] English
echo [2] Русский
set /p LANG=

if "%LANG%"=="1" (
    set "MSG_START=Starting installation..."
    set "MSG_MC_RUNNING=Minecraft is running! Please close the game before installing mods."
    set "MSG_DONE=Installation completed successfully!"
    set "MSG_CACHE=Using cached mod:"
    set "MSG_DOWNLOAD=Downloading new mod:"
    set "MSG_CLEAN=Do you want to clean the mods folder before installing? (Y/N)"
    set "MSG_GIT_INSTALL=Git is not installed! Installing now..."
    set "MSG_MC_NOT_RUNNING=Minecraft is not running. Continuing..."
    set "MSG_GIT_FOUND=Git is installed. Continuing..."
    set "MSG_MODS_DOWNLOADED=Mods downloaded successfully!"
    set "MSG_TEMP_FILES_REMOVED=Temporary files removed."
) else (
    set "MSG_START=Запуск установки..."
    set "MSG_MC_RUNNING=Minecraft запущен! Закройте игру перед установкой модов."
    set "MSG_DONE=Установка завершена успешно!"
    set "MSG_CACHE=Используется кешированный мод:"
    set "MSG_DOWNLOAD=Скачивание нового мода:"
    set "MSG_CLEAN=Очистить папку mods перед установкой новых модов? (Y/N)"
    set "MSG_GIT_INSTALL=Git не установлен! Начинаю установку..."
    set "MSG_MC_NOT_RUNNING=Minecraft не запущен. Продолжаем..."
    set "MSG_GIT_FOUND=Git установлен. Продолжаем..."
    set "MSG_MODS_DOWNLOADED=Моды скачаны успешно!"
    set "MSG_TEMP_FILES_REMOVED=Временные файлы удалены."
)

echo ========================================================
echo %MSG_START%
echo ========================================================

:: [1/7] Проверяем, запущен ли Minecraft
echo [1/7] Проверка, запущен ли Minecraft...
tasklist | find /i "javaw.exe" >nul
if %errorlevel%==0 (
    echo Ошибка: %MSG_MC_RUNNING%
    echo [%date% %time%] Ошибка: Minecraft был запущен! >> "%LOGFILE%"
    pause
    exit /b
)
echo [1/7] %MSG_MC_NOT_RUNNING%
echo.

:: [2/7] Установка Git, если его нет
echo [2/7] Проверка наличия Git...
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo %MSG_GIT_INSTALL%
    powershell -Command "& {Invoke-WebRequest -Uri '%GIT_DOWNLOAD%' -OutFile '%GIT_INSTALLER%'}"
    start /wait %GIT_INSTALLER% /SILENT
    del /Q "%GIT_INSTALLER%"
    set "PATH=%ProgramFiles%\Git\bin;%PATH%"
)
echo [2/7] %MSG_GIT_FOUND%
echo.

:: [3/7] Очистка папки mods перед установкой (по желанию)
echo [3/7] %MSG_CLEAN%
set /p CLEAN_MODS=
if /I "%CLEAN_MODS%"=="Y" (
    del /Q "%DESTINATION%\*.jar" 2>nul
    echo Очистка завершена!
)
echo.

:: [4/7] Проверка и скачивание репозитория
if exist "%CLONE_DIR%" (
    echo Updating repository...
    cd "%CLONE_DIR%" && git pull >nul 2>&1
) else (
    echo Cloning repository...
    git clone --depth=1 "%GIT_REPO%" "%CLONE_DIR%" >nul 2>&1
)
echo [4/7] %MSG_MODS_DOWNLOADED%
echo.

:: [5/7] Кэширование и копирование модов
for %%F in ("%CLONE_DIR%\QuarionMods\mods\*.jar") do (
    if exist "%DESTINATION%\%%~nxF" (
        echo %MSG_CACHE% %%~nxF
    ) else (
        echo %MSG_DOWNLOAD% %%~nxF
        xcopy /Y "%%F" "%DESTINATION%" >nul
    )
)
echo.

:: [6/7] Удаление временных файлов
rd /s /q "%CLONE_DIR%" >nul 2>&1
echo [6/7] %MSG_TEMP_FILES_REMOVED%
echo.

:: [7/7] Завершение
echo ========================================================
echo %MSG_DONE%
echo ========================================================

:: Остановка перед закрытием
pause
