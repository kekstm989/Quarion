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
    set "MSG_CLEAN_START=Cleaning mods folder..."
    set "MSG_CLEAN_DONE=Cleaning completed!"
    set "MSG_GIT_INSTALL=Git is not installed! Installing now..."
    set "MSG_CHECK_CACHE=Checking cached mods..."
    set "MSG_CHECK_REPO=Checking and updating repository..."
    set "MSG_FILES_DELETED=Temporary files removed."
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
    set "MSG_CLEAN_START=Очистка папки mods..."
    set "MSG_CLEAN_DONE=Очистка завершена!"
    set "MSG_GIT_INSTALL=Git не установлен! Начинаю установку..."
    set "MSG_CHECK_CACHE=Проверка кеша модов..."
    set "MSG_CHECK_REPO=Проверка и обновление репозитория..."
    set "MSG_FILES_DELETED=Временные файлы удалены."
    set "MSG_MC_NOT_RUNNING=Minecraft не запущен. Продолжаем..."
    set "MSG_GIT_FOUND=Git установлен. Продолжаем..."
    set "MSG_MODS_DOWNLOADED=Моды скачаны успешно!"
    set "MSG_TEMP_FILES_REMOVED=Временные файлы удалены."
)

echo ========================================================
echo %MSG_START%
echo ========================================================

:: [1/8] Проверяем, запущен ли Minecraft
echo [1/8] %MSG_CHECK_CACHE%
tasklist | find /i "javaw.exe" >nul
if %errorlevel%==0 (
    echo Ошибка: %MSG_MC_RUNNING%
    echo [%date% %time%] Ошибка: Minecraft был запущен во время установки! >> "%LOGFILE%"
    pause
    exit /b
)
echo [1/8] %MSG_MC_NOT_RUNNING%
echo.

:: [2/8] Установка Git, если его нет
echo [2/8] Проверка наличия Git...
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo %MSG_GIT_INSTALL%
    powershell -Command "& {Invoke-WebRequest -Uri '%GIT_DOWNLOAD%' -OutFile '%GIT_INSTALLER%'}"
    start /wait %GIT_INSTALLER% /SILENT
    del /Q "%GIT_INSTALLER%"
    set "PATH=%ProgramFiles%\Git\bin;%PATH%"
)
echo [2/8] %MSG_GIT_FOUND%
echo.

:: [3/8] Очистка папки mods перед установкой (по желанию)
echo [3/8] %MSG_CLEAN%
set /p CLEAN_MODS=
if /I "%CLEAN_MODS%"=="Y" (
    echo %MSG_CLEAN_START%
    del /Q "%DESTINATION%\*.jar" 2>nul
    echo %MSG_CLEAN_DONE%
)
echo.

:: [4/8] Проверка кэша модов
echo [4/8] %MSG_CHECK_REPO%
if exist "%CLONE_DIR%" (
    echo Updating repository...
    cd "%CLONE_DIR%" && git pull >nul 2>&1
) else (
    echo Cloning repository...
    git clone --depth=1 "%GIT_REPO%" "%CLONE_DIR%" >nul 2>&1
)

if %errorlevel% neq 0 (
    echo Ошибка при скачивании репозитория!
    echo [%date% %time%] Ошибка: Репозиторий не скачан! >> "%LOGFILE%"
    pause
    exit /b
)
echo [4/8] %MSG_MODS_DOWNLOADED%
echo.

:: [7/8] Удаление временных файлов
rd /s /q "%CLONE_DIR%" >nul 2>&1
echo [7/8] %MSG_TEMP_FILES_REMOVED%
echo.

:: [8/8] Завершающее сообщение
echo ========================================================
echo %MSG_DONE%
echo ========================================================

:: Записываем ошибки в лог, если были
if %errorlevel% neq 0 (
    echo [%date% %time%] Ошибка при установке модов! >> "%LOGFILE%"
)

:: Остановка перед закрытием
pause
